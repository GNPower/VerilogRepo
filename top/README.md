# Synthesis Projects

HOG project definitions for vendor synthesis tools (Vivado, Quartus, Diamond, etc.).

---

## Purpose

The `top/` directory contains:

- **Project Definitions** - One subdirectory per synthesis project
- **HOG Configuration** - `hog.conf` files with project settings
- **File Lists** - `.src`, `.con`, and `.sim` files defining project sources
- **Constraints** - Timing and placement constraints (optionally)

Each project is managed by HOG and can be regenerated from these configuration files.

---

## Quick Start

### Project Structure

```
top/
└── myproj/              # Example project
    ├── hog.conf         # HOG configuration (tool settings, parameters, etc.)
    └── list/            # File lists
        ├── myproj.src   # RTL source files
        ├── myproj.con   # Constraint files (.xdc, .sdc, .tcl)
        └── myproj.sim   # Simulation-only files
```

### Creating a New Project

```bash
# From repository root
./Hog/Do CREATE <project-name>
```

This creates `Projects/<project-name>/` from the HOG configuration files.

---

## HOG Configuration

### hog.conf

Main project configuration file. See [myproj/hog.conf](myproj/hog.conf) for example.

**Common settings:**

```ini
[main]
PART = xc7z010clg400-1               # Target FPGA part number
IP_REPO_PATHS = ../../../ip/custom  # Custom IP repository paths

[synth_1]
STEPS.SYNTH_DESIGN.ARGS.RETIMING = true
STEPS.SYNTH_DESIGN.ARGS.FLATTEN_HIERARCHY = rebuilt

[impl_1]
STEPS.PHYS_OPT_DESIGN.IS_ENABLED = 1
STEPS.WRITE_BITSTREAM.ARGS.BIN_FILE = 1

[hog]
ALLOW_FAIL_ON_GIT = false    # Enforce Git version control
ALLOW_FAIL_ON_LIST = false   # Enforce list file correctness

[generics]
DATA_WIDTH = 32              # Generic/parameter values for top module
```

For complete options, see [HOG Documentation - hog.conf](https://hog.readthedocs.io/en/latest/02-User-Manual/02-Hog-local/#the-hogconf-file).

---

## File Lists

HOG uses `.src`, `.con`, and `.sim` files to define project sources.

### .src - RTL Source Files

Lists all synthesizable HDL files and IP cores.

**Format:**
```tcl
# Library name in brackets
[work]
# Relative paths from repository root
../../../rtl/example.sv
../../../rtl/my_module.sv

# IP cores
[ip_lib]
../../../ip/xilinx/clk_wiz/clk_wiz.xci
../../../ip/xilinx/fifo/async_fifo.xci

# Different library
[custom_lib]
../../../rtl/custom/special_module.sv
```

**Key Points:**
- Paths are relative to repository root (use `../../../`)
- Files are compiled in order listed
- `[library_name]` specifies VHDL/Verilog library

### .con - Constraint Files

Lists timing, placement, and I/O constraints.

**Format:**
```tcl
[work]
../../../constraints/timing.xdc     # Xilinx Design Constraints
../../../constraints/pinout.xdc
../../../constraints/physical.tcl
```

**File Types:**
- `.xdc` - Xilinx Design Constraints
- `.sdc` - Synopsys Design Constraints (Intel, Lattice)
- `.tcl` - Tcl scripts (for programmatic constraints)

### .sim - Simulation Files

Lists files used only in simulation (not synthesis).

**Format:**
```tcl
[work]
../../../tb/example_tb.sv
../../../tb/test_utils.sv
```

This separates testbench code from synthesis flow.

---

## HOG Commands

### Create/Recreate Project

```bash
./Hog/Do CREATE <project-name>
```

Creates vendor tool project from HOG configuration.

### Build (Synthesize + Implement + Bitstream)

```bash
./Hog/Do WORKFLOW <project-name>
```

### List Projects

```bash
./Hog/Do LIST
```

---

## Multi-Project Support

HOG supports multiple projects in one repository:

```
top/
├── project_a/       # FPGA board A
│   ├── hog.conf
│   └── list/
├── project_b/       # FPGA board B
│   ├── hog.conf
│   └── list/
└── project_c/       # ASIC version
    ├── hog.conf
    └── list/
```

Each project can target different FPGAs, use different RTL subsets, or have different configurations.

---

## Version Control Integration

HOG embeds Git version information in bitstreams:
- Git commit SHA
- Git tag (if present)
- Build timestamp

This ensures **reproducible builds** - every bitstream is tied to a specific Git commit.

### Tagging Releases

```bash
git tag -m "Release v1.0.0" v1.0.0
git push --tags
```

HOG will embed "v1.0.0" in the generated bitstream.

---

## Best Practices

1. **One project per target** - Separate projects for different boards/devices
2. **Use relative paths** - All paths in list files are `../../../`
3. **Keep hog.conf minimal** - Only specify non-default settings
4. **Version everything** - Commit all HOG files, never commit generated projects
5. **Test before tagging** - Ensure builds succeed before creating version tags
6. **Document settings** - Comment non-obvious hog.conf settings

---

## CI/CD Integration

HOG includes GitLab CI templates for automated builds:

```yaml
# .gitlab-ci.yml
include:
  - project: 'hog-cern/Hog'
    file: '/YAML/hog.yml'
```

This enables:
- Automatic synthesis on commits
- Bitstream artifact generation
- Multi-project parallel builds

---

## Resources

- [HOG Documentation](https://hog.readthedocs.io/) - Complete user guide
- [HOG GitLab Repository](https://gitlab.com/hog-cern/Hog) - Source code and issues
