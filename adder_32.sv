module adder_32 (

	input logic [31:0] a,
	input logic [31:0] b,
	input logic c_in,

	output logic [31:0] sum,
	output logic c_out
	);

	assign {c_out, sum} = a+b+c_in;

endmodule : adder_32