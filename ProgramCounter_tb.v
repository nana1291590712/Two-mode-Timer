`timescale 1 ns / 100 ps

module ProgramCounter_tb;

    reg clk;
    reg [7:0] ResetVal;
    reg [7:0] LoadVal;
    reg reset;
    reg load;
    reg inc;
    wire [7:0] PCoutput;

    ProgramCounter uut (
        .clk(clk),
        .ResetVal(ResetVal),
        .LoadVal(LoadVal),
        .reset(reset),
        .load(load),
        .inc(inc),
        .PCoutput(PCoutput)
    );

    // Generate 100Hz clock for simulation (period = 10ms = 10_000_000 ns)
    initial begin
        clk = 0;
        forever #50 clk = ~clk; // 100ns period for quick simulation
    end

    initial begin
        $display("=== ProgramCounter Testbench ===");
        $monitor("Time=%0t | reset=%b | load=%b | inc=%b | PC=%d", $time, reset, load, inc, PCoutput);

        // Initial conditions
        ResetVal = 8'd77;
        LoadVal = 8'd22;
        reset = 0; load = 0; inc = 0;

        // Apply async reset (should set to 77 immediately)
        #20 reset = 1;
        #20 reset = 0;

        // Apply load on next clock
        #30 load = 1;
        #100 load = 0;

        // Apply increment for a few cycles
        #100 inc = 1;
        #300 inc = 0;

        // Apply another async reset
        #50 reset = 1;
        #20 reset = 0;

        #200 $finish;
    end

endmodule
