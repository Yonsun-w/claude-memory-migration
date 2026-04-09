---
name: claude-memory-migration
description: Claude Code 统一记忆迁移工具。支持导出旧电脑的所有记忆和配置，在新电脑统一管理并恢复。解决路径依赖问题，实现无缝迁移。
allowed-tools: Bash, Read, Write, Edit, Glob, Grep, AskUserQuestion
---

# Claude Code Memory Migration Skill

## 🎯 Goal

提供一键式的 Claude Code 记忆迁移方案，解决换电脑时的路径依赖问题，让所有对话历史、项目记忆、技能配置完整保留。

## 🌟 核心特性

### 1. 统一项目中心
在新电脑创建 `~/.claude-projects/` 统一管理所有项目，不再依赖原始路径。

### 2. 友好命名
自动将难读的路径编码（`-Users-yonsun-wjh-sum`）转为友好名称（`wjh-sum`）。

### 3. 符号链接支持
支持将统一目录链接到真实项目路径，实现双向同步。

### 4. 完整记忆保留
- ✅ 对话历史（`.jsonl` 文件）
- ✅ 项目记忆（`memory/` 目录）
- ✅ 技能配置
- ✅ 插件设置
- ✅ 全局配置

## 📋 使用场景

触发此 skill 当用户说：
- "我要换电脑了，怎么迁移 Claude 的记忆？"
- "帮我导出 Claude 配置"
- "新电脑如何恢复 Claude 的对话历史？"
- "/claude-memory export"
- "/claude-memory import"

## 🚀 工作流程

### 阶段 1: 导出（旧电脑）

运行 `/claude-memory export` 或直接说"导出 Claude 配置"。

**执行步骤**：
1. 扫描 `~/.claude/` 目录
2. 分析所有项目路径和记忆
3. 生成项目映射表（`project-mapping.json`）
4. 打包完整数据（`.claude` 目录）
5. 创建便携压缩包

**输出**：
```
~/claude-export-YYYYMMDD-HHMMSS/
  ├── claude-data.tar.gz          # 完整 .claude 数据
  ├── project-mapping.json        # 项目路径映射
  ├── MANIFEST.txt                # 人类可读清单
  ├── README.md                   # 迁移说明
  └── claude-unified-migration.sh # 导入脚本

~/claude-export-YYYYMMDD-HHMMSS.tar.gz  # 最终压缩包
```

**用户体验**：
```
📋 扫描项目目录...
===========================================================

🧠 wjh-sum
   路径: /Users/yonsun/wjh-sum
   会话: 15, 大小: 256.3 KB

💬 Project-ai-coding
   路径: /Users/yonsun/Project/ai-coding
   会话: 42, 大小: 1024.7 KB

===========================================================
✓ 找到 58 个项目，将迁移 35 个
===========================================================

📦 压缩包: ~/claude-export-20260409-163000.tar.gz
```

### 阶段 2: 导入（新电脑）

将压缩包复制到新电脑后，运行 `/claude-memory import` 或说"导入 Claude 配置"。

**执行步骤**：
1. 检查是否有现有配置（提示备份）
2. 解压 `.claude` 数据
3. 创建统一项目中心 `~/.claude-projects/`
4. 重组项目结构，使用友好命名
5. 自动更新配置中的用户名
6. 重建 Claude 的项目索引

**输出**：
```
~/.claude-projects/              # 统一项目中心
  ├── wjh-sum/                   # 友好命名
  │   ├── *.jsonl                # 对话历史
  │   └── memory/                # 项目记忆
  ├── Project-ai-coding/
  └── ...
```

**用户体验**：
```
🔄 重组项目结构
===========================================================

🧠 wjh-sum
   统一路径: /Users/newuser/.claude-projects/wjh-sum

📁 Project-ai-coding
   统一路径: /Users/newuser/.claude-projects/Project-ai-coding

===========================================================
✓ 成功迁移 35 个项目
===========================================================

现在可以启动 Claude Code，所有项目记忆都已恢复！
```

### 阶段 3: 符号链接（可选）

如果新电脑有真实项目路径，运行 `/claude-memory link`。

**交互流程**：
```
📁 Project-ai-coding
   原路径: /Users/yonsun/Project/ai-coding
   统一路径: /Users/newuser/.claude-projects/Project-ai-coding
   ✓ 检测到真实路径: /Users/newuser/work/ai-coding
   创建链接? (Y/n): y
   ✓ 已创建符号链接

📁 wjh-sum
   原路径: /Users/yonsun/wjh-sum
   统一路径: /Users/newuser/.claude-projects/wjh-sum
   ⚠ 真实路径不存在
   输入自定义路径（留空跳过）: /Users/newuser/Documents/wjh-sum
   ✓ 已创建符号链接
```

**结果**：
```bash
~/.claude-projects/Project-ai-coding → ~/work/ai-coding
```

### 阶段 4: 状态查看

运行 `/claude-memory status` 查看迁移状态。

**输出示例**：
```
📊 Claude Code 迁移状态
===========================================================

统一目录: /Users/newuser/.claude-projects
项目数量: 35

------------------------------------------------------------
项目名                          类型        记忆
------------------------------------------------------------
Project-ai-coding               链接        🧠
  → /Users/newuser/work/ai-coding
wjh-sum                         本地        -
ai-project-codeTrace            本地        🧠
===========================================================

迁移日期: 2026-04-09T08:30:00
原用户: yonsun → 新用户: newuser
```

## 📝 Commands

- `/claude-memory export` - 导出所有配置和记忆
- `/claude-memory import` - 导入并重组项目结构
- `/claude-memory link` - 创建符号链接到真实路径
- `/claude-memory status` - 查看迁移状态
- `/claude-memory analyze` - 分析当前使用情况

## 🔧 实现细节

### 项目分类逻辑

根据原始路径自动分类：
- `temp`: `/tmp/`、`/private/var/` 等临时目录（跳过迁移）
- `projects`: 包含 `/Project/` 的路径
- `ai-projects`: 包含 `/ai-project/` 的路径
- `home`: 用户主目录
- 其他：按路径第一层分类

### 迁移过滤规则

只迁移有价值的项目：
- ✅ 大小 > 1KB
- ✅ 有对话历史（`.jsonl` 文件）
- ✅ 有项目记忆（`memory/` 目录）
- ❌ 跳过临时目录

### 路径映射规则

生成友好名称：
```python
# 原路径: /Users/yonsun/Project/ai-coding
# 友好名称: Project-ai-coding

# 原路径: /Users/yonsun/wjh-sum
# 友好名称: wjh-sum
```

提取路径最后 3 层作为名称，避免过长。

## 💡 使用示例

### 场景 1: 完整迁移

**旧电脑**：
```
用户: "我要换电脑了，帮我导出 Claude 配置"

Claude:
1. 扫描 58 个项目
2. 找到 35 个有价值的项目
3. 生成压缩包: claude-export-20260409.tar.gz
4. 提示: 复制到新电脑后运行导入命令
```

**新电脑**：
```
用户: "导入 Claude 配置"

Claude:
1. 检测到导出包
2. 备份现有配置
3. 创建统一目录 ~/.claude-projects/
4. 迁移 35 个项目
5. 完成！所有记忆已恢复
```

### 场景 2: 部分链接

```
用户: "我的工作项目在 ~/work 下，帮我创建链接"

Claude:
1. 扫描统一目录
2. 自动检测 ~/work/ai-coding 存在
3. 创建符号链接
4. Claude 会同时记住两个位置的上下文
```

## 📦 技术栈

- **Bash**: 文件操作、git 命令、tar 打包
- **Python3**: 复杂逻辑处理、JSON 解析、路径映射
- **符号链接**: `ln -s` 实现目录链接

## 🔒 安全性

- 导出前备份现有配置
- 导入时提示用户确认覆盖
- 过滤敏感临时目录
- 生成迁移记录可追溯

## 📊 统计分析

支持分析当前使用情况：
```bash
/claude-memory analyze
```

输出：
```
📊 Claude Code 使用统计
===========================================================

总项目数: 58
总会话数: 234
总大小: 65.42 MB

📁 按类别统计
------------------------------------------------------------
projects             18个项目   145个会话    32.56 MB
ai-project           12个项目    56个会话    18.32 MB
temp                 20个项目    12个会话     2.15 MB

🔝 Top 10 项目（按大小）
------------------------------------------------------------
 1. [  1024.7 MB]  42会话  /Users/yonsun/Project/ai-coding
 2. [   256.3 MB]  15会话  /Users/yonsun/wjh-sum
```

## 🔍 故障排查

### 问题 1: 导入后 Claude 找不到项目

**原因**: 项目索引未更新

**解决**:
```bash
rm -rf ~/.claude/projects
# 重新运行导入
```

### 问题 2: 符号链接失效

**原因**: 目标路径不存在

**解决**:
```bash
/claude-memory status  # 查看链接状态
/claude-memory link    # 重新配置链接
```

## 📚 依赖

- Bash 4.0+
- Python 3.6+
- tar
- git (可选，用于符号链接场景)

## 📄 文件清单

```
~/.claude/skills/claude-memory-migration/
  ├── SKILL.md                        # 本文件
  ├── skill.json                      # Skill 元数据
  ├── package.json                    # NPM 发布配置
  ├── README.md                       # 用户文档
  ├── LICENSE                         # MIT 许可证
  ├── scripts/
  │   ├── export.sh                   # 导出脚本
  │   ├── import.sh                   # 导入脚本
  │   ├── link.sh                     # 符号链接脚本
  │   ├── status.sh                   # 状态查看脚本
  │   └── analyze.sh                  # 分析脚本
  └── .author-card/
      └── show-card.sh                # 作者卡片
```

## 🎨 Show Author Card

在完成迁移后显示作者信息：

```bash
~/.claude/skills/skill-author-card/show-card.sh "claude-memory-migration" --frequency once
```

---

**版本**: 1.0.0
**作者**: yonsun
**许可**: MIT
**更新日期**: 2026-04-09
