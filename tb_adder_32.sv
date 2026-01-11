module tb_adder_32;

    logic [31:0] a, b;
    logic        c_in;
    logic [31:0] sum;
    logic        c_out;

    logic [32:0] expected;
    logic [3:0]  test_counter;


    adder_32 dut (
        .a(a),
        .b(b),
        .c_in(c_in),
        .sum(sum),
        .c_out(c_out)
    );


    task check_result;
        input string test_name;
        begin
            expected = a + b + c_in;

            if ({c_out, sum} === expected) begin
                $display("PASS: %s, inputs(a=%h, b=%h, cin=%b) ===> output(sum=%h, cout=%b)",
                          test_name, a, b, c_in, sum, c_out);
                test_counter = test_counter + 1;

            end
            else
                $display("FAIL: %s, inputs(a=%h, b=%h, cin=%b) ===> output(sum=%h, cout=%b)",
                          test_name, a, b, c_in, sum, c_out,
                          expected[31:0], expected[32]);
        end
    endtask

    initial begin
        $display("---- 32-bit Adder Test ----");
        $display("------ Defined cases ------");

        test_counter = 0; 

        a = 32'd0; b = 32'd0; c_in = 0;
        #1 check_result("Zero + Zero");

        a = 32'd5; b = 32'd10; c_in = 0;
        #1 check_result("5 + 10");

        a = 32'hFFFFFFFF; b = 32'd1; c_in = 0;
        #1 check_result("Overflow Case");

        a = 32'h80000000; b = 32'h80000000; c_in = 0;
        #1 check_result("MSB Overflow");

        a = 32'd100; b = 32'd200; c_in = 1;
        #1 check_result("Carry In Case");

        $display("------- Random Cases ------");

        repeat (5) begin
            a = $random;
            b = $random;
            c_in = $random;
            #1 check_result("Random Test");
        end

        $display("---- Test Completed ----");
        $display("%d out of 10 test cases passed", test_counter);

        $finish;
    end

endmodule
