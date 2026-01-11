module barrel_shifter_32 (
    input  logic [31:0] d,
    input  logic [4:0]  shift_amt,
    input  logic [1:0]  op,        // 00: LSL, 01: LSR, 10: ASR, 11: ROT
    input  logic        dir,       // 0: left, 1: right (for rotate)
    output logic [31:0] q
);

    always_comb begin
        case (op)

            // Logical Shift Left
            2'b00: q = d << shift_amt;

            // Logical Shift Right
            2'b01: q = d >> shift_amt;

            // Arithmetic Shift Right
            2'b10: q = $signed(d) >>> shift_amt;

            // Rotate
            2'b11: begin
                if (shift_amt == 0)
                    q = d;
                else if (dir == 1'b0)
                    // Rotate Left
                    q = (d << shift_amt) | (d >> (32 - shift_amt));
                else
                    // Rotate Right
                    q = (d >> shift_amt) | (d << (32 - shift_amt));
            end

            default: q = d;
        endcase
    end

endmodule
