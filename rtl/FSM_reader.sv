`default_nettype none
module FSM_reader (input wire clk, input wire rst_n, input wire start, 
					input wire valid, input wire [31:0] flash_data, 
					input wire addr_finish, input wire addr_is_old, output wire addr_start, 
					output wire read, output reg [31:0] data_out, output wire finish); 
	// update_data, addr_start, read, finish
	typedef enum logic [6:0] {
		idle 			= 7'b000_0000,
		request_addr 	= 7'b001_0100,
		wait_addr 		= 7'b010_0000,
		request_data 	= 7'b011_0010, 
		wait_data 		= 7'b100_1000,
		reuse_update 	= 7'b101_0100,
		wait_reuse		= 7'b101_0000,
		finish_state 	= 7'b111_0001
	} statetype;

	statetype state;

	wire update_data;

	assign update_data = state[3];
	assign addr_start = state[2];
	assign read = state[1];
	assign finish = state[0];

	always_ff @(posedge clk, negedge rst_n)
		if (~rst_n) state <= idle;
		else
			case (state)
				idle: state <= start ? (addr_is_old ? reuse_update : request_addr) : idle;
				request_addr: state <= wait_addr;
				wait_addr: state <= addr_finish ? request_data : wait_addr;
				request_data: state <= wait_data;
				wait_data: state <= valid ? finish_state : wait_data;
				reuse_update: state <= wait_reuse;
				wait_reuse: state <= addr_finish ? finish_state : wait_reuse;
				finish_state: state <= idle;
				default: state <= idle;
			endcase

	always_ff @(posedge clk, negedge rst_n)
		if (~rst_n) data_out <= 32'd0;
		else if (update_data) 
			// we cannot always check valid since it could be glichy, 
			// so we should only care about it at proper state
			if (valid) data_out <= flash_data;
endmodule
`default_nettype wire
