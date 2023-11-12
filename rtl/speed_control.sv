`default_nettype none
module speed_control (input wire clk, input wire rst_n, input wire speed_up_event, input wire speed_down_event, 
						input wire speed_reset_event, output reg signed [31:0] div_clk_count);
	localparam signed default_clk_count = 614; // 22KHz based on 27MHz
	localparam signed max_off_set = 32153; // 2^15-1-614
	localparam signed min_off_set = -614; 
	// infered from hex display, since 16 bit input to hex

	reg signed [15:0] off_set;

	always_ff @(posedge clk, negedge rst_n)
		if (~rst_n) off_set <= 16'd0;
		else if ((off_set == max_off_set) | (off_set == min_off_set))
			// once reach the limit, don't change anything
			off_set <= off_set;
		else
			case ({speed_reset_event, speed_down_event, speed_up_event})
				3'b100: off_set <= 16'd0;
				3'b010: off_set <= off_set + 16'd1;
				3'b001: off_set <= off_set - 16'd1;
				default: off_set <= off_set;
			endcase
	
	always_ff @(posedge clk, negedge rst_n)
		if (~rst_n) div_clk_count <= default_clk_count;
		else div_clk_count <= default_clk_count + {{16{off_set[15]}}, off_set};
		// proved to never overflow or underflow
endmodule
`default_nettype wire
