---
name: image-to-knowledge-graph
description: 从截图、架构图、页面设计图、流程图、白板图等图片中识别视觉结构，提取节点、层级、关系，输出结构化知识图谱。Use when 用户上传图片要求拆解结构、看图拆产品、看图拆架构、从截图提取信息建图谱、图片转知识图谱。
---

# Image to Knowledge Graph Skill

从图片中识别视觉元素和结构关系，输出结构化知识图谱。

> 与 `text-to-knowledge-graph` 互补：文本版做语义抽取，图片版做视觉结构识别。

## 适用场景

| 输入类型 | 示例 |
|---------|------|
| **产品截图** | App 页面截图 → 拆解页面模块、交互元素、导航结构 |
| **架构图** | 系统架构图 → 提取组件、层级、依赖关系 |
| **流程图** | Visio/Mermaid/手绘流程图 → 提取节点、判断、分支 |
| **白板图** | 会议白板拍照 → 提取概念、关联、分组 |
| **思维导图** | XMind/MindMap 截图 → 提取层级结构 |
| **数据库ER图** | 表结构图 → 提取实体、字段、关系 |
| **Figma设计稿** | UI 设计截图 → 拆解组件、布局、交互 |

## 核心工作流

### Step 1: 图片识别与分类

用 vision 模型分析图片，判断图片类型：

```
输入图片 → 分类判断
├── 产品界面截图 → 页面结构分析流程
├── 系统架构图   → 组件依赖分析流程
├── 流程图       → 节点流向分析流程
├── 思维导图     → 层级结构分析流程
├── ER 图        → 实体关系分析流程
├── 白板/手绘    → OCR + 结构推断流程
└── 其他         → 通用视觉元素提取
```

### Step 2: 视觉元素提取

从图片中识别：

| 视觉元素 | 映射为 |
|---------|--------|
| 方框/卡片/区块 | Node |
| 箭头/连线 | Edge |
| 颜色分组 | Cluster/Category |
| 大小/层级 | Level |
| 文字标签 | Label |
| 图标/符号 | Type hint |
| 位置布局 | Hierarchy |

### Step 3: 结构推断

基于视觉元素推断语义结构：

- **包含关系**: 大框套小框 → CONTAINS
- **流向关系**: 箭头方向 → TRIGGERS / HAS_STEP
- **依赖关系**: 连线无箭头 → DEPENDS_ON / AFFECTS
- **层级关系**: 上下/左右布局 → 层级深度
- **分组关系**: 同色/同区域 → BELONGS_TO

### Step 4: 构建图谱

将视觉结构转化为标准知识图谱格式（与 text-to-knowledge-graph 相同的输出结构）。

### Step 5: 补充洞察

基于图片内容生成洞察：
- **structure**: 图片整体结构描述
- **missing**: 图中缺失但应有的模块/连接
- **risk**: 潜在的设计风险
- **recommendation**: 改进建议

## 节点类型（与 text-to-knowledge-graph 统一）

| 类型 | 视觉线索 |
|------|---------|
| Concept | 中心/标题位置的大文字 |
| Module | 独立方框/卡片 |
| Process | 带箭头的流程节点 |
| Role | 人形图标/角色标签 |
| Rule | 菱形判断/条件框 |
| Metric | 数字/图表/仪表盘 |
| Risk | 红色/警告标记 |
| Tool | 工具图标/外部系统框 |
| Data | 数据库图标/表格 |
| Decision | 菱形/分支点 |
| Output | 文档/报告图标 |

## 输出格式

### 1. Graph JSON（默认）
```json
{
  "graph_name": "",
  "graph_type": "product|technical|workflow|...",
  "source_type": "image",
  "image_type": "screenshot|architecture|flowchart|mindmap|er_diagram|whiteboard",
  "summary": "",
  "nodes": [],
  "edges": [],
  "hierarchy": [],
  "insights": []
}
```

### 2. Markdown 报告
包含：图片类型说明 + Mermaid 流程图 + 节点表 + 关系表 + 层级 + 洞察

### 3. Neo4j Cypher（可选）

## 与 text-to-knowledge-graph 的配合

```
图片输入 → image-to-knowledge-graph → 结构图谱（视觉层）
                    ↓
文本补充 → text-to-knowledge-graph  → 语义图谱（逻辑层）
                    ↓
              合并为完整知识图谱
```

## 质量检查

- [ ] 图片中所有可见模块/元素都提取为节点
- [ ] 箭头/连线都转化为边
- [ ] 层级关系与视觉布局一致
- [ ] 未在图中出现的元素不凭空添加
- [ ] 文字标签完整保留（中英文都保留原文）
- [ ] 节点 ID 稳定、snake_case
