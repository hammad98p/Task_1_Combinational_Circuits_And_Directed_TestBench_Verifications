`timescale 1ns/1ps
module tb_encoder_8to3;

    logic [7:0] d;
    logic [2:0] q;
    logic [2:0] expected;

    integer pass_count = 0;


    encoder_8to3 DUT (
        .d(d),
        .q(q)
    );

    typedef struct {
        string      name;
        logic [7:0] d;
    } test_case_t;

    test_case_t test_cases [6];

    task check_result(input string test_name);
        begin
            case (d)
                8'b00000001: expected = 3'b000;
                8'b00000010: expected = 3'b001;
                8'b00000100: expected = 3'b010;
                8'b00001000: expected = 3'b011;
                8'b00010000: expected = 3'b100;
                8'b00100000: expected = 3'b101;
                8'b01000000: expected = 3'b110;
                8'b10000000: expected = 3'b111;
                default:     expected = 3'b000;
            endcase

            if (q === expected) begin
                $display("PASS: %s | d=%b -> q=%b",
                         test_name, d, q);
                pass_count++;
            end else begin
                $display("FAIL: %s | d=%b -> q=%b (EXP=%b)",
                         test_name, d, q, expected);
            end
        end
    endtask

    integer i;

    initial begin
 
        test_cases[0] = '{"Valid: bit 4", 8'b00010000};
        test_cases[1] = '{"Valid: bit 5", 8'b00100000};
        test_cases[2] = '{"Valid: bit 6", 8'b01000000};
        test_cases[3] = '{"Invalid: multiple bits", 8'b00000110};
        test_cases[4] = '{"Invalid: multiple bits", 8'b10010000};
        test_cases[5] = '{"Invalid: multiple bits", 8'b00011110};

        for (i = 0; i < 6; i++) begin
            d = test_cases[i].d;
            #1;
            check_result(test_cases[i].name);
            #9;
        end

        $display("---- Tests Passed: %0d / 6 ----", pass_count);
        $finish;
    end

endmodule
