# Claude Memory Migration 🚀

Claude Code 统一记忆迁移工具 - 换电脑不丢失任何记忆！

## 🌟 特性

- ✅ **统一项目中心**: 所有项目集中在 `~/.claude-projects/`
- ✅ **友好命名**: `wjh-sum` 代替 `-Users-yonsun-wjh-sum`
- ✅ **完整记忆**: 对话历史、项目记忆、技能配置全保留
- ✅ **符号链接**: 支持链接到真实项目路径
- ✅ **路径独立**: 新电脑不需要相同的目录结构

## 📦 安装

### 通过 NPM（推荐）

```bash
# 使用 reskill
reskill install @yonsun/claude-memory-migration

# 或使用 npm
npm install -g @yonsun/claude-memory-migration
```

### 手动安装

```bash
git clone https://github.com/Yonsun-w/claude-memory-migration.git
cd claude-memory-migration
cp -r . ~/.claude/skills/claude-memory-migration/
```

## 🚀 快速开始

### 步骤 1: 在旧电脑导出

在 Claude Code 中直接说：

```
"我要换电脑了，帮我导出 Claude 配置"
```

或使用命令：

```
/claude-memory export
```

**输出**：
- 📦 `~/claude-export-YYYYMMDD-HHMMSS.tar.gz`
- 📋 包含所有记忆、配置、对话历史

### 步骤 2: 复制到新电脑

通过任何方式（U盘、网盘、AirDrop）将压缩包复制到新电脑。

### 步骤 3: 在新电脑导入

解压后，在 Claude Code 中说：

```
"导入 Claude 配置"
```

或使用命令：

```
/claude-memory import
```

**结果**：
- ✅ 所有项目在 `~/.claude-projects/`
- ✅ 对话历史完整恢复
- ✅ 项目记忆可用
- ✅ 技能配置保留

### 步骤 4: （可选）创建符号链接

如果新电脑有真实项目路径：

```
/claude-memory link
```

**交互示例**：
```
📁 Project-ai-coding
   ✓ 检测到真实路径: /Users/newuser/work/ai-coding
   创建链接? (Y/n): y
   ✓ 已创建符号链接
```

## 📝 命令参考

| 命令 | 说明 |
|------|------|
| `/claude-memory export` | 导出所有配置和记忆 |
| `/claude-memory import` | 导入并重组项目结构 |
| `/claude-memory link` | 创建符号链接到真实路径 |
| `/claude-memory status` | 查看迁移状态 |
| `/claude-memory analyze` | 分析当前使用情况 |

## 🎯 使用场景

### 场景 1: 完整迁移

换新电脑，完整迁移所有 Claude 记忆。

### 场景 2: 备份恢复

定期备份 Claude 配置，防止数据丢失。

### 场景 3: 团队共享

导出配置文件，分享给团队成员（注意隐私）。

### 场景 4: 多机同步

在多台电脑之间同步 Claude 配置。

## 📊 统计分析

查看当前 Claude 使用情况：

```
/claude-memory analyze
```

**输出示例**：
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

🔝 Top 10 项目（按大小）
------------------------------------------------------------
 1. [  1024.7 MB]  42会话  /Users/yonsun/Project/ai-coding
 2. [   256.3 MB]  15会话  /Users/yonsun/wjh-sum
```

## 🔧 配置

### 统一目录位置

默认: `~/.claude-projects/`

可通过环境变量修改：
```bash
export CLAUDE_UNIFIED_ROOT="/custom/path/to/projects"
```

### 迁移过滤规则

默认跳过以下目录：
- `/tmp/`
- `/private/var/`
- 大小 < 1KB 且无对话历史的项目

## 🔍 故障排查

### 问题 1: 导入后找不到项目

**解决**：
```bash
rm -rf ~/.claude/projects
# 重新运行导入
/claude-memory import
```

### 问题 2: 符号链接失效

**解决**：
```bash
/claude-memory status  # 查看状态
/claude-memory link    # 重新配置
```

### 问题 3: 压缩包过大

**解决**：
- 清理不需要的项目后再导出
- 使用 `/claude-memory analyze` 查看大文件

## 🛡️ 安全性

- ✅ 导出前自动备份现有配置
- ✅ 导入时提示用户确认
- ✅ 过滤敏感临时目录
- ✅ 生成迁移记录可追溯

**注意**: 导出包可能包含敏感信息（API keys、对话历史），请妥善保管。

## 📚 技术栈

- Bash 4.0+
- Python 3.6+
- tar
- Git (可选)

## 🤝 贡献

欢迎提交 Issue 和 PR！

```bash
git clone https://github.com/Yonsun-w/claude-memory-migration.git
cd claude-memory-migration
# 进行修改...
git commit -m "feat: add new feature"
git push origin main
```

## 📄 许可证

MIT License - 详见 [LICENSE](LICENSE)

## 🙏 致谢

感谢 Claude Code 团队提供的强大 AI 编程工具。

## 📮 联系方式

- GitHub: [@yonsun](https://github.com/yonsun)
- Issues: [GitHub Issues](https://github.com/Yonsun-w/claude-memory-migration/issues)

## 🔗 相关链接

- [Claude Code 官方文档](https://claude.ai/code)
- [Claude Code Skills Marketplace](https://github.com/anthropics/claude-code-skills)

---

**版本**: 1.0.0
**更新日期**: 2026-04-09
**作者**: yonsun
