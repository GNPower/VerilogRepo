`timescale 1ps/1ps
`ifndef DISABLE_DEFAULT_NET
`default_nettype none
`endif

module example (
    a,
    b,
    c
);

input logic [31:0] a;
input logic [31:0] b;

output logic [31:0] c;

always_comb begin : adder
    c = a + b;
end
    
endmodule
