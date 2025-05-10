`timescale 1 ns / 100 ps

module TimerCoreLogic_tb;

    reg clk;
    reg rst_n;
    reg StartStop;
    reg ModeSel;

    wire [7:0] LSBbinaryout;
    wire [7:0] MSBbinaryout;

    TimerCoreLogic uut (
        .clk(clk),
        .rst_n(rst_n),
        .StartStop(StartStop),
        .ModeSel(ModeSel),
        .LSBbinaryout(LSBbinaryout),
        .MSBbinaryout(MSBbinaryout)
    );

    // 100Hz clock = 10ms per cycle, use 100ns for simulation
    initial begin
        clk = 0;
        forever #50 clk = ~clk;
    end

    // Helper
    task trigger_startstop;
        begin
            StartStop = 1; #100;
            StartStop = 0; #100;
        end
    endtask

    initial begin
        $display("=== TimerCoreLogic Testbench ===");

        // --- Test Mode A (Stopwatch) ---
        ModeSel = 0;
        rst_n = 0; StartStop = 0;
        #200 rst_n = 1;

        trigger_startstop(); // Start

        repeat (5) begin
            #1000;
            $display("Mode A: Time = %0d.%0d", MSBbinaryout, LSBbinaryout);
        end

        trigger_startstop(); // Pause
        #500;

        // --- Test Mode B (Countdown from 2:00) ---
        ModeSel = 1;
        rst_n = 0;
        #100 rst_n = 1;

        trigger_startstop(); // Start

        repeat (10) begin
            #100000; // simulate ~1s delay
            $display("Mode B: Time = %0d.%0d", MSBbinaryout, LSBbinaryout);
        end

        $finish;
    end

endmodule
