#!/bin/bash

# Claude Code 统一迁移方案
# 核心思想：在新电脑创建统一的项目中心 + 符号链接映射

set -e

VERSION="2.0.0"
CLAUDE_DIR="$HOME/.claude"
UNIFIED_ROOT="$HOME/.claude-projects"  # 统一的项目中心

# 颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[✓]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[!]${NC} $1"; }
log_error() { echo -e "${RED}[✗]${NC} $1"; }
log_step() { echo -e "${CYAN}[STEP]${NC} $1"; }

# ============ 阶段 1: 导出（旧电脑）============
export_unified() {
    log_step "开始统一导出..."

    EXPORT_DIR="$HOME/claude-export-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$EXPORT_DIR"

    # 1. 导出完整的 .claude 目录
    log_info "正在打包 .claude 目录..."
    tar -czf "$EXPORT_DIR/claude-data.tar.gz" \
        -C "$HOME" \
        --exclude='.claude/debug' \
        --exclude='.claude/shell-snapshots' \
        --exclude='.claude/session-env' \
        --exclude='.claude/plugins/cache' \
        --exclude='.claude/plugins/marketplaces' \
        --exclude='.claude/paste-cache' \
        .claude

    # 2. 生成项目映射表
    log_info "正在生成项目映射表..."

    python3 - "$CLAUDE_DIR" "$EXPORT_DIR" "$USER" << 'PYTHON_EXPORT'
import sys
import os
import json
from pathlib import Path
from datetime import datetime

claude_dir = sys.argv[1]
export_dir = sys.argv[2]
old_user = sys.argv[3]

projects_dir = os.path.join(claude_dir, 'projects')

mapping = {
    'export_version': '2.0.0',
    'export_date': datetime.utcnow().isoformat() + 'Z',
    'old_username': old_user,
    'old_home': os.path.expanduser('~'),
    'projects': []
}

print("\n" + "="*60)
print("📋 扫描项目目录...")
print("="*60 + "\n")

for project_dir in sorted(os.listdir(projects_dir)):
    project_path = os.path.join(projects_dir, project_dir)
    if not os.path.isdir(project_path):
        continue

    # 解码原始路径
    original_path = project_dir.replace('-', '/')

    # 统计会话
    jsonl_files = [f for f in os.listdir(project_path) if f.endswith('.jsonl')]
    session_count = len(jsonl_files)

    # 统计大小
    total_size = 0
    for root, dirs, files in os.walk(project_path):
        total_size += sum(os.path.getsize(os.path.join(root, f)) for f in files)

    # 检查是否有记忆
    has_memory = os.path.exists(os.path.join(project_path, 'memory'))

    # 分类
    category = 'other'
    if '/tmp/' in original_path or '/private/var/' in original_path:
        category = 'temp'
    elif original_path.startswith('/Users/'):
        parts = original_path.split('/')
        if len(parts) >= 4:
            category = parts[3]  # 第一层目录
        else:
            category = 'home'

    # 生成友好的项目名
    path_parts = [p for p in original_path.split('/') if p]
    if path_parts:
        friendly_name = '-'.join(path_parts[-3:]) if len(path_parts) >= 3 else '-'.join(path_parts)
    else:
        friendly_name = 'root'

    project_info = {
        'encoded_name': project_dir,
        'original_path': original_path,
        'friendly_name': friendly_name,
        'category': category,
        'session_count': session_count,
        'total_size_bytes': total_size,
        'has_memory': has_memory,
        'should_migrate': total_size > 1024 or has_memory or session_count > 0  # 有价值的项目
    }

    mapping['projects'].append(project_info)

    if project_info['should_migrate']:
        emoji = '🧠' if has_memory else '💬'
        print(f"{emoji} {friendly_name}")
        print(f"   路径: {original_path}")
        print(f"   会话: {session_count}, 大小: {total_size/1024:.1f} KB")
        print()

# 统计
total = len(mapping['projects'])
migrate_count = sum(1 for p in mapping['projects'] if p['should_migrate'])
mapping['statistics'] = {
    'total_projects': total,
    'projects_to_migrate': migrate_count,
    'skipped_projects': total - migrate_count
}

# 保存映射
mapping_file = os.path.join(export_dir, 'project-mapping.json')
with open(mapping_file, 'w') as f:
    json.dump(mapping, f, indent=2, ensure_ascii=False)

print("="*60)
print(f"✓ 找到 {total} 个项目，将迁移 {migrate_count} 个")
print("="*60 + "\n")

# 生成人类可读的清单
manifest = os.path.join(export_dir, 'MANIFEST.txt')
with open(manifest, 'w', encoding='utf-8') as f:
    f.write("Claude Code 导出清单\n")
    f.write("="*60 + "\n")
    f.write(f"导出时间: {mapping['export_date']}\n")
    f.write(f"原用户名: {old_user}\n")
    f.write(f"原主目录: {mapping['old_home']}\n")
    f.write(f"项目总数: {total}\n")
    f.write(f"迁移数量: {migrate_count}\n")
    f.write("\n" + "="*60 + "\n")
    f.write("项目列表（按类别分组）\n")
    f.write("="*60 + "\n\n")

    by_category = {}
    for p in mapping['projects']:
        if not p['should_migrate']:
            continue
        cat = p['category']
        if cat not in by_category:
            by_category[cat] = []
        by_category[cat].append(p)

    for cat in sorted(by_category.keys()):
        f.write(f"\n[{cat}]\n")
        f.write("-"*60 + "\n")
        for p in sorted(by_category[cat], key=lambda x: x['total_size_bytes'], reverse=True):
            mem_flag = " [记忆]" if p['has_memory'] else ""
            f.write(f"  • {p['friendly_name']}{mem_flag}\n")
            f.write(f"    原路径: {p['original_path']}\n")
            f.write(f"    {p['session_count']} 会话, {p['total_size_bytes']/1024:.1f} KB\n\n")

print(f"📄 已生成清单: {manifest}")
PYTHON_EXPORT

    # 3. 创建 README
    cat > "$EXPORT_DIR/README.md" << 'EOF'
# Claude Code 统一迁移包 v2.0

## 📦 包含内容

- `claude-data.tar.gz` - 完整的 .claude 目录（包含所有项目数据）
- `project-mapping.json` - 项目路径映射表
- `MANIFEST.txt` - 人类可读的项目清单
- `claude-unified-migration.sh` - 导入脚本

## 🎯 新电脑统一方案

在新电脑上，所有项目会统一存放在：
```
~/.claude-projects/
  ├── Project-ai-coding/
  ├── wjh-sum/
  ├── ai-project-codeTrace/
  └── ...
```

Claude 会自动识别这些项目，无需关心原路径是否存在。

## 🚀 导入步骤

```bash
# 1. 解压迁移包
tar -xzf claude-export-*.tar.gz
cd claude-export-*

# 2. 运行导入
./claude-unified-migration.sh import

# 3. （可选）创建符号链接到真实项目路径
./claude-unified-migration.sh link
```

## 🔗 符号链接模式

如果新电脑有部分项目的真实路径（如工作项目），可以：
- 自动创建符号链接：统一目录 → 真实路径
- Claude 会同时记住两个位置的上下文
EOF

    # 4. 复制脚本
    cp "$0" "$EXPORT_DIR/"
    chmod +x "$EXPORT_DIR/claude-unified-migration.sh"

    # 5. 创建最终压缩包
    log_info "正在创建最终压缩包..."
    tar -czf "$EXPORT_DIR.tar.gz" -C "$(dirname "$EXPORT_DIR")" "$(basename "$EXPORT_DIR)"

    log_success "导出完成！"
    echo ""
    echo "📁 导出目录: $EXPORT_DIR"
    echo "📦 压缩包: $EXPORT_DIR.tar.gz"
    echo ""
    log_info "请将压缩包复制到新电脑，然后运行："
    echo "  tar -xzf $(basename "$EXPORT_DIR.tar.gz")"
    echo "  cd $(basename "$EXPORT_DIR")"
    echo "  ./claude-unified-migration.sh import"
}

# ============ 阶段 2: 导入（新电脑）============
import_unified() {
    log_step "开始统一导入..."

    # 检查文件
    if [ ! -f "claude-data.tar.gz" ] || [ ! -f "project-mapping.json" ]; then
        log_error "未找到导出文件，请在导出目录中运行"
        exit 1
    fi

    # 读取映射
    OLD_USER=$(python3 -c "import json; print(json.load(open('project-mapping.json'))['old_username'])")
    NEW_USER="$USER"

    echo ""
    log_info "原用户: $OLD_USER"
    log_info "新用户: $NEW_USER"
    log_info "统一目录: $UNIFIED_ROOT"
    echo ""

    # 1. 备份现有配置
    if [ -d "$CLAUDE_DIR" ]; then
        log_warn "检测到已有 .claude 目录"
        read -p "是否备份现有配置? (Y/n): " backup_response
        if [[ ! "$backup_response" =~ ^[Nn]$ ]]; then
            BACKUP="$CLAUDE_DIR.backup-$(date +%Y%m%d-%H%M%S)"
            log_info "备份到: $BACKUP"
            cp -r "$CLAUDE_DIR" "$BACKUP"
        fi

        read -p "是否覆盖 .claude 目录? (y/N): " overwrite_response
        if [[ "$overwrite_response" =~ ^[Yy]$ ]]; then
            rm -rf "$CLAUDE_DIR"
        else
            log_error "已取消导入"
            exit 1
        fi
    fi

    # 2. 解压 .claude 目录
    log_info "正在解压 .claude 数据..."
    tar -xzf claude-data.tar.gz -C "$HOME"

    # 3. 创建统一项目中心
    log_info "正在创建统一项目目录..."
    mkdir -p "$UNIFIED_ROOT"

    # 4. 重组项目结构
    log_info "正在重组项目结构..."

    python3 - "$CLAUDE_DIR" "$UNIFIED_ROOT" "$OLD_USER" "$NEW_USER" << 'PYTHON_IMPORT'
import sys
import os
import json
import shutil
from pathlib import Path

claude_dir = sys.argv[1]
unified_root = sys.argv[2]
old_user = sys.argv[3]
new_user = sys.argv[4]

# 读取映射
with open('project-mapping.json', 'r') as f:
    mapping = json.load(f)

projects_dir = os.path.join(claude_dir, 'projects')
new_projects_dir = os.path.join(claude_dir, 'projects-new')
os.makedirs(new_projects_dir, exist_ok=True)

print("\n" + "="*60)
print("🔄 重组项目结构")
print("="*60 + "\n")

# 创建新映射记录
new_mapping_record = {
    'migration_date': __import__('datetime').datetime.now().isoformat(),
    'old_user': old_user,
    'new_user': new_user,
    'unified_root': unified_root,
    'projects': []
}

for project in mapping['projects']:
    if not project['should_migrate']:
        continue

    old_encoded = project['encoded_name']
    friendly_name = project['friendly_name']

    # 旧项目路径
    old_project_dir = os.path.join(projects_dir, old_encoded)
    if not os.path.exists(old_project_dir):
        continue

    # 在统一目录创建项目
    unified_project_dir = os.path.join(unified_root, friendly_name)
    os.makedirs(unified_project_dir, exist_ok=True)

    # 复制项目数据
    for item in os.listdir(old_project_dir):
        src = os.path.join(old_project_dir, item)
        dst = os.path.join(unified_project_dir, item)
        if os.path.isdir(src):
            shutil.copytree(src, dst, dirs_exist_ok=True)
        else:
            shutil.copy2(src, dst)

    # 新的编码名称（基于统一路径）
    new_path = unified_project_dir
    new_encoded = new_path.replace('/', '-')

    # 在 projects-new 创建符号链接
    new_project_link = os.path.join(new_projects_dir, new_encoded)
    if not os.path.exists(new_project_link):
        os.symlink(unified_project_dir, new_project_link)

    # 记录映射
    new_mapping_record['projects'].append({
        'original_path': project['original_path'],
        'old_encoded': old_encoded,
        'unified_path': unified_project_dir,
        'new_encoded': new_encoded,
        'friendly_name': friendly_name,
        'has_memory': project['has_memory']
    })

    emoji = '🧠' if project['has_memory'] else '📁'
    print(f"{emoji} {friendly_name}")
    print(f"   统一路径: {unified_project_dir}")
    print()

# 替换 projects 目录
shutil.rmtree(projects_dir)
os.rename(new_projects_dir, projects_dir)

# 保存映射记录
with open(os.path.join(claude_dir, 'unified-migration.json'), 'w') as f:
    json.dump(new_mapping_record, f, indent=2, ensure_ascii=False)

print("="*60)
print(f"✓ 成功迁移 {len(new_mapping_record['projects'])} 个项目")
print("="*60 + "\n")
PYTHON_IMPORT

    # 5. 更新配置中的用户名
    log_info "正在更新配置文件..."
    if [ -f "$CLAUDE_DIR/settings.json" ]; then
        sed -i '' "s|/Users/$OLD_USER|/Users/$NEW_USER|g" "$CLAUDE_DIR/settings.json" 2>/dev/null || \
        sed -i "s|/Users/$OLD_USER|/Users/$NEW_USER|g" "$CLAUDE_DIR/settings.json"
    fi
    if [ -f "$CLAUDE_DIR/settings.local.json" ]; then
        sed -i '' "s|/Users/$OLD_USER|/Users/$NEW_USER|g" "$CLAUDE_DIR/settings.local.json" 2>/dev/null || \
        sed -i "s|/Users/$OLD_USER|/Users/$NEW_USER|g" "$CLAUDE_DIR/settings.local.json"
    fi

    log_success "导入完成！"
    echo ""
    echo "📁 统一项目目录: $UNIFIED_ROOT"
    echo "📋 迁移记录: $CLAUDE_DIR/unified-migration.json"
    echo ""
    log_info "现在可以启动 Claude Code，所有项目记忆都已恢复！"
    echo ""
    log_info "（可选）如果新电脑有真实项目路径，运行："
    echo "  $0 link"
}

# ============ 阶段 3: 创建符号链接（可选）============
create_symlinks() {
    log_step "创建符号链接到真实项目路径..."

    if [ ! -f "$CLAUDE_DIR/unified-migration.json" ]; then
        log_error "未找到迁移记录，请先运行 import"
        exit 1
    fi

    python3 - "$CLAUDE_DIR" "$UNIFIED_ROOT" << 'PYTHON_LINK'
import sys
import os
import json

claude_dir = sys.argv[1]
unified_root = sys.argv[2]

with open(os.path.join(claude_dir, 'unified-migration.json'), 'r') as f:
    migration = json.load(f)

new_user = migration['new_user']

print("\n" + "="*60)
print("🔗 配置符号链接")
print("="*60 + "\n")

for project in migration['projects']:
    unified_path = project['unified_path']
    original_path = project['original_path']
    friendly_name = project['friendly_name']

    # 自动替换用户名
    suggested_path = original_path.replace(migration['old_user'], new_user)

    print(f"📁 {friendly_name}")
    print(f"   原路径: {original_path}")
    print(f"   统一路径: {unified_path}")

    if os.path.exists(suggested_path):
        print(f"   ✓ 检测到真实路径: {suggested_path}")
        response = input(f"   创建链接? (Y/n): ").strip()
        if not response or response.lower() == 'y':
            # 删除统一目录的内容，创建链接
            import shutil
            shutil.rmtree(unified_path)
            os.symlink(suggested_path, unified_path)
            print(f"   ✓ 已创建符号链接")
    else:
        print(f"   ⚠ 真实路径不存在: {suggested_path}")
        custom = input(f"   输入自定义路径（留空跳过）: ").strip()
        if custom and os.path.exists(custom):
            import shutil
            shutil.rmtree(unified_path)
            os.symlink(custom, unified_path)
            print(f"   ✓ 已创建符号链接到: {custom}")

    print()

print("="*60)
print("✓ 符号链接配置完成")
print("="*60 + "\n")
PYTHON_LINK

    log_success "符号链接创建完成！"
}

# ============ 阶段 4: 状态查看 ============
show_status() {
    log_step "查看迁移状态..."

    if [ ! -d "$UNIFIED_ROOT" ]; then
        log_warn "统一目录不存在: $UNIFIED_ROOT"
        exit 1
    fi

    python3 - "$UNIFIED_ROOT" "$CLAUDE_DIR" << 'PYTHON_STATUS'
import sys
import os
import json

unified_root = sys.argv[1]
claude_dir = sys.argv[2]

print("\n" + "="*60)
print("📊 Claude Code 迁移状态")
print("="*60 + "\n")

# 统计项目
projects = [d for d in os.listdir(unified_root) if os.path.isdir(os.path.join(unified_root, d))]

print(f"统一目录: {unified_root}")
print(f"项目数量: {len(projects)}\n")

print("-"*60)
print(f"{'项目名':<30} {'类型':<10} {'记忆':<6}")
print("-"*60)

for proj in sorted(projects):
    proj_path = os.path.join(unified_root, proj)

    # 检查是否是符号链接
    is_link = os.path.islink(proj_path)
    link_type = "链接" if is_link else "本地"

    # 检查是否有记忆
    has_memory = os.path.exists(os.path.join(proj_path, 'memory'))
    memory_flag = "🧠" if has_memory else "-"

    print(f"{proj:<30} {link_type:<10} {memory_flag:<6}")

    if is_link:
        target = os.readlink(proj_path)
        print(f"  → {target}")

print("="*60 + "\n")

# 读取迁移记录
migration_file = os.path.join(claude_dir, 'unified-migration.json')
if os.path.exists(migration_file):
    with open(migration_file, 'r') as f:
        migration = json.load(f)
    print(f"迁移日期: {migration['migration_date']}")
    print(f"原用户: {migration['old_user']} → 新用户: {migration['new_user']}")
PYTHON_STATUS
}

# ============ 主入口 ============
show_menu() {
    echo ""
    echo "╔════════════════════════════════════════════════╗"
    echo "║   Claude Code 统一迁移方案 v${VERSION}           ║"
    echo "╚════════════════════════════════════════════════╝"
    echo ""
    echo "1) 📤 导出（在旧电脑运行）"
    echo "2) 📥 导入（在新电脑运行）"
    echo "3) 🔗 创建符号链接（可选）"
    echo "4) 📊 查看状态"
    echo "5) ❌ 退出"
    echo ""
    read -p "请选择 [1-5]: " choice

    case $choice in
        1) export_unified ;;
        2) import_unified ;;
        3) create_symlinks ;;
        4) show_status ;;
        5) exit 0 ;;
        *) log_error "无效选择"; show_menu ;;
    esac
}

# 命令行参数
if [ $# -eq 0 ]; then
    show_menu
else
    case $1 in
        export) export_unified ;;
        import) import_unified ;;
        link) create_symlinks ;;
        status) show_status ;;
        *)
            echo "用法: $0 [export|import|link|status]"
            exit 1
            ;;
    esac
fi
