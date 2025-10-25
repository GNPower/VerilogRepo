# Simulation

Simulation scripts and environment for HDL verification. Currently configured for **ModelSim/QuestaSim**.

---

## Quick Start

```bash
cd sim/modelsim
vsim -do run.do
```

This compiles RTL, runs the testbench, and opens the waveform viewer.

---

## Directory Structure

```
sim/
├── modelsim/       # ModelSim/QuestaSim scripts
│   ├── run.do      # Main simulation script (entry point)
│   ├── compile.do  # Compile RTL and testbench sources
│   ├── setenv.do   # Path configuration
│   ├── waves.do    # Waveform viewer setup
│   ├── save.do     # Save simulation results
│   └── ipgen.do    # IP simulation model compilation
├── compile/        # Organize large compilation scripts here
├── waves/          # Additional waveform configurations
├── ipgen/          # IP-generated simulation files
└── libraries/      # Compiled vendor libraries
```

---

## Key Scripts

### run.do - Main Entry Point

Orchestrates the entire simulation flow:
1. Sets up paths (`setenv.do`)
2. Compiles IP models (`ipgen.do`)
3. Compiles sources (`compile.do`)
4. Elaborates design with debug info
5. Loads waveforms (`waves.do`)
6. Runs simulation

### compile.do - Source Compilation

Compiles RTL and testbench files with proper flags:
- `+define+DISABLE_DEFAULT_NET` - Enforces explicit declarations
- `+incdir+$rtl` - Adds RTL to include path

Add your source files here or organize into separate scripts in `compile/`.

### waves.do - Waveform Configuration

Configures the waveform viewer. Customize to add your signals:

```tcl
add wave /testbench/signal_name
add wave -radix hex /testbench/data_bus
```

---

## Compiling Vendor Libraries

For vendor IP simulation (Xilinx, Intel, etc.):

```bash
# From repository root
./Hog/Init.sh
```

This auto-detects tools and compiles necessary simulation libraries.

---

## Adding New Testbenches

1. Create testbench in [../tb/](../tb/)
2. Add to [compile.do](modelsim/compile.do):
   ```tcl
   vlog $tb/my_new_tb.sv
   ```
3. Run simulation:
   ```bash
   vsim -do run.do
   ```

---

## Batch Mode (No GUI)

```bash
vsim -c -do "do run.do; quit -f"
```

Useful for regression testing and CI/CD.

---

## Cross-Simulator Support

This template is organized to support multiple simulators. Currently configured for ModelSim/QuestaSim, but can be extended for:

- **Xilinx Vivado Simulator (xsim)**
- **Verilator** (open-source)
- **Icarus Verilog** (open-source)

Create similar script directories (e.g., `sim/xsim/`) for other tools.

---

## Best Practices

- Keep scripts organized and modular
- Use relative paths (defined in `setenv.do`)
- Version control .do files, not compiled outputs
- Save waveform configurations for reuse
- Automate regression testing

---

## Resources

- [ModelSim User Guide](https://www.intel.com/content/www/us/en/docs/programmable/683130/current/user-guide.html)
- [Verilator (Open-Source)](https://www.veripool.org/verilator/)
- [GTKWave (Open-Source Waveform Viewer)](http://gtkwave.sourceforge.net/)

For testbench guidelines, see [../tb/README.md](../tb/README.md).