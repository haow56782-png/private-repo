# 🦞 OpenClaw 帮助索引

> 分类整理所有内置 Skills 和 CLI 命令

---

## 一、内置 Skills 分类

### 🗣️ 通信 & 社交
| Skill | 用途 | 备注 |
|---|---|---|
| **discord** | Discord 聊天集成 | 需 bot token |
| **slack** | Slack 工作空间集成 | 需 API token |
| **imsg** | iMessage (macOS) | 本地 Apple Messages |
| **bluebubbles** | BlueBubbles iMessage 桥 | 需要 BlueBubbles 服务 |
| **blucli** | BlueBubbles CLI | 同上 |
| **voice-call** | 语音通话集成 | — |
| **wacli** | WhatsApp CLI | — |

### 📝 笔记 & 知识管理
| Skill | 用途 | 备注 |
|---|---|---|
| **notion** | Notion API 读写 | ⚠️ key 已配未验证 |
| **obsidian** | Obsidian 笔记 | 本地 vault 集成 |
| **bear-notes** | Bear 笔记 (macOS) | — |
| **apple-notes** | Apple Notes (macOS) | — |
| **apple-reminders** | Apple Reminders | — |

### 🐙 开发 & 代码
| Skill | 用途 | 备注 |
|---|---|---|
| **github** | GitHub API / 仓库管理 | ✅ `gh` CLI 已装 |
| **gh-issues** | GitHub Issues | — |
| **coding-agent** | 写代码的 agent 模式 | — |
| **node-connect** | Node.js 连接器 | — |

### 🧠 AI & 推理
| Skill | 用途 | 备注 |
|---|---|---|
| **gemini** | Google Gemini 模型 | — |
| **openai-whisper** | Whisper 语音转文字 (本地) | — |
| **openai-whisper-api** | Whisper API | 需 API key |
| **claude-api** | Anthropic Claude API | 第三方 skill |

### 📹 媒体 & 内容
| Skill | 用途 | 备注 |
|---|---|---|
| **video-frames** | 视频帧提取 | ✅ `ffmpeg` 已装 |
| **summarize** | 文本/网页总结 | ✅ 已启用 |
| **ai-video-generation** | AI 视频生成 | 第三方 skill |
| **gifgrep** | GIF 搜索匹配 | — |
| **songsee** | 歌曲识别 | — |
| **sag** | ElevenLabs TTS 语音合成 | — |
| **sherpa-onnx-tts** | 离线本地 TTS | — |

### 📅 项目管理 & 生产力
| Skill | 用途 | 备注 |
|---|---|---|
| **taskflow** | 任务流管理 | — |
| **taskflow-inbox-triage** | 收件分类 | — |
| **trello** | Trello 看板 | — |
| **things-mac** | Things 3 (macOS) | — |
| **project-manager** | 项目管理 | 第三方 skill |

### 🏠 智能家居 & 设备
| Skill | 用途 | 备注 |
|---|---|---|
| **openhue** | Philips Hue 灯光 | — |
| **camsnap** | 摄像头抓拍 | — |
| **sonoscli** | Sonos 音响 | — |
| **spotify-player** | Spotify 播放控制 | — |

### 🔐 安全 & 认证
| Skill | 用途 | 备注 |
|---|---|---|
| **1password** | 1Password 密码管理 | — |
| **oracle** | AI 预言/决策辅助 | — |

### 📊 工具 & 监控
| Skill | 用途 | 备注 |
|---|---|---|
| **healthcheck** | 健康检查 | — |
| **model-usage** | 模型使用量统计 | — |
| **canvas** | Canvas HTML 渲染 | — |
| **session-logs** | 会话日志管理 | — |
| **xurl** | URL 工具 | — |
| **tmux** | tmux 终端复用器 | — |
| **weather** | 天气查询 | — |
| **blogwatcher** | 博客监控 | — |
| **skill-creator** | 创建自定义 Skill | — |
| **clawhub** | ClawHub 技能市场 | — |
| **nano-pdf** | PDF 处理 | — |

### 🗺️ 出行 & 本地
| Skill | 用途 | 备注 |
|---|---|---|
| **gog** | 出行/地图 | — |
| **goplaces** | 地点搜索 | — |
| **peekaboo** | 位置/碰撞检测 | — |
| **mcporter** | Minecraft 服务器 | — |

### 🔧 系统
| Skill | 用途 | 备注 |
|---|---|---|
| **eightctl** | 8x8 控制 | — |
| **ordercli** | 排序/整理 CLI | — |
| **himalaya** | 邮件客户端 | — |

---

## 二、CLI 命令分类

### 🚀 入门 & 设置
| 命令 | 用途 |
|---|---|
| `openclaw onboard` | 交互式引导（Gateway/Workspace/Skills） |
| `openclaw setup` | 初始化本地配置和工作区 |
| `openclaw configure` | 交互式配置凭据/频道/Gateway |
| `openclaw config` | 非交互式配置读写 |
| `openclaw reset` | 重置本地配置/状态（不卸载 CLI）|

### 🔌 Gateway & 网络
| 命令 | 用途 |
|---|---|
| `openclaw gateway` | 启动/管理 WebSocket Gateway |
| `openclaw daemon` | Gateway 服务（旧别名） |
| `openclaw status` | 查看频道健康和最近会话 |
| `openclaw health` | 获取 Gateway 健康状态 |
| `openclaw dns` | DNS 工具 (Tailscale + CoreDNS) |
| `openclaw doctor` | 健康检查 + 快速修复 |
| `openclaw proxy` | 调试代理/流量抓包 |

### 🤖 Agent 与推理
| 命令 | 用途 |
|---|---|
| `openclaw agent` | 通过 Gateway 跑一轮 Agent |
| `openclaw infer` | 运行 provider 推理 |
| `openclaw capability` | provider 推理（infer 别名） |
| `openclaw chat` | 打开本地终端 UI |
| `openclaw tui` | 打开终端 UI（连接到 Gateway）|
| `openclaw terminal` | 同上 |

### 📨 消息 & 频道
| 命令 | 用途 |
|---|---|
| `openclaw message` | 发送/读取/管理消息 |
| `openclaw channels` | 管理聊天频道 |
| `openclaw directory` | 查找联系人/群组 ID |
| `openclaw pairing` | 安全 DM 配对管理 |
| `openclaw webhooks` | Webhook 集成 |

### 🧩 Skills & 插件
| 命令 | 用途 |
|---|---|
| `openclaw skills` | 列出/检查可用 Skills |
| `openclaw plugins` | 管理插件 |
| `openclaw hooks` | 管理内部 Agent Hooks |

### ⚙️ 系统 & 管理
| 命令 | 用途 |
|---|---|
| `openclaw cron` | 定时任务管理 |
| `openclaw tasks` | 后台任务状态检查 |
| `openclaw sessions` | 列出存储的会话 |
| `openclaw models` | 模型发现/扫描/配置 |
| `openclaw nodes` | Gateway 节点管理 |
| `openclaw node` | 节点主机服务管理 |
| `openclaw sandbox` | 沙箱容器管理 |
| `openclaw logs` | 查看 Gateway 日志 |
| `openclaw backup` | 备份/验证存档 |
| `openclaw devices` | 设备配对/令牌管理 |
| `openclaw secrets` | 密钥运行时重载 |
| `openclaw security` | 安全工具/审计 |
| `openclaw exec-policy` | 执行策略管理 |

### 👁️ 控制面板
| 命令 | 用途 |
|---|---|
| `openclaw dashboard` | 打开 Control UI |
| `openclaw qr` | 生成移动端配对二维码 |

### 📦 更新 & 卸载
| 命令 | 用途 |
|---|---|
| `openclaw update` | 更新 OpenClaw |
| `openclaw uninstall` | 卸载 Gateway + 本地数据 |
| `openclaw version` | 查看版本 |

### 👤 用户 & 权限
| 命令 | 用途 |
|---|---|
| `openclaw acp` | Agent Control Protocol |
| `openclaw agents` | 管理独立 Agent |
| `openclaw approvals` | 管理 exec 审批 |
| `openclaw system` | 系统事件/心跳/在线状态 |
| `openclaw memory` | 搜索/检查/重建内存 |

> 📖 完整文档: https://docs.openclaw.ai/cli
