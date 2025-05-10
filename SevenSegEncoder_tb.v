`timescale 1 ns / 100 ps

module SevenSegEncoder_tb;

    reg [7:0] LSB;
    reg [7:0] MSB;
    reg ModeSel;

    wire [6:0] HexMSBH;
    wire [6:0] HexMSBL;
    wire [6:0] HexLSBH;
    wire [6:0] HexLSBL;

    // Instantiate the Unit Under Test
    SevenSegEncoder uut (
        .LSBBinary(LSB),
        .MSBBinary(MSB),
        .ModeSel(ModeSel),
        .HexMSBH(HexMSBH),
        .HexMSBL(HexMSBL),
        .HexLSBH(HexLSBH),
        .HexLSBL(HexLSBL)
    );

    // Helper function to convert 7-seg binary to human-readable digit
    function [7*8:1] seg_to_digit;
        input [6:0] seg;
        begin
            case (seg)
                7'b1000000: seg_to_digit = "0";
                7'b1111001: seg_to_digit = "1";
                7'b0100100: seg_to_digit = "2";
                7'b0110000: seg_to_digit = "3";
                7'b0011001: seg_to_digit = "4";
                7'b0010010: seg_to_digit = "5";
                7'b0000010: seg_to_digit = "6";
                7'b1111000: seg_to_digit = "7";
                7'b0000000: seg_to_digit = "8";
                7'b0010000: seg_to_digit = "9";
                default:    seg_to_digit = "?";
            endcase
        end
    endfunction

    initial begin
        $display("=== SevenSegEncoder Testbench ===");

        // Test 1
        ModeSel = 0; LSB = 8'd12; MSB = 8'd3; #10;
        $display("Time=%0t | ModeSel=%b | Display = %s%s.%s%s",
                 $time, ModeSel,
                 seg_to_digit(HexMSBH), seg_to_digit(HexMSBL),
                 seg_to_digit(HexLSBH), seg_to_digit(HexLSBL));

        // Test 2
        ModeSel = 1; LSB = 8'd12; MSB = 8'd3; #10;
        $display("Time=%0t | ModeSel=%b | Display = %s%s.%s%s",
                 $time, ModeSel,
                 seg_to_digit(HexMSBH), seg_to_digit(HexMSBL),
                 seg_to_digit(HexLSBH), seg_to_digit(HexLSBL));

        // Test 3
        ModeSel = 0; LSB = 8'd45; MSB = 8'd67; #10;
        $display("Time=%0t | ModeSel=%b | Display = %s%s.%s%s",
                 $time, ModeSel,
                 seg_to_digit(HexMSBH), seg_to_digit(HexMSBL),
                 seg_to_digit(HexLSBH), seg_to_digit(HexLSBL));

        // Test 4
        ModeSel = 1; LSB = 8'd45; MSB = 8'd67; #10;
        $display("Time=%0t | ModeSel=%b | Display = %s%s.%s%s",
                 $time, ModeSel,
                 seg_to_digit(HexMSBH), seg_to_digit(HexMSBL),
                 seg_to_digit(HexLSBH), seg_to_digit(HexLSBL));

        // Test 5
        ModeSel = 0; LSB = 8'd0; MSB = 8'd99; #10;
        $display("Time=%0t | ModeSel=%b | Display = %s%s.%s%s",
                 $time, ModeSel,
                 seg_to_digit(HexMSBH), seg_to_digit(HexMSBL),
                 seg_to_digit(HexLSBH), seg_to_digit(HexLSBL));

        // Test 6
        ModeSel = 1; LSB = 8'd0; MSB = 8'd99; #10;
        $display("Time=%0t | ModeSel=%b | Display = %s%s.%s%s",
                 $time, ModeSel,
                 seg_to_digit(HexMSBH), seg_to_digit(HexMSBL),
                 seg_to_digit(HexLSBH), seg_to_digit(HexLSBL));

        $finish;
    end

endmodule
