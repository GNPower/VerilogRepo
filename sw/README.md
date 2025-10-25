# Software Models

C/C++ reference implementations for use in HDL testbenches via DPI (Direct Programming Interface).

---

## Purpose

The `sw/` directory contains:

- **Reference Models** - Software implementations of hardware algorithms
- **DPI Functions** - C/C++ code callable from SystemVerilog testbenches
- **Golden Models** - Known-good implementations for verification
- **Utilities** - Helper functions for test data generation

---

## DPI Integration

SystemVerilog DPI allows calling C/C++ functions from testbenches:

### Example C Implementation

**adder_model.c:**
```c
#include <stdint.h>

// Export function for use in SystemVerilog
uint32_t sw_adder(uint32_t a, uint32_t b) {
    return a + b;
}
```

### SystemVerilog DPI Import

**testbench.sv:**
```systemverilog
module testbench;
    // Import C function
    import "DPI-C" function int sw_adder(int a, int b);

    initial begin
        int hw_result, sw_result;

        // Call hardware (RTL)
        hw_result = uut.add(5, 6);

        // Call software model
        sw_result = sw_adder(5, 6);

        // Compare results
        if (hw_result !== sw_result)
            $error("Mismatch: HW=%0d, SW=%0d", hw_result, sw_result);
    end
endmodule
```

### Compilation with DPI

```bash
# Compile C code
gcc -c -fPIC adder_model.c -o adder_model.o

# Compile SystemVerilog with DPI
vlog testbench.sv
vsim -sv_lib adder_model testbench
```

---

## Best Practices

- **Keep models simple** - Focus on functionality, not performance optimizations
- **Match bit-accuracy** - Use fixed-point arithmetic if RTL uses it
- **Document thoroughly** - Explain algorithm and assumptions
- **Version control** - Treat software models as critical verification assets
- **Test the model** - Write unit tests for C/C++ code
- **Use standard libraries** - Leverage existing implementations when possible

---

## Resources

- [SystemVerilog DPI Tutorial](https://verificationguide.com/systemverilog/systemverilog-dpi/)
- [ModelSim DPI Guide](https://www.intel.com/content/www/us/en/docs/programmable/683130/current/direct-programming-interface-dpi.html)
- [IEEE 1800-2017 DPI Specification](https://ieeexplore.ieee.org/document/8299595)

For testbench integration, see [../tb/README.md](../tb/README.md). 