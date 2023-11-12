`default_nettype none
module edge_detector (input wire async_sig, input wire outclk, output wire out_sync_sig);
	// this is an edge detector composed of four flip_flops.
	// it needs to detect the rising edge of the async_sig such that we won't
	// have sychromization issue
	wire q1, q2, q3, q4;
	assign out_sync_sig = q3;

	flip_flop f1(async_sig, q4, 1'b1, q1);
	flip_flop f2(outclk, 1'b0, q1, q2);
	flip_flop f3(outclk, 1'b0, q2, q3);
	flip_flop f4(~outclk, 1'b0, q3, q4);
endmodule

module flip_flop (input wire clk, input wire clr, input wire data_in, output reg data_out);
	always_ff @(posedge clk, posedge clr) begin
		if (clr) data_out <= 1'b0;
		else data_out <= data_in;
	end
endmodule
`default_nettype wire
