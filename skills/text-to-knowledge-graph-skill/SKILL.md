---
name: text-to-knowledge-graph
description: Convert text, PRDs, business descriptions, domain rules, workflows, or strategy documents into a structured knowledge graph with nodes, edges, hierarchy, relationships, and insights. Outputs Graph JSON (consumable by Neo4j/D3/ECharts) and human-readable explanation. Use when user wants to build a knowledge graph, extract entities and relationships, structure concepts, generate graph JSON, or visualize knowledge as nodes and edges.
---

# Text to Knowledge Graph Skill

Convert user-provided text into a **structured knowledge graph** — extracting nodes, edges, hierarchy, relationships, and insights.

## When to Use

Use when the user asks to:
- Build a knowledge graph from text
- Extract entities and relationships
- Structure a product / business / technical / domain concept
- Convert PRD / rules / strategy / workflow into graph form
- Generate graph JSON or Neo4j Cypher
- Visualize concepts as nodes and edges

## Core Workflow

### Step 1: Understand Source Text
Identify the source type and central theme:
- Product document / Business description / Technical architecture
- Workflow / Domain knowledge / Strategy framework
- Risk control rules / Operation model / Methodology

### Step 2: Extract Nodes

| Node Type | Meaning |
|-----------|---------|
| `Concept` | Abstract idea or theory |
| `Module` | Product or system module |
| `Process` | Business or execution process |
| `Role` | User, operator, admin, agent |
| `Rule` | Business rule or constraint |
| `Metric` | Indicator or KPI |
| `Risk` | Risk factor or abnormal condition |
| `Tool` | External tool, API, model, system |
| `Data` | Dataset, data object, field |
| `Decision` | Decision point or judgment |
| `Output` | Report, result, signal, action |

```json
{"id": "snake_case_id", "label": "Display Name", "type": "NodeType", "level": 0-4, "summary": "Short explanation", "properties": {}}
```

### Step 3: Extract Edges

| Relation | Meaning |
|----------|---------|
| CONTAINS | A includes B |
| HAS_MODULE | System has module |
| HAS_STEP | Process has step |
| DEPENDS_ON | A depends on B |
| GENERATES | A produces B |
| USES | A uses B |
| TRIGGERS | A triggers B |
| MONITORS | A monitors B |
| CONTROLS | A controls B |
| VALIDATES | A validates B |
| CONVERTS_TO | A converts to B |
| AFFECTS | A impacts B |
| BELONGS_TO | A belongs to B |
| OPTIMIZES | A optimizes B |
| RISKS | A has risk B |

```json
{"id": "edge_id", "source": "source_id", "target": "target_id", "relation": "RELATION_TYPE", "direction": "source_to_target", "summary": "Why", "properties": {}}
```

### Step 4: Build Hierarchy

| Level | Meaning |
|-------|---------|
| 0 | Root topic |
| 1 | Major domain / capability |
| 2 | Module / process / category |
| 3 | Rule / metric / data / sub-process |
| 4 | Detail / field / condition / example |

### Step 5: Generate Insights

| Type | Meaning |
|------|---------|
| structure | Overall structure summary |
| missing | Missing node, rule, or relationship |
| risk | Potential risk or weak point |
| recommendation | Suggested improvement |
| dependency | Important dependency |
| decision | Key decision point |

## Output Format

Always output:
1. **Human-readable explanation** — readable summary of the graph
2. **Graph JSON** — machine-readable, visualization-ready

### Graph JSON Schema

```json
{
  "graph_name": "",
  "graph_type": "product|business|technical|workflow|risk|strategy|methodology|domain",
  "source_type": "text",
  "summary": "",
  "nodes": [],
  "edges": [],
  "hierarchy": [{"level": 0, "nodes": ["id"]}],
  "insights": [{"type": "", "content": ""}]
}
```

### Optional: Neo4j Cypher

```cypher
CREATE (n:Concept {id: "root", name: "Root"});
CREATE (m:Module {id: "mod1", name: "Module"});
CREATE (n)-[:HAS_MODULE]->(m);
```

## Quality Checklist

- [ ] Clear root node at level 0
- [ ] All important concepts → nodes
- [ ] Relationships explicit and meaningful
- [ ] Hierarchy is reasonable
- [ ] Node IDs stable, snake_case, machine-readable
- [ ] Insights are useful, not generic
- [ ] JSON can be consumed by D3/Neo4j/ECharts
- [ ] Domain-specific terms preserved
- [ ] No invented unsupported relationships
