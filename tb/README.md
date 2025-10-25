# Testbenches

Verification and test code for RTL designs. Supports both directed testing and UVM-based verification.

---

## Purpose

The `tb/` directory contains:

- **Testbenches** - SystemVerilog/Verilog test environments
- **Directed Tests** - Specific test scenarios and edge cases
- **UVM Testbenches** - Universal Verification Methodology environments
- **Test Utilities** - Reusable verification components

**Important:** Only verification code belongs here. Synthesizable RTL goes in [../rtl/](../rtl/).

---

## Quick Start

### Example Testbench

See [example_tb.sv](example_tb.sv) for a basic testbench:

```systemverilog
`timescale 1ns/1ps
`default_nettype none

module example_tb;
    // Testbench signals
    logic [31:0] a, b, c;

    // Instantiate DUT (Design Under Test)
    example uut (
        .a(a),
        .b(b),
        .c(c)
    );

    // Test stimulus
    initial begin
        a = 5;
        b = 6;
        #10ns;

        if (c == 11)
            $display("PASS: %0d + %0d = %0d", a, b, c);
        else
            $error("FAIL: Expected 11, got %0d", c);

        $stop;
    end
endmodule

`default_nettype wire
```

### Running Tests

```bash
cd sim/modelsim
vsim -do run.do
```

---

## Testbench Structure

### Basic Testbench Template

```systemverilog
module my_module_tb;
    // 1. Parameters and timescale
    `timescale 1ns/1ps
    parameter CLK_PERIOD = 10ns;

    // 2. Signals
    logic        clk;
    logic        rst;
    logic [7:0]  data_in;
    logic [7:0]  data_out;
    logic        valid;

    // 3. DUT instantiation
    my_module uut (
        .clk      (clk),
        .rst      (rst),
        .data_in  (data_in),
        .data_out (data_out),
        .valid    (valid)
    );

    // 4. Clock generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    // 5. Reset generation
    initial begin
        rst = 1;
        repeat(5) @(posedge clk);
        rst = 0;
    end

    // 6. Test stimulus
    initial begin
        // Wait for reset
        @(negedge rst);

        // Apply test vectors
        @(posedge clk);
        data_in = 8'hAA;

        // Check outputs
        wait(valid);
        assert(data_out == expected_value) else
            $error("Mismatch at time %0t", $time);

        // End simulation
        #100ns;
        $display("Test completed");
        $stop;
    end

    // 7. Timeout watchdog
    initial begin
        #1ms;
        $fatal("Simulation timeout");
    end
endmodule
```

---

## Verification Approaches

### 1. Directed Testing

Manually written tests for specific scenarios:
- Corner cases
- Known failure modes
- Regression tests for bug fixes

**Advantages:** Simple, targeted, easy to debug

**Example:**
```systemverilog
initial begin
    // Test case 1: Zero inputs
    test_add(0, 0, 0);

    // Test case 2: Maximum values
    test_add(32'hFFFFFFFF, 32'h1, 32'h0);  // Overflow

    // Test case 3: Random values
    repeat(100) begin
        a = $random;
        b = $random;
        test_add(a, b, a + b);
    end
end
```

### 2. Constrained Random Testing

Use SystemVerilog's randomization:

```systemverilog
class test_transaction;
    rand bit [7:0] data;
    rand bit [3:0] addr;

    constraint valid_addr { addr < 12; }
    constraint data_range { data inside {[0:200]}; }
endclass

initial begin
    test_transaction txn = new();
    repeat(1000) begin
        assert(txn.randomize());
        apply_transaction(txn);
    end
end
```

### 3. UVM (Universal Verification Methodology)

For complex designs, consider UVM:
- Reusable verification components
- Constrained random stimulus
- Functional coverage
- Scoreboards and checkers

**Note:** UVM requires SystemVerilog and UVM library. See [UVM Cookbook](https://verificationacademy.com/cookbook/uvm).

---

## Best Practices

### Assertions

Use assertions to catch errors early:

```systemverilog
// Immediate assertion
assert (data_valid == 1) else $error("Data not valid");

// Concurrent assertion (monitors signals over time)
property req_ack;
    @(posedge clk) req |-> ##[1:3] ack;
endproperty
assert property (req_ack) else $error("Ack not received");
```

### Self-Checking Testbenches

Automate pass/fail checking:

```systemverilog
int errors = 0;

task check_result(int expected, int actual);
    if (expected !== actual) begin
        $error("Mismatch: expected=%0d, actual=%0d", expected, actual);
        errors++;
    end
endtask

initial begin
    // Run tests
    run_all_tests();

    // Report results
    if (errors == 0)
        $display("*** TEST PASSED ***");
    else
        $error("*** TEST FAILED (%0d errors) ***", errors);
    $stop;
end
```

### Timeouts

Always include a timeout to prevent infinite simulation:

```systemverilog
initial begin
    #10ms;  // Adjust based on expected runtime
    $fatal("Simulation timeout - potential deadlock");
end
```

### Code Reuse

Create reusable verification components:

```
tb/
├── example_tb.sv       # Main testbench
├── bfm/                # Bus Functional Models
│   ├── axi_master.sv
│   └── uart_driver.sv
├── monitors/           # Protocol monitors
│   └── axi_monitor.sv
└── checkers/           # Verification checkers
    └── scoreboard.sv
```

---

## Debugging Tips

1. **Use $display statements** to trace execution
2. **Add waveforms** for critical signals (see [../sim/README.md](../sim/README.md))
3. **Use assertions** to catch protocol violations
4. **Enable all warnings** in simulator
5. **Test incrementally** - start simple, add complexity

---

## Integration with Simulation

Testbenches are compiled by simulation scripts in [../sim/](../sim/).

Add new testbenches to [../sim/modelsim/compile.do](../sim/modelsim/compile.do):

```tcl
vlog $tb/my_new_tb.sv
```

---

## Resources

- [SystemVerilog for Verification](https://www.amazon.com/SystemVerilog-Verification-Learning-Testbench-Language/dp/1461407141)
- [UVM Cookbook](https://verificationacademy.com/cookbook/uvm)
- [Verification Academy](https://verificationacademy.com/)
- [ChipVerify Tutorials](https://www.chipverify.com/)

For simulation workflows, see [../sim/README.md](../sim/README.md).