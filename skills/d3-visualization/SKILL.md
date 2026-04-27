---
name: d3-visualization
description: Generate interactive D3.js (v7) data visualizations as standalone HTML pages. Supports bar, line, scatter, area, bubble, heatmap, and force-directed charts. Produces self-contained HTML with inline D3 library.
homepage: https://github.com/benchflow-ai/skillsbench/tree/main/tasks/data-to-d3
metadata:
  openclaw:
    emoji: 📊
    requires: {}
    install: []
---

# D3.js Visualization Skill

Use this skill to turn structured data (CSV/TSV/JSON) into **clean, interactive** visualizations using **D3.js v7**. The output is always a **standalone HTML file** that can be opened in any browser.

## When to use

Activate this skill when the user asks for:

- "Make a chart / plot / graph / visualization of this data"
- Bar chart, line chart, scatter plot, area chart, bubble chart, heatmap
- Interactive charts with tooltips, hover effects, click handlers
- Force-directed layout (bubble clusters, network graphs)
- Data-driven HTML/SVG output for a report or web page
- Converting CSV data to a visual report

**Do NOT use** this skill if the user just needs a table or text summary — use markdown tables instead.

---

## How to use

```bash
# 1. User provides data (CSV/JSON) — either by pasting it or pointing to a file

# 2. Generate the visualization:
#    - Write HTML with inline D3.js + CSS + JS into a single file
#    - Include D3 v7.9 from unpkg CDN (or vendor local copy)
#    - Output to: <user-specified-path>/output.html (default: ./output/d3-chart.html)

# 3. Open with:
open <output-path>/output.html
```

---

## Chart types & when to use them

| Chart Type | Best For | D3 Pattern |
|---|---|---|
| **Bar chart** | Categorical comparisons, rankings | `d3.scaleBand` + `d3.scaleLinear` |
| **Line chart** | Time series, trends | `d3.line` + `d3.scaleTime` |
| **Scatter plot** | Correlation, distribution | `d3.symbol` + `d3.scaleLinear` (x/y) |
| **Area chart** | Cumulative trends, volume | `d3.area` |
| **Bubble chart** | 3-dimension comparison (x, y, size) | `d3.forceSimulation` or `d3.pack` |
| **Force cluster** | Categorical grouping | `d3.forceSimulation` + `forceX`/`forceY` |
| **Heatmap** | Matrix data, density | Grid of rects + `d3.scaleSequential` |
| **Histogram** | Distribution of 1D data | `d3.bin` + `d3.scaleLinear` |

---

## Interactive patterns

### Tooltip (standard)
```html
<div id="tooltip" class="tooltip" style="position:absolute;padding:8px;background:rgba(0,0,0,0.8);color:#fff;border-radius:4px;pointer-events:none;opacity:0;z-index:1000;"></div>
```

```javascript
// Show/hide
.on('mouseover', (event, d) => {
    d3.select('#tooltip')
        .style('opacity', 1)
        .html(`<strong>${d.name}</strong><br/>Value: ${d.value}`)
        .style('left', (event.pageX + 10) + 'px')
        .style('top', (event.pageY - 10) + 'px');
})
.on('mouseout', () => d3.select('#tooltip').style('opacity', 0));
```

### Click to highlight / cross-highlight
```javascript
// Bubble → table cross-highlight
.on('click', (event, d) => {
    d3.selectAll('.bubble').classed('selected', false);
    d3.select(this).classed('selected', true);
    d3.select(`#row-${d.id}`).classed('highlighted', true);
});
```

### Force simulation (bubble clusters)
```javascript
const simulation = d3.forceSimulation(nodes)
    .force('x', d3.forceX(d => xScale(d.sectorIndex)).strength(0.5))
    .force('y', d3.forceY(d => yScale(d.sectorIndex)).strength(0.5))
    .force('collide', d3.forceCollide(d => sizeScale(d.value) + 2))
    .force('center', d3.forceCenter(width / 2, height / 2))
    .alpha(0.3)
    .stop();
simulation.tick(120); // fixed ticks for determinism
```

---

## Output format

### Single-file HTML (recommended)
One `index.html` with:
- Inline `<style>` for all CSS
- D3.js loaded from CDN: `<script src="https://d3js.org/d3.v7.min.js"></script>`
- Inline `<script>` for all JS

### Multi-file output (for larger projects)
```
output/
  index.html        # main page
  js/
    d3.v7.min.js    # vendored D3 (optional)
    chart.js        # visualization logic
  css/
    style.css       # styling
  data/
    *.csv           # input data copy
```

---

## Typical workflow

1. **Parse data**: Read CSV/JSON from the provided path
2. **Infer chart type**: Based on data shape and user intent
3. **Generate HTML**: Write a complete, self-contained HTML file
4. **Open**: Tell the user the file path

---

## Examples

### Bubble chart + data table (stock market)
Input: CSV with columns `ticker, sector, full name, marketCap`
Output: Side-by-side bubble chart (sized by market cap, colored by sector) + data table with click cross-highlighting.
