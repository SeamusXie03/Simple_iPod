`default_nettype none
module FSM_addr (input wire clk, input wire rst_n, input wire start, input wire back_mode, 
				input wire [7:0] keyboard_in, input wire key_data_ready, 
				output reg [23:0] addr, output reg is_old, output reg finish);

	localparam char_R = 8'h2d; 
	localparam MAX_ADDR = 23'h7FFFF;
	localparam MIN_ADDR = 23'h0;

	wire restart, sync_restart;
	// only restart when see key_data_ready, since we only restart once for
	// one R
	assign restart = ((keyboard_in == char_R) & key_data_ready);
	doublesync syncrestart(.indata(restart), .outdata(sync_restart), .clk(clk), .reset(1'b1));

	always_ff @(posedge clk, negedge rst_n)
		if (~rst_n) finish <= 1'b0;
		else if (start) finish <= 1'b1;
		else finish <= 1'b0;

	always_ff @(posedge clk, negedge rst_n)
		if (~rst_n) addr <= 23'h0;
		else if (sync_restart) addr <= 23'h0;
		else if (start & is_old)
			// only allow update if we need a new value
			if (~back_mode)
				// avoid overflow
				if (addr == MAX_ADDR) addr <= 23'h0;
				else addr <= addr + 23'h1;
			else if (back_mode) 
				if (addr == MIN_ADDR) addr <= 23'h7FFFF;
				else addr <= addr - 23'h1;

	// determines reuse
	always_ff @(posedge clk, negedge rst_n)
		if (~rst_n) is_old <= 1'b0;
		else if (sync_restart) is_old <= 1'b0;
		else if (start) is_old <= ~is_old;
endmodule
`default_nettype wire
