`default_nettype none
module led_controller (input wire clk, input wire rst_n, output reg [7:0] LED);
	reg [2:0] led_pos;
	/* this is the direction of shifting
	* 0 to 7 is logic 0 (since signals are zero by default)
	* the reverse direction is logic 1*/
	reg dir;

	localparam zeroth = 8'b00000001;
	localparam first = 8'b00000010;
	localparam second = 8'b00000100;
	localparam third = 8'b00001000;
	localparam fourth = 8'b00010000;
	localparam fifth = 8'b00100000;
	localparam sixth = 8'b01000000;
	localparam seventh = 8'b10000000;


	always_ff @(posedge clk, negedge rst_n) 
		if (~rst_n) dir <= 1'b0;
		// IMPORTANT: Next state logic here, so we have to reverse the direction before led_pos goes to 7
		else if (led_pos == 3'd6) dir <= 1'b1;
		else if (led_pos == 3'd1) dir <= 1'b0;

	always_ff @(posedge clk, negedge rst_n) 
		if (~rst_n) led_pos <= 3'd0; 
		else if (~dir) led_pos <= led_pos + 3'd1; 
		else led_pos <= led_pos - 3'd1; 
	
	// decoder from binary to one hot
	always_comb 
		case(led_pos)
			3'd0: LED = zeroth;
			3'd1: LED = first;
			3'd2: LED = second;
			3'd3: LED = third;
			3'd4: LED = fourth;
			3'd5: LED = fifth;
			3'd6: LED = sixth;
			3'd7: LED = seventh;
		endcase
endmodule
`default_nettype wire
