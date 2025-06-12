`timescale 1ps/1ps
`ifndef DISABLE_DEFAULT_NET
`default_nettype none
`endif

module example_tb;

    logic [31:0] a;
    logic [31:0] b;
    logic [31:0] c;

    example UUT
    (
        .a(a),
        .b(b),
        .c(c)
    );

    initial begin
        a = 32'd5;
        b = 32'd6;
        #100;
        $stop;
    end

endmodule
