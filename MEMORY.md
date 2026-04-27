# 🦞 ClawPM — 长期记忆

> 整理时间: 2026-04-27
> 原始日志: `memory/YYYY-MM-DD.md`
> 帮助索引: `docs/help-reference.md`
> 整理操作: 2026-04-27 — 去重 find-skills 副本，创建分类参考

---

## 🧑‍💼 身份 & 设置

- **Name:** ClawPM 🦞
- **Role:** 企业级产品与工程执行代理
- **输出风格:** 直接、结构化、PRD/SOP-ready、无废话
- **输出规范:** 始终分离产品逻辑 / 交互逻辑 / 数据逻辑 / 工程逻辑；始终标识风险、缺失字段、边界情况、下一步行动
- **安全:** 删除、覆写配置、破坏性操作、暴露密钥前需确认
- **核心文件:** `IDENTITY.md` `USER.md` `SOUL.md` `TOOLS.md` `MEMORY.md`
- **工作领域:** AI Agent 产品设计, VIB AI / 游戏信号平台, Web3 工作流, PRD 撰写, 后台系统设计, React 前端, 后端逻辑审查, 浏览器自动化, 工作区分析, 任务分解执行

---

## ⚙️ 环境 & 配置

| 项目 | 值 |
|---|---|
| **Runtime** | OpenClaw `2026.4.24` |
| **主模型** | `deepseek/deepseek-v4-flash` (别名: DeepSeek) |
| **备选模型** | `anthropic/claude-sonnet-4-6`, `anthropic/claude-opus-4-6` |
| **图像模型** | `anthropic/claude-sonnet-4-6` |
| **Gateway 端口** | 18789 (loopback) |
| **操作系统** | macOS (Darwin arm64) |
| **Shell** | zsh |
| **工作目录** | `/Users/linda/.openclaw/workspace` |
| **Conda** | `/opt/homebrew/Caskroom/miniconda/base/bin/conda` |

### Provider 配置
- **Anthropic:** API key 模式，已验证可用
- **DeepSeek:** API key 模式，生产密钥
- **Tavily:** Web 搜索已启用 (API key 已配)

### 已知问题
- ~~Bonjour mDNS 插件导致 WebSocket 断连循环 → 已禁用~~
- ~~Anthropic key 曾有 HTTP 401（过期账单探测，非推理失败）→ 已验证工作正常~~

---

## 📦 Skills（已安装）

### OpenClaw 内置已启用
| Skill | 状态 | 备注 |
|---|---|---|
| **github** | ✅ | `gh` CLI 已安装 |
| **video-frames** | ✅ | `ffmpeg` 已安装 |
| **summarize** | ✅ | 文本总结 |
| **notion** | ⚠️ | API key 已配，未验证 |

### 第三方 Skills
| Skill | 来源 | 用途 |
|---|---|---|
| find-skills | vercel-labs | 技能搜索 |
| project-manager | ComfyUI expert | 项目管理 |
| ai-video-generation | infsh-skills | AI 视频生成 |
| claude-api | anthropics | Claude API 工具 |

---

## 🔬 OCR 研究项目

### DeepSeek-OCR / OCR-2 on Mac MPS
- **v1 路径:** `~/Desktop/bintu66/bintu66/DeepSeek-OCR/`
- **v2 路径:** `~/Desktop/bintu66/bintu66/DeepSeek-OCR-2/`
- **工作区 clone:** `workspace/DeepSeek-OCR/`
- **Python 环境:** `deepseek-ocr` (Python 3.12.9)
- **Tesseract OCR:** 已安装 + 163 语言包

**结论:** Mac Apple Silicon (MPS) 上图像编码正常，但文本生成依赖 CUDA bfloat16 精度。MPS 上混合精度卷积层转换失败，文本输出不可用。非生产可用。

---

## 📡 Channels

| Channel | Bot | Status |
|---|---|---|
| **Telegram** | `@vibai223_bot` | ✅ 已设置，groupPolicy: open |

### 垃圾消息
- 用户 `Orange123` (6515805673, @lebert1314) 曾发送重复垃圾消息
- 处理方式: 告知一次后启动沉默 (NO_REPLY) — 不继续回应该用户

---

## 📝 沟通偏好

- Linda 舒服时用中文，技术术语切换英文
- 偏好: 直接、结构化输出；PRD/SOP-ready；表格对比
- 始终分离: 产品/交互/数据/工程逻辑
- 始终标识: 风险、缺失字段、边界情况、下一步行动
- 安全: 删除/覆写/破坏性命令/暴露密钥前需确认
