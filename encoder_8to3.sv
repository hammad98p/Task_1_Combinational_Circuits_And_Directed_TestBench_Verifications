module encoder_8to3 (
    input  logic [7:0] d,
    output logic [2:0] q
);

    always_comb begin
        case (d)
            8'b00000001: q = 3'b000;
            8'b00000010: q = 3'b001;
            8'b00000100: q = 3'b010;
            8'b00001000: q = 3'b011;
            8'b00010000: q = 3'b100;
            8'b00100000: q = 3'b101;
            8'b01000000: q = 3'b110;
            8'b10000000: q = 3'b111;
            default:     q = 3'b000;
        endcase
    end

endmodule
