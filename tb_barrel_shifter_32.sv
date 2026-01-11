`timescale 1ns/1ps
module tb_barrel_shifter_32;

    logic [31:0] d;
    logic [4:0]  shift_amt;
    logic [1:0]  op;
    logic        dir;
    logic [31:0] q;

    logic [31:0] expected;
    integer pass_count = 0;

    // DUT
    barrel_shifter_32 DUT (
        .d(d),
        .shift_amt(shift_amt),
        .op(op),
        .dir(dir),
        .q(q)
    );

    // -------- Test Case Struct --------
    typedef struct {
        string       name;
        logic [31:0] d;
        logic [4:0]  shift_amt;
        logic [1:0]  op;
        logic        dir;
    } test_case_t;

    test_case_t test_cases [10];

    // -------- Comparator Task --------
    task check_result(input string test_name);
        begin
            case (op)
                2'b00: expected = d << shift_amt;
                2'b01: expected = d >> shift_amt;
                2'b10: expected = $signed(d) >>> shift_amt;
                2'b11: begin
                    if (shift_amt == 0)
                        expected = d;
                    else if (dir == 0)
                        expected = (d << shift_amt) | (d >> (32 - shift_amt));
                    else
                        expected = (d >> shift_amt) | (d << (32 - shift_amt));
                end
                default: expected = d;
            endcase

            if (q === expected) begin
                $display("PASS: %s | d=%h sh=%0d op=%b dir=%b -> q=%h",
                         test_name, d, shift_amt, op, dir, q);
                pass_count++;
            end else begin
                $display("FAIL: %s | d=%h sh=%0d op=%b dir=%b -> q=%h (EXP=%h)",
                         test_name, d, shift_amt, op, dir, q, expected);
            end
        end
    endtask

    integer i;

    initial begin
        // -------- Directed Tests --------
        test_cases[0] = '{"LSL by 1", 32'h00000001, 5'd1, 2'b00, 0};
        test_cases[1] = '{"LSR by 4", 32'h80000000, 5'd4, 2'b01, 0};
        test_cases[2] = '{"ASR by 3", 32'hF0000000, 5'd3, 2'b10, 0};
        test_cases[3] = '{"ROL by 8", 32'h12345678, 5'd8, 2'b11, 0};
        test_cases[4] = '{"ROR by 8", 32'h87654321, 5'd8, 2'b11, 1};

        // -------- Random Tests --------
        for (i = 5; i < 10; i++) begin
            test_cases[i].name      = $sformatf("Random Test %0d", i-4);
            test_cases[i].d         = $random;
            test_cases[i].shift_amt = $random;
            test_cases[i].op        = $random;
            test_cases[i].dir       = $random;
        end

        // -------- Execute Tests --------
        for (i = 0; i < 10; i++) begin
            d         = test_cases[i].d;
            shift_amt = test_cases[i].shift_amt;
            op        = test_cases[i].op;
            dir       = test_cases[i].dir;
            #1;
            check_result(test_cases[i].name);
            #9;
        end

        $display("---- PASSED %0d / 10 TESTS ----", pass_count);
        $finish;
    end

endmodule
