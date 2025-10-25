# Documentation

This directory contains project-level documentation for your HDL design.

---

## Purpose

The `doc/` directory is the central location for all project documentation including:

- Architecture and design specifications
- Block diagrams and system overviews
- Implementation notes and design decisions
- User guides and integration instructions
- Performance analysis and test results

---

## Documentation Types

### 1. Architecture Documentation

High-level system documentation:
- System block diagrams
- Interface specifications
- Memory maps and register definitions
- Clocking and reset strategies
- Power domains and partitioning

### 2. Module Documentation

Individual module/component documentation:
- Functional descriptions
- Port/signal definitions
- Timing requirements
- Configuration parameters
- Usage examples

This can be written manually or auto-generated from HDL comments.

### 3. Verification Documentation

Testing and verification strategies:
- Test plans and test cases
- Coverage reports
- Simulation results
- Formal verification approaches
- Known issues and limitations

---

## Documentation Formats

### Markdown (Recommended)

Markdown is the recommended format for most documentation:
- Easy to read and write
- Version control friendly
- Supported by GitHub/GitLab
- Can include code snippets and diagrams

Example module documentation:

```markdown
# Module: my_module

## Overview
Brief description of what this module does.

## Parameters
- `WIDTH` - Data path width (default: 32)
- `DEPTH` - FIFO depth (default: 16)

## Ports
| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| clk  | input     | 1     | System clock |
| rst  | input     | 1     | Active-high reset |
| data_in | input  | WIDTH | Input data |
| data_out | output | WIDTH | Output data |

## Timing
Clock frequency: Up to 200 MHz
Latency: 3 clock cycles

## Usage Example
```verilog
my_module #(.WIDTH(16), .DEPTH(32)) inst (
    .clk(clk),
    .rst(rst),
    .data_in(din),
    .data_out(dout)
);
```

### Diagrams

Include visual documentation using:
- **Draw.io / Diagrams.net** - Export as SVG or PNG
- **Wavedrom** - JSON-based timing diagrams
- **Mermaid** - Text-based diagrams in Markdown
- **BlockDiag** - Python-based block diagrams
- **Graphviz** - DOT language diagrams

Example Wavedrom timing diagram in Markdown:

```json
{signal: [
  {name: 'clk', wave: 'p.......'},
  {name: 'data', wave: 'x.34.5x.', data: ['D1', 'D2', 'D3']},
  {name: 'valid', wave: '0.1...0.'}
]}
```

---

## Auto-Generated Documentation

You can generate module documentation from HDL source files using various tools:

### Doxygen

Doxygen supports Verilog/VHDL with special comment formatting:

```verilog
//! @brief Simple adder module
//! @details Adds two N-bit numbers
//!
//! @param WIDTH Data width in bits
module adder #(
    parameter WIDTH = 32  //!< Bit width of inputs/outputs
)(
    input  logic [WIDTH-1:0] a,  //!< First operand
    input  logic [WIDTH-1:0] b,  //!< Second operand
    output logic [WIDTH-1:0] c   //!< Sum output
);
```

Configure Doxygen to extract documentation:
```bash
# Generate Doxygen config
doxygen -g

# Edit Doxyfile to set:
# INPUT = ../rtl ../tb
# FILE_PATTERNS = *.sv *.v *.vhd
# OPTIMIZE_OUTPUT_VERILOG = YES

# Generate documentation
doxygen
```

### Natural Docs

Natural Docs offers a lightweight alternative with simple comment syntax:

```verilog
/*  Module: adder
    Adds two N-bit numbers together

    Parameters:
        WIDTH - Bit width of the adder (default: 32)

    Ports:
        a - First input operand
        b - Second input operand
        c - Sum output
*/
```

### Sphinx + Sphinx-HDL

For Python-style documentation:
```bash
pip install sphinx sphinx-verilog
sphinx-quickstart
```

---

## Documentation Best Practices

1. **Keep Documentation Close to Code** - Document modules in HDL comments when possible
2. **Update with Changes** - Update docs whenever you modify the design
3. **Use Version Control** - Commit documentation alongside code changes
4. **Include Diagrams** - Visual representations clarify complex logic
5. **Document Assumptions** - Explicitly state design assumptions and constraints
6. **Provide Examples** - Include usage examples for complex modules
7. **Link to Code** - Reference specific files and line numbers when relevant
8. **Review Regularly** - Ensure documentation stays accurate and current

---

## Quick Start Documentation Checklist

For a new project, create these essential documents:

- [ ] **README.md** - Project overview and quick start
- [ ] **ARCHITECTURE.md** - High-level system architecture
- [ ] **BUILD.md** - Build and synthesis instructions
- [ ] **TESTING.md** - Test procedures and verification strategy
- [ ] **CHANGELOG.md** - Version history and changes
- [ ] Module-level documentation for major components
- [ ] Block diagrams and interface specifications
- [ ] Pin assignment and constraint documentation

---

## Tools and Resources

### Documentation Generators
- [Doxygen](https://www.doxygen.nl/) - Multi-language documentation generator
- [Natural Docs](https://www.naturaldocs.org/) - Lightweight documentation tool
- [Sphinx](https://www.sphinx-doc.org/) - Python documentation generator
- [MkDocs](https://www.mkdocs.org/) - Markdown-based static site generator

### Diagramming Tools
- [Draw.io](https://app.diagrams.net/) - Free online diagram editor
- [Wavedrom](https://wavedrom.com/) - Digital timing diagram renderer
- [Mermaid](https://mermaid-js.github.io/) - Text-based diagrams
- [PlantUML](https://plantuml.com/) - UML and other diagram types
- [Graphviz](https://graphviz.org/) - Graph visualization

### Templates
- [FPGA Project Template Docs](https://github.com/fusesoc/fusesoc)
- [OpenCores Documentation](https://opencores.org/)
- [LibreCores](https://www.librecores.org/)

---

## Example Documentation

See the example adder module in [../rtl/example.sv](../rtl/example.sv) for a simple RTL example that could be documented.

A complete module documentation template might look like:

```markdown
# Adder Module

## Overview
32-bit combinatorial adder with configurable width.

## Features
- Parameterizable bit width
- Single-cycle operation
- Synthesizable to all FPGA families

## Interface
See [rtl/example.sv](../rtl/example.sv) for implementation.

## Testing
Tested with [tb/example_tb.sv](../tb/example_tb.sv).

## Performance
- Max frequency: 500+ MHz (7-series Xilinx)
- Resources: ~32 LUTs for 32-bit width
```

---

## Contributing to Documentation

When adding new modules or features:

1. Document the module's purpose and interface
2. Include timing requirements and constraints
3. Provide usage examples
4. Add diagrams for complex logic
5. Link documentation from the main README
6. Keep documentation in sync with code changes

---

## Notes

This template does not include auto-generation tools pre-configured. Choose the documentation tools that best fit your project needs and add them to your workflow as required.