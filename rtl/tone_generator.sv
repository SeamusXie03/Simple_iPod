/*
* This module takes in a inclk, rst_n, and three SW. It outputs a tone give
* the SW positions.
* pre: The inclk has to be 50MHz.
* */
`default_nettype none
module tone_generator (input wire inclk, input wire rst_n, input wire [2:0] SW, output wire outclk, output wire outclk_Not);
	// count = f_in / f_out / 2
	// We are dividing by two since half of the count goes to low, and half of
	// the count goes to high
	localparam Do = 32'hBAB9;
	localparam Re = 32'hA65D;
	localparam Mi = 32'h9430;
	localparam Fa = 32'h8BE9;
	localparam So = 32'h7CB8;
	localparam La = 32'h6EF9;
	localparam Si = 32'h62F1;
	localparam Do2 = 32'h5D5D;
	// hardcoded to save transistors

	reg [31:0] div_clk_count;
	
	always_comb
		// it is quite impossible for the switches to become unknown, so this
		// table is enough
		case (SW)
			3'd0: div_clk_count = Do; 
			3'd1: div_clk_count = Re; 
			3'd2: div_clk_count = Mi; 
			3'd3: div_clk_count = Fa;
			3'd4: div_clk_count = So;
			3'd5: div_clk_count = La;
			3'd6: div_clk_count = Si;
			3'd7: div_clk_count = Do2;
		endcase

	clock_divider clockd(.inclk(inclk), .div_clk_count(div_clk_count), .rst_n(rst_n), 
					.outclk(outclk), .outclk_Not(outclk_Not));
endmodule
`default_nettype wire
