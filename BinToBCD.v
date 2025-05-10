module BinToBCD (

    input [7:0] binary,
    output [3:0] tens,
    output [3:0] ones
	 
);

    assign tens = binary / 10;
    assign ones = binary % 10;
	 
endmodule
