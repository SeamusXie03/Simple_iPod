`default_nettype none
module hex_control (input wire clk, input wire rst_n, input wire [31:0] count_on_27MHz,  
					output reg [31:0] count_on_50MHz);
	localparam clk_50MHz = 50;
	localparam clk_27MHz = 27;
	// since we only need the ratio, this is fine to use

	always_ff @(posedge clk, negedge rst_n)
		if (~rst_n) count_on_50MHz <= 32'd0;
		else count_on_50MHz <= clk_50MHz * count_on_27MHz / clk_27MHz;
		// translate count on 27MHz to 50MHz, since we need to display them on HEX
		// noted this is not exact since we are using integer to perform
		// conversion
endmodule
`default_nettype wire
