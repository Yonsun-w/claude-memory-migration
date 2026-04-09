# 🏃‍♂️💨 Claude Memory Migration - 快速蒸馏并打包自己

<div align="center">

**Claude Code 终极跑路工具包 - 5分钟带走所有记忆，不留痕迹！**

*"老板，我键盘落办公室了，回去拿一下..." - 某程序员，10分钟后*

[![NPM Version](https://img.shields.io/npm/v/@yonsun/claude-memory-migration.svg)](https://www.npmjs.com/package/@yonsun/claude-memory-migration)
[![GitHub Stars](https://img.shields.io/github/stars/Yonsun-w/claude-memory-migration.svg)](https://github.com/Yonsun-w/claude-memory-migration)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

</div>

---

## 📖 一个真实的故事（不是）

> 星期五下午 3:47 PM，HR 突然发了一条钉钉：
>
> **"小李，来会议室一趟。"**
>
> 小李心里一紧：不对劲，这个时间点，这个语气...
>
> 3:52 PM，会议室，HR 和他的直属领导都在座。
>
> **"小李啊，公司最近要调整组织架构..."**
>
> 小李脑子嗡嗡响，但手已经下意识摸向了口袋里的手机。
>
> **"...给你 30 分钟收拾东西，IT 会来回收电脑..."**
>
> 等等！电脑里还有：
> - 🧠 3年的 Claude 对话记忆（17GB）
> - 📁 58个项目的代码上下文
> - 🔧 精心配置的开发环境
> - 💬 和 AI 一起调试的所有历史记录
> - 🎯 下周要用的面试代码模板...
>
> **"明白了，我 10 分钟就好。"** 小李淡定地说。
>
> 4:01 PM，工位。小李打开 Claude Code：
>
> ```
> "我要换电脑了，帮我导出 Claude 配置"
> ```
>
> Claude 秒懂（它经历过太多次这种场景了）：
>
> ```
> 📋 正在扫描 58 个项目...
> 🔍 找到 35 个有价值的项目（跳过临时文件）
> 📦 打包对话历史... ✓
> 🧠 备份项目记忆... ✓
> ⚙️  导出所有配置... ✓
>
> ✅ 完成！~/claude-export-20260409-155823.tar.gz (1.2GB)
>
> 💡 提示：已自动保存到桌面
> 💡 建议：复制到U盘后立即删除本地文件
> ```
>
> 4:06 PM，小李拔下 U 盘，关上电脑，端起自己的马克杯。
>
> **"收拾好了，电脑还你们。对了，我那个 TypeScript 写的监控脚本..."**
>
> **"不用交接了，下周会有人..."**
>
> 4:08 PM，电梯里。小李打开手机，新电脑已经在路上（某电商 2 小时达）。
>
> 7:32 PM，家里。新 MacBook 开箱，第一件事：
>
> ```bash
> tar -xzf claude-export-20260409-155823.tar.gz
> cd claude-export-20260409-155823
> ./claude-unified-migration.sh import
> ```
>
> ```
> 🔄 重组项目结构...
> ✅ 成功迁移 35 个项目
> 🧠 所有记忆已恢复
> 📁 统一目录: ~/.claude-projects/
>
> 🎉 欢迎回来！您的 AI 副驾驶已就位。
> ```
>
> 7:45 PM，小李打开 Claude Code，输入：
>
> ```
> "继续上次我们讨论的微服务架构优化方案"
> ```
>
> Claude 秒接：
>
> ```
> 好的，我们之前聊到用 NATS 替换 Kafka 降低延迟...
> 根据你上周的压测数据，QPS 从 8000 提升到...
> ```
>
> 小李露出了微笑。
>
> **第二天，周六，某咖啡厅。**
>
> 新公司 CTO：**"听说你对微服务和 AI 辅助开发很有经验？"**
>
> 小李打开电脑，Claude 里 3 年的项目记忆和对话历史整整齐齐：
>
> **"我做过一个案例..."** （点开某个项目的完整对话历史）
>
> CTO：**"👀 这个... 你什么时候能入职？"**
>
> 小李：**"下周一？"**
>
> ---
>
> **教训**：永远不要把记忆和经验留在公司电脑里。
>
> **真相**：小李用的就是这个工具。

---

## 🌟 为什么需要这个工具？

### 💼 职场现实
- 🔥 **被优化了**：30 分钟内必须走人
- 🏢 **换工作**：新公司发了新电脑
- 💻 **电脑坏了**：主板烧了，数据要抢救
- 🎓 **毕业了**：实验室电脑要还
- 🏠 **远程办公**：家里和公司两台电脑

### 🧠 你的 AI 记忆很值钱
- 📚 **对话历史**：你和 Claude 讨论过的所有技术方案
- 🎯 **项目上下文**：AI 记住的每个项目的架构细节
- 🔧 **调试经验**：哪些 bug 怎么解决的
- 💡 **最佳实践**：AI 总结的代码规范和技巧
- 🚀 **面试宝典**：准备过的算法题和系统设计

**这些记忆都在 `~/.claude/` 里，丢了就真的丢了！**

---

## 🎯 核心原理

### 传统迁移的问题
```
旧电脑项目路径: /Users/olduser/workspace/my-project
                              ↓
新电脑可能是:    /Users/newuser/projects/my-project
                              ↓
              Claude 找不到原路径，记忆全丢失！❌
```

### 本工具的解决方案
```
旧电脑任意路径: /Users/olduser/workspace/my-project
                /Users/olduser/Documents/side-project
                /Users/olduser/company/work-project
                              ↓
           统一导出，生成路径映射表
                              ↓
新电脑统一管理: ~/.claude-projects/
                ├── my-project/          ← 友好命名
                ├── side-project/        ← 包含所有对话历史
                └── work-project/        ← 包含项目记忆
                              ↓
     可选：符号链接到真实项目目录
~/.claude-projects/my-project → ~/new-workspace/my-project
                              ↓
              Claude 无缝识别，记忆完整恢复！✅
```

---

## ✨ 核心功能

### 1. 🚀 5分钟完整打包
```bash
# 一行命令带走所有记忆
/claude-memory export

# 输出
📦 ~/claude-export-20260409.tar.gz (1.2GB)
✅ 58个项目，234段对话，3年记忆
```

### 2. 🎯 智能路径映射
不用担心新电脑路径不一样！

**旧电脑的项目可能在**：
- `/Users/username/workspace/project-a`
- `/Users/username/Documents/project-b`
- `/Users/username/company/repos/project-c`

**新电脑统一管理在**：
- `~/.claude-projects/project-a`
- `~/.claude-projects/project-b`
- `~/.claude-projects/project-c`

**Claude 自动识别，路径完全独立！**

### 3. 🧠 零损失记忆恢复
```bash
# 新电脑上一键恢复
/claude-memory import

# Claude 立刻记起你们的所有对话
"继续上次我们讨论的那个算法..."
"好的，你上周说要用动态规划优化..."
```

### 4. 🔗 符号链接黑科技
```bash
# 可选：链接到新电脑的真实项目目录
/claude-memory link

# 交互示例
📁 project-a
   原路径: /Users/旧电脑用户名/workspace/project-a
   统一路径: ~/.claude-projects/project-a

   检测到真实路径: ~/new-workspace/project-a
   创建符号链接? (Y/n): y
   ✓ 已创建符号链接

# 最终效果
~/.claude-projects/project-a → ~/new-workspace/project-a
```

---

## 📦 安装（3 种方式）

### 方式 1: NPM（推荐）
```bash
npm install -g @yonsun/claude-memory-migration
```

### 方式 2: 手动安装
```bash
git clone https://github.com/Yonsun-w/claude-memory-migration.git
cd claude-memory-migration
cp -r . ~/.claude/skills/claude-memory-migration/
```

### 方式 3: 通过 reskill
```bash
reskill install @yonsun/claude-memory-migration
```

---

## 🚀 快速开始（真的很快）

### 📤 旧电脑：导出（3 分钟）

在 Claude Code 中说：
```
"我要换电脑了，帮我导出 Claude 配置"
```

或使用命令：
```bash
/claude-memory export
```

**输出示例**：
```
📋 扫描项目目录...
===========================================================

🧠 项目: microservice-refactor
   原路径: /Users/旧电脑用户名/workspace/microservice-refactor
   会话: 15, 大小: 256KB, 有项目记忆 ✓

💬 项目: leetcode-practice
   原路径: /Users/旧电脑用户名/Documents/leetcode-practice
   会话: 42, 大小: 1.2MB

🔥 项目: side-hustle
   原路径: /Users/旧电脑用户名/projects/side-hustle
   会话: 8, 大小: 128KB

===========================================================
✓ 找到 58 个项目，将迁移 35 个
📦 ~/claude-export-20260409-163000.tar.gz
===========================================================
```

### 📥 新电脑：导入（2 分钟）

1. 复制压缩包到新电脑（U盘/网盘/AirDrop）
2. 解压并导入：

```bash
tar -xzf claude-export-*.tar.gz
cd claude-export-*
./claude-unified-migration.sh import
```

或在 Claude Code 中说：
```
"导入 Claude 配置"
```

**输出示例**：
```
原用户: 旧电脑用户名
新用户: 新电脑用户名
统一目录: ~/.claude-projects/

🔄 重组项目结构
===========================================================

🧠 microservice-refactor
   原路径: /Users/旧电脑用户名/workspace/microservice-refactor
   统一路径: ~/.claude-projects/microservice-refactor

📁 leetcode-practice
   原路径: /Users/旧电脑用户名/Documents/leetcode-practice
   统一路径: ~/.claude-projects/leetcode-practice

===========================================================
✓ 成功迁移 35 个项目
🎉 所有记忆已恢复！Claude 已识别所有项目
===========================================================
```

### 🔗 可选：创建符号链接

如果新电脑有真实项目目录：
```bash
/claude-memory link
```

**交互示例**：
```
📁 microservice-refactor
   原路径: /Users/旧电脑用户名/workspace/microservice-refactor
   统一路径: ~/.claude-projects/microservice-refactor

   建议路径: ~/workspace/microservice-refactor
   ✓ 检测到真实路径存在
   创建符号链接? (Y/n): y
   ✓ 已创建符号链接

📁 leetcode-practice
   原路径: /Users/旧电脑用户名/Documents/leetcode-practice
   统一路径: ~/.claude-projects/leetcode-practice

   建议路径: ~/Documents/leetcode-practice
   ⚠ 真实路径不存在
   输入自定义路径（留空跳过）: ~/practice/leetcode
   ✓ 已创建符号链接到: ~/practice/leetcode
```

**最终效果**：
```bash
~/.claude-projects/microservice-refactor → ~/workspace/microservice-refactor
~/.claude-projects/leetcode-practice → ~/practice/leetcode
```

---

## 📝 所有命令

| 命令 | 说明 | 用途 |
|------|------|------|
| `/claude-memory export` | 导出所有配置和记忆 | 换电脑前 |
| `/claude-memory import` | 导入并重组项目结构 | 新电脑上 |
| `/claude-memory link` | 创建符号链接到真实路径 | 有真实项目时 |
| `/claude-memory status` | 查看迁移状态 | 检查恢复情况 |
| `/claude-memory analyze` | 分析当前使用情况 | 看看占了多少空间 |

---

## 🎯 适用场景

### ✅ 完美适用
- 🔥 **紧急跑路**：被裁员/被优化，30分钟内清空工位
- 💼 **换工作**：新公司新电脑，老记忆要带走
- 💻 **电脑更换**：升级/维修/丢失，数据要迁移
- 🏢 **多机协作**：公司和家里两台电脑同步
- 🎓 **毕业离校**：实验室电脑要还，论文还没写完
- 🌍 **跨国搬家**：不想重新配置环境

### ⚠️ 注意事项
- 📦 **压缩包很大**：可能 1-5GB，建议用高速传输
- 🔒 **包含敏感信息**：对话历史可能有 API keys、密码等
- 🚫 **不包含代码**：只迁移记忆，不迁移项目源代码
- 🔐 **建议加密**：传输前用密码保护压缩包

---

## 📊 统计分析

想知道自己用 Claude 干了多少活？

```bash
/claude-memory analyze
```

**输出示例**：
```
📊 Claude Code 使用统计
===========================================================

总项目数: 58
总会话数: 234
总大小: 3.2 GB
使用天数: 847 天

📁 按类别统计（按旧电脑的目录结构分类）
------------------------------------------------------------
workspace目录下的项目   18个   145会话   1.8 GB
Documents目录下的项目   12个    56会话   0.9 GB
临时项目目录           15个    21会话   0.3 GB
其他目录              13个    12会话   0.2 GB

🔝 Top 10 最活跃项目（按对话次数）
------------------------------------------------------------
 1. [856.2 MB]  78会话  microservice-refactor
    原路径: /Users/旧电脑用户名/workspace/microservice-refactor

 2. [423.1 MB]  42会话  leetcode-daily
    原路径: /Users/旧电脑用户名/Documents/leetcode-daily

 3. [312.7 MB]  31会话  personal-blog
    原路径: /Users/旧电脑用户名/projects/personal-blog
```

---

## 🛡️ 安全性

### ✅ 我们做的
- 🔒 自动过滤临时目录（`/tmp/`、`/private/var/`）
- 🗑️ 跳过无价值文件（< 1KB 且无历史）
- 📋 生成完整迁移记录（可追溯原路径）
- 💾 导入前自动备份现有配置

### ⚠️ 你应该做的
- 🔐 **加密压缩包**：`tar -czf - export-dir | openssl enc -aes-256-cbc -out export.tar.gz.enc`
- 🚫 **检查敏感信息**：导出前搜索 `password`、`token`、`api_key`
- 🗑️ **用完即删**：传输完成后删除压缩包
- 🔒 **安全传输**：用 HTTPS/SSH，不要用 HTTP/FTP

---

## 🤔 常见问题

### Q: 会不会把公司代码也打包了？
**A**: ❌ 不会！这个工具只打包 `~/.claude/` 目录（Claude 的记忆），不碰项目源代码。

### Q: 新电脑的项目路径不一样怎么办？
**A**: 这正是这个工具的核心功能！

**举例说明**：
- 旧电脑：`/Users/olduser/workspace/my-project`
- 新电脑：`/Users/newuser/new-workspace/my-project`

导入后会统一管理在 `~/.claude-projects/my-project`，然后你可以用符号链接指向真实路径。Claude 会自动识别！

### Q: 压缩包有多大？
**A**: 取决于你的使用量。一般：
- 轻度用户（< 6 个月）: 100-500 MB
- 中度用户（6-12 个月）: 500 MB - 2 GB
- 重度用户（> 1 年）: 2-10 GB

### Q: 会泄露公司机密吗？
**A**: ⚠️ 对话历史里可能包含代码片段、讨论内容。如果担心，导出后手动检查 `.jsonl` 文件。

### Q: 可以分享给同事吗？
**A**: 🚫 强烈不建议！对话历史很私人，而且可能包含敏感信息。

---

## 🎨 高级用法

### 场景 1: 定期备份
```bash
# 添加到 crontab，每周自动备份
0 2 * * 0 ~/.claude/skills/claude-memory-migration/scripts/migration-core.sh export
```

### 场景 2: 多机同步
```bash
# 机器 A
/claude-memory export
scp export.tar.gz user@machine-b:~/

# 机器 B
/claude-memory import
```

### 场景 3: 云端备份
```bash
# 导出后自动上传
/claude-memory export
rclone copy ~/claude-export-*.tar.gz remote:backups/claude/
```

---

## 🔧 技术实现

- **Bash 4.0+**: 主脚本逻辑
- **Python 3.6+**: 路径映射和 JSON 处理
- **tar + gzip**: 打包压缩
- **符号链接**: 路径映射
- **JSON**: 元数据存储

---

## 🤝 贡献

欢迎 PR！特别是：
- 🌐 多语言支持
- 🔐 加密功能增强
- ☁️ 云端同步集成
- 🎨 GUI 工具

```bash
git clone https://github.com/Yonsun-w/claude-memory-migration.git
cd claude-memory-migration
# 进行修改...
git commit -m "feat: add awesome feature"
git push origin main
```

---

## 📄 许可证

MIT License - 详见 [LICENSE](LICENSE)

---

## 🙏 致谢

- 感谢 Claude Code 团队提供的强大 AI 编程工具
- 感谢所有在职场浮沉中依然热爱编程的程序员们
- 特别感谢那些在被裁员后依然保持乐观的朋友们

---

## 📮 联系方式

- **GitHub**: [@Yonsun-w](https://github.com/Yonsun-w)
- **Issues**: [GitHub Issues](https://github.com/Yonsun-w/claude-memory-migration/issues)
- **NPM**: [@yonsun/claude-memory-migration](https://www.npmjs.com/package/@yonsun/claude-memory-migration)

---

<div align="center">

**💡 记住：你的 AI 记忆和经验，比任何公司的代码都值钱。**

**🎯 定期备份，随时跑路，保持自由。**

Made with ❤️ by developers, for developers

[⭐ Star on GitHub](https://github.com/Yonsun-w/claude-memory-migration) | [📦 Install from NPM](https://www.npmjs.com/package/@yonsun/claude-memory-migration) | [🐛 Report Issues](https://github.com/Yonsun-w/claude-memory-migration/issues)

</div>
