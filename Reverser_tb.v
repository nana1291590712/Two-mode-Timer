`timescale 1 ns / 100 ps

module Reverser_tb;

    reg [7:0] RevIn;
    reg ModeSel;
    wire [7:0] RevOut;

    Reverser uut (
        .RevIn(RevIn),
        .ModeSel(ModeSel),
        .RevOut(RevOut)
    );

    initial begin
        $display("=== Reverser Testbench ===");
        $monitor("Time=%0t | ModeSel=%b | RevIn=%d | RevOut=%d", $time, ModeSel, RevIn, RevOut);

        // Up-count mode (pass-through)
        ModeSel = 0;
        RevIn = 8'd12; #10;
        RevIn = 8'd45; #10;
        RevIn = 8'd99; #10;

        // Down-count mode (reversed)
        ModeSel = 1;
        RevIn = 8'd0;  #10;
        RevIn = 8'd1;  #10;
        RevIn = 8'd12; #10;
        RevIn = 8'd99; #10;

        $finish;
    end

endmodule
