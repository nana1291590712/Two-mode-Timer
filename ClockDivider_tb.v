`timescale 1 ns / 100 ps

module ClockDivider_tb;

    reg CLK_50MHz;
    reg rst_n;
    wire CLK_100Hz;
    wire CLK_1Hz;

    // Instantiate DUT
    ClockDivider uut (
        .CLK_50MHz(CLK_50MHz),
        .rst_n(rst_n),
        .CLK_100Hz(CLK_100Hz),
        .CLK_1Hz(CLK_1Hz)
    );

    // 50 MHz clock generation
    initial begin
        CLK_50MHz = 0;
        forever #10 CLK_50MHz = ~CLK_50MHz;
    end

    // Monitor clock changes
    always @(CLK_100Hz or CLK_1Hz) begin
        $display("[%0t ms] CLK_100Hz=%b, CLK_1Hz=%b", $time/1_000_000, CLK_100Hz, CLK_1Hz);
    end

    // Test sequence
    initial begin
        $display("Starting ClockDivider Testbench");
        
        rst_n = 0;
        #100 rst_n = 1;
        
        #2_000_000_000 $display("\nTest completed");
        $finish;
    end

endmodule