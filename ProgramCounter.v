module ProgramCounter (
    input clk,                 // Clock (100Hz or 1Hz)
    input [7:0] ResetVal,      // Value loaded on reset
    input [7:0] LoadVal,       // Value loaded on load
    input reset,               // Async reset (active-high, immediate)
    input load,                // Sync load (active-high on clk edge)
    input inc,                 // Sync increment (active-high on clk edge)
    output [7:0] PCoutput      // 8-bit PC output
);

    reg [7:0] PC;

    assign PCoutput = PC;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            PC <= ResetVal;
        end else begin
            if (load)
                PC <= LoadVal;
            else if (inc)
                PC <= PC + 1;
        end
    end

endmodule
