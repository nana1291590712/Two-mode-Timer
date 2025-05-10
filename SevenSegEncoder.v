module SevenSegEncoder (
	
	input [7:0] LSBBinary,	//The LSB binary value input
	input [7:0] MSBBinary,	//The MSB bianry value input
	input ModeSel,				//Control signal for the interal Reverser
	
	output [6:0] HexMSBH,	//The 7-Seg display Signal for higer-digit in MSB
	output [6:0] HexMSBL,	//The 7-Seg display Signal for lower-digit in MSB
	output [6:0] HexLSBH,	//The 7-Seg display Signal for higer-digit in LSB
	output [6:0] HexLSBL		//The 7-Seg display Signal for lower-digit in LSB
	

);

    wire [7:0] revMSB, revLSB;
    wire [3:0] msb_hi, msb_lo;
    wire [3:0] lsb_hi, lsb_lo;

    // Mode-dependent reversal
    Reverser R0 (.RevIn(MSBBinary), .ModeSel(ModeSel), .RevOut(revMSB));
    Reverser R1 (.RevIn(LSBBinary), .ModeSel(ModeSel), .RevOut(revLSB));

    // Binary to BCD
    BinToBCD BCD_MSB (.binary(revMSB), .tens(msb_hi), .ones(msb_lo));
    BinToBCD BCD_LSB (.binary(revLSB), .tens(lsb_hi), .ones(lsb_lo));

    // BCD digit to 7-segment
    DigitTo7Seg S0 (.bin(msb_hi), .seg(HexMSBH));
    DigitTo7Seg S1 (.bin(msb_lo), .seg(HexMSBL));
    DigitTo7Seg S2 (.bin(lsb_hi), .seg(HexLSBH));
    DigitTo7Seg S3 (.bin(lsb_lo), .seg(HexLSBL));

endmodule