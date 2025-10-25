# HDL Project Template

A template repository for hardware description language (HDL) projects, with synthesis, simulation, and version control workflows using the HDL-On-Git ([Hog](https://hog.readthedocs.io/en/latest/)) framework.

---

## Features

- **Organized Project Structure** - Split directory layout for RTL, testbenches, IP cores, and documentation
- **Hog Integration** - Git-based reproducible builds with CERN's HDL-On-Git framework
- **Multi-Tool Support** - Tested as compatible with Xilinx Vivado and Intel Quartus, theoretically compatible with Lattice Diamond and more
- **Simulation Infrastructure** - Pre-configured ModelSim/QuestaSim simulation environment
- **VSCode Integration** - Development environment with syntax highlighting, linting, and language server support
- **CI/CD Ready** - Templates for GitHub Actions and GitLab CI pipelines
- **Best Practices** - Example code demonstrating proper coding standards and project organization

---

## Directory Structure

```
VerilogRepo/
├── .vscode/           # Linting configuration
├── Hog/               # HDL-On-Git framework (submodule)
├── doc/               # Project documentation
├── ip/                # Vendor IP cores and generated IP
├── rtl/               # Synthesizable RTL source code
├── sim/               # Simulation scripts and environments
│   ├── modelsim/      # ModelSim/QuestaSim simulation scripts
│   ├── compile/       # Compilation script organization
│   ├── waves/         # Waveform configuration files
│   └── libraries/     # Compiled simulation libraries
├── sw/                # C/C++ software reference models (DPI)
├── tb/                # Verification testbenches (directed & UVM)
└── top/               # Synthesis project definitions
    └── myproj/        # Example project with HOG configuration
```

See individual README files in each directory for detailed documentation:
- [doc/](doc/README.md) - Documentation guidelines
- [ip/](ip/README.md) - IP core management
- [rtl/](rtl/README.md) - RTL coding standards
- [sim/](sim/README.md) - Simulation workflows
- [sw/](sw/README.md) - Software reference models
- [tb/](tb/README.md) - Verification infrastructure
- [top/](top/README.md) - Project definitions

---

## Quick Start

### 1. Clone and Initialize

```bash
# Clone this template repository
git clone https://github.com/GNPower/VerilogRepo.git
cd VerilogRepo
rm -rf .git
git init .
git add .
git push -u origin main

# Alternatively use the GitHub CLI `gh`
gh repo create <new-repo-name> --template="https://github.com/GNPower/VerilogRepo.git"

# Initialize HOG submodule
git submodule update --init --recursive --remote
```

### 2. Create Initial Version Tag

HOG uses Git tags for version tracking and reproducible builds:

```bash
# Create an annotated tag for your first version
git tag -m "First Version" v0.0.1

# Push the tag to remote
git push --tags
```

### 3. Add Your Design Files

1. Place synthesizable HDL code in `rtl/`
2. Add testbenches to `tb/`
3. Update project file lists in `top/<ProjectName>/list/`:
   - `<ProjectName>.src` - RTL source files
   - `<ProjectName>.con` - Constraint files
   - `<ProjectName>.sim` - Simulation-only files

### 4. Create Your Project

```bash
# Use HOG to create a new synthesis project
./Hog/Do CREATE <ProjectName>

# Example: Create a project called "myproj"
./Hog/Do CREATE myproj
```

This will create a new project directory under `Projects/<ProjectName>` using the HOG configuration files.

### 5. Run Simulation

```bash
# Navigate to ModelSim simulation directory
cd sim/modelsim

# Run the simulation
vsim -do run.do
```

---

## HOG Framework

This template uses **HDL-On-Git (Hog)**, a Git-integrated HDL build system developed at CERN. As a quickstart guide, here are some basic Hog commands.

### HOG Commands

```bash
# Create a new project
./Hog/Do CREATE <project-name>

# Run the full project workflow (synth + impl + bitstream)
./Hog/Do WORKFLOW <project-name>

# List projects in the repository
./Hog/Do LIST

# Show the help message for a directive (CREATE, WORKFLOW, etc.)
./Hog/Do <directive> HELP
```

For detailed HOG documentation, visit: [HOG User Documentation](https://hog.readthedocs.io/en/latest)

---

## VSCode Setup

This template includes VSCode configuration for HDL development. See [.vscode/README.md](.vscode/README.md) for setup instructions.

### Required Tools

- **HDL Simulator** - ModelSim/QuestaSim or your preffered simulator
- **Universal Ctags** - Code navigation
- **Verible Tools** - SystemVerilog language server and formatter

### Recommended VSCode Extensions

- Verilog-HDL/SystemVerilog/Bluespec SystemVerilog (Masahiro Hiramori)
- Ctags Companion (Gediminas Zlatkus)

---

## Supported Tools

Tools not on this list may still work, but have not been verified.

### Synthesis Tools

- Xilinx Vivado
- Intel Quartus Prime

### Simulation Tools

- ModelSim
- QuestaSim

---

## Example Design

The template includes a simple example design to demonstrate the project structure:

- **RTL**: [rtl/example.sv](rtl/example.sv) - 32-bit adder module
- **Testbench**: [tb/example_tb.sv](tb/example_tb.sv) - Simple directed test

Run the example simulation:

```bash
cd sim/modelsim
vsim -do run.do
```

---

## Coding Standards

This template uses HDL best practices:

- **Default Nettype**: All files use `` `default_nettype none `` to prevent implicit nets
- **Timescale**: Consistent `` `timescale 1ps/1ps `` across all modules
- **Directory Separation**: Synthesis code (rtl/) strictly separated from verification (tb/)

---

## Contributing

When adding new code to this repository:

1. Place synthesizable RTL in `rtl/`
2. Place testbenches in `tb/`
3. Update HOG list files in `top/<project>/list/`
4. Follow existing coding standards
5. Test your changes with simulation before synthesis
6. Update documentation as needed

---

## Git Workflow

### Version Tagging

HOG requires version tags for reproducible builds:

```bash
# Create a new version tag
git tag -m "Release version X.Y.Z" vX.Y.Z

# Push tags to remote
git push --tags
```

### Submodule Updates

To update the HOG framework:

```bash
# Update to latest HOG version
git submodule update --remote Hog

# Commit the submodule update
git add Hog
git commit -m "Update HOG framework"
```

---

## License

This template repository is provided as-is for educational and commercial use.

The HOG framework is licensed under Apache License 2.0 - see [Hog/LICENSE](Hog/LICENSE).

---

## Resources

- [HOG Documentation](https://hog.readthedocs.io) - Complete HOG user guide
- [HOG GitLab Repository](https://gitlab.com/hog-cern/Hog) - HOG source code and issues
- [VSCode Setup Guide](.vscode/README.md) - IDE configuration instructions
- [Simulation Guide](sim/README.md) - Running and debugging simulations
- [Project Structure](top/README.md) - HOG project organization

---

## Support

For HOG-specific issues, consult the [HOG documentation](https://hog.readthedocs.io) or open an issue on the [HOG GitLab](https://gitlab.com/hog-cern/Hog).

For template-specific questions, please open an issue in this repository.