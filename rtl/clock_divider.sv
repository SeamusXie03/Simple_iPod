/*
* This is an Up Down counter.
* It outputs a frequency given div_clk_count as outclk and outclk_Not
* */
`default_nettype none
module clock_divider #(parameter N = 32) (input wire inclk, input wire [N-1:0] div_clk_count, input wire rst_n, 
					output reg outclk, output wire outclk_Not);
	reg [N-1:0] clock_count;

	always_ff @(posedge inclk, negedge rst_n) 
		if (~rst_n) begin
			clock_count <= 0;
			outclk <= 0;
		end
		// Important: This is larger and equal since the SW inputs are
		// asynchronous. It is likely that we shift from a higher frequency to a lower
		// frequency so clock_count is larger than the new value.
		else if (clock_count >= div_clk_count - 1) begin 
				clock_count <= 0;
				outclk <= ~outclk;
		end else clock_count <= clock_count + 1;
	
	assign outclk_Not = ~outclk;
endmodule
`default_nettype wire
