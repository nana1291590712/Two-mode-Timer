module Reverser (
    input [7:0] RevIn,      // Input BCD (8-bit)
    input ModeSel,          // Mode selection
    output [7:0] RevOut     // Output BCD
);

    wire [7:0] reversed;

    assign reversed = 8'd99 - RevIn;        // Down-count mapping
    assign RevOut = ModeSel ? reversed : RevIn; // Pass-through or reversed

endmodule
