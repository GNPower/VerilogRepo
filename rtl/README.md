# RTL

This directory contains all synthesizable HDL source code for hardware implementation.

**Important:** Only synthesizable code belongs here. Testbenches and verification code go in [../tb/](../tb/).

---

## Directory Organization

For larger projects, organize RTL by functional area:

```
rtl/
├── common/              # Reusable utility modules
│   ├── synchronizers.sv
│   ├── edge_detect.sv
│   └── gray_counter.sv
├── memory/              # Memory controllers and interfaces
│   ├── ram_controller.sv
│   └── fifo_wrapper.sv
├── interface/           # Communication interfaces
│   ├── uart/
│   ├── spi/
│   └── i2c/
├── processing/          # Data processing modules
│   ├── dsp_core.sv
│   └── filter.sv
└── top/                 # Top-level integration modules
    └── system_top.sv
```

For simple projects, a flat structure is acceptable:
```
rtl/
├── example.sv
├── my_module.sv
└── another_module.sv
```

---

## Coding Standards

All RTL code in this project should follow these standards:

#### 1. Default Nettype None

Prevents accidental implicit wire declarations:

```verilog
`default_nettype none

module my_module (
    input  wire clk,
    output wire data_out
);
    // module code
endmodule

`default_nettype wire  // Restore default at end of file
```

#### 2. Timescale Declaration

Specify simulation time units consistently:

```verilog
`timescale 1ns/1ps
```

This project uses **1ns time unit** with **1ps precision** for all modules.

#### 3. Explicit Port Declarations

Always use explicit port directions and types:

```verilog
// Good - Explicit declarations
module good_example (
    input  wire        clk,
    input  wire        reset,
    input  wire [7:0]  data_in,
    output reg  [7:0]  data_out
);

// Bad - Implicit types
module bad_example (
    clk,
    reset,
    data_in,
    data_out
);
```

#### 4. Named Parameters

Use parameter names for clarity:

```verilog
// Good - Named parameters
my_fifo #(
    .WIDTH    (32),
    .DEPTH    (1024),
    .FWFT     (1)
) fifo_inst (
    .clk      (clk),
    .rst      (rst),
    // ...
);

// Avoid - Positional parameters
my_fifo #(32, 1024, 1) fifo_inst (/* ... */);
```

### Recommended Practices

#### 1. Module Organization

Structure modules consistently:

```verilog
`timescale 1ns/1ps
`default_nettype none

module my_module #(
    parameter WIDTH = 32,
    parameter DEPTH = 16
)(
    // Clock and reset
    input  wire                 clk,
    input  wire                 rst,

    // Input interface
    input  wire [WIDTH-1:0]     data_in,
    input  wire                 valid_in,
    output wire                 ready_out,

    // Output interface
    output wire [WIDTH-1:0]     data_out,
    output wire                 valid_out,
    input  wire                 ready_in
);

    // Parameter validation
    initial begin
        if (WIDTH < 1) $error("WIDTH must be positive");
        if (DEPTH < 2) $error("DEPTH must be >= 2");
    end

    // Local parameters
    localparam ADDR_WIDTH = $clog2(DEPTH);

    // Signal declarations
    reg [ADDR_WIDTH-1:0] write_ptr;
    reg [ADDR_WIDTH-1:0] read_ptr;
    wire                 fifo_full;
    wire                 fifo_empty;

    // Module logic
    always @(posedge clk) begin
        if (rst) begin
            write_ptr <= '0;
            read_ptr  <= '0;
        end else begin
            // ...
        end
    end

    // Continuous assignments
    assign fifo_full  = (write_ptr + 1'b1 == read_ptr);
    assign fifo_empty = (write_ptr == read_ptr);
    assign ready_out  = ~fifo_full;

endmodule

`default_nettype wire
```

#### 2. Naming Conventions

Follow consistent naming:

- **Modules**: `snake_case` (e.g., `uart_transmitter`)
- **Signals**: `snake_case` (e.g., `data_valid`, `byte_count`)
- **Parameters**: `UPPER_CASE` (e.g., `DATA_WIDTH`, `CLOCK_FREQ`)
- **Active-low signals**: `_n` suffix (e.g., `reset_n`, `chip_select_n`)
- **Clocks**: `clk` or `clk_<domain>` (e.g., `clk_200mhz`)
- **Resets**: `rst` or `reset`

#### 3. Reset Strategy

Use synchronous resets consistently:

```verilog
always @(posedge clk) begin
    if (rst) begin
        // Reset logic
        state      <= IDLE;
        counter    <= '0;
        data_valid <= 1'b0;
    end else begin
        // Normal logic
    end
end
```

**Active-High vs Active-Low:**
- If using active-low, use `_n` suffix (e.g., `rst_n`)

#### 4. Comments and Documentation

Document your code:

```verilog
//-----------------------------------------------------------------------------
// Module: data_processor
// Description:
//   Processes incoming data packets with configurable pipeline depth.
//   Supports backpressure via ready/valid handshaking.
//
// Parameters:
//   DATA_WIDTH - Width of data path in bits (must be power of 2)
//   PIPELINE_DEPTH - Number of pipeline stages (1-8)
//
// Interfaces:
//   Input:  AXI-Stream slave (data_in, valid_in, ready_out)
//   Output: AXI-Stream master (data_out, valid_out, ready_in)
//-----------------------------------------------------------------------------
```

#### 5. Avoid Latches

Always specify all branches in combinational logic:

```verilog
// Good - All cases covered
always_comb begin
    case (state)
        IDLE:    next_state = (start) ? ACTIVE : IDLE;
        ACTIVE:  next_state = (done) ? IDLE : ACTIVE;
        default: next_state = IDLE;  // Prevents latches
    endcase
end

// Bad - Missing default, creates latch
always_comb begin
    case (state)
        IDLE:   next_state = ACTIVE;
        ACTIVE: next_state = IDLE;
        // Missing default!
    endcase
end
```

---

## Example RTL Module

See [example.sv](example.sv) for a reference implementation:

```verilog
`timescale 1ns/1ps
`default_nettype none

module example #(
    parameter WIDTH = 32
)(
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    output wire [WIDTH-1:0] c
);

    always_comb begin
        c = a + b;
    end

endmodule

`default_nettype wire
```

**Key Features:**
- Parameterizable width
- Combinational adder logic
- Follows coding standards
- Fully synthesizable

---

## SystemVerilog vs Verilog

This template supports both Verilog-2001 and SystemVerilog:

---

## Linting and Verification

### VSCode Linting

This template uses Verible for SystemVerilog linting. See [../.vscode/README.md](../.vscode/README.md) for setup.

### Common Lint Warnings

- **Unused signals** - Remove or comment with `// synopsys translate_off`
- **Blocking assignments in sequential logic** - Use `<=` not `=`
- **Undriven outputs** - Ensure all outputs are assigned
- **Mixed edge sensitivity** - Use single clock edge

### Static Analysis Tools

Consider using:
- **Verilator** - Lint and fast simulation
- **Verible** - SystemVerilog style linter
- **Synopsys SpyGlass** - Advanced lint and CDC checking
- **Xilinx Vivado Reports** - Post-synthesis warnings

---

## HOG Integration

RTL files are added to HOG project lists in `top/<project>/list/<project>.src`:

```tcl
# RTL source files
[work]
../../../rtl/example.sv
../../../rtl/my_module.sv
../../../rtl/common/synchronizer.sv

# With library specification
[my_lib]
../../../rtl/custom_lib/special_module.sv
```

See [../top/README.md](../top/README.md) for HOG list file details.

---

## Testing Your RTL

1. **Write testbenches** - Place in [../tb/](../tb/)
2. **Run simulations** - Use scripts in [../sim/](../sim/)
4. **Synthesize** - Verify no synthesis warnings
5. **Timing analysis** - Meet timing constraints

---

## Resources

### HDL Guides
- [IEEE 1364-2001 Verilog Standard](https://ieeexplore.ieee.org/document/954909)
- [IEEE 1800-2017 SystemVerilog Standard](https://ieeexplore.ieee.org/document/8299595)
- [Sutherland HDL Coding Guidelines](http://www.sutherland-hdl.com/)
- [Verilog HDL: A Guide to Digital Design and Synthesis](https://www.amazon.com/Verilog-HDL-Guide-Digital-Synthesis/dp/0130449113)

### Coding Standards
- [Lowrisc Verilog Style Guide](https://github.com/lowRISC/style-guides/blob/master/VerilogCodingStyle.md)
- [OpenTitan RTL Style Guide](https://docs.opentitan.org/doc/rm/verilog_coding_style/)
- [Verification Academy](https://verificationacademy.com/)

### Tools
- [Verilator](https://www.veripool.org/verilator/) - Open-source simulator and lint
- [Verible](https://github.com/chipsalliance/verible) - SystemVerilog linter
