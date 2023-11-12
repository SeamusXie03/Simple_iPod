`default_nettype none
module FSM_controller (input wire clk, input wire rst_n, input wire start, 
						input wire [7:0] keyboard_in, input wire kbd_data_ready,
						input wire [31:0] data_in, input wire read_finish, input wire is_first, 
						output wire read_start, output reg [7:0] audio_data, output wire finish, 
						output reg back_mode);
   localparam char_B = 8'h32;
   localparam char_E = 8'h24;
   localparam char_F = 8'h2b;
   localparam char_D = 8'h23;

   // readstart, load_lower, load_upper, finish
   typedef enum logic [6:0] {
		pause 			= 7'b000_0000,
		wait_start		= 7'b001_0000,
		request_data	= 7'b010_1000,
		wait_data		= 7'b011_0000,
		play_lower		= 7'b100_0100,
		play_upper		= 7'b101_0010,
		finish_state	= 7'b110_0001
	} statetype;

	statetype state;

	wire load_lower, load_upper, back, forward, play, stop;
	wire sync_back, sync_forward, sync_play, sync_stop;

	assign read_start = state[3];
	assign load_lower = state[2];
	assign load_upper = state[1];
	assign finish = state[0];

	// IMPORTANT: we should only care about keyboard input when they are
	// ready, since they have gliches
	assign back = (keyboard_in == char_B) & kbd_data_ready;
	assign forward = (keyboard_in == char_F) & kbd_data_ready;
	assign play = (keyboard_in == char_E) & kbd_data_ready;
	assign stop = (keyboard_in == char_D) & kbd_data_ready;

	doublesync syncback(.indata(back), .outdata(sync_back), .clk(clk), .reset(1'b1));                
	doublesync syncforward(.indata(forward), .outdata(sync_forward), .clk(clk), .reset(1'b1));               
	doublesync syncplay(.indata(play), .outdata(sync_play), .clk(clk), .reset(1'b1));                
	doublesync syncstop(.indata(stop), .outdata(sync_stop), .clk(clk), .reset(1'b1));                

	always_ff @(posedge clk, negedge rst_n)
		if (~rst_n) state <= pause;
		else
			case (state)
				pause: state <= play ? wait_start : pause;
				wait_start: state <= stop ? pause : (start ? request_data : wait_start);
				// stop has higher priority
				request_data: state <= wait_data;
				wait_data: begin
							if (read_finish)
								// if read not finish, spin
								if (~back_mode)
									// if forward, lower zeroth, upper first
									state <= is_first ? play_upper : play_lower;
								else 
									// if backward, upper zeroth, lower first
									state <= is_first ? play_lower : play_upper;
							end
				play_lower: state <= finish_state;
				play_upper: state <= finish_state;
				finish_state: state <= wait_start;
				default: state <= pause;
			endcase

	// 0 is forward mode, 1 is backward mode
	always_ff @(posedge clk, negedge rst_n)
		if (~rst_n) back_mode <= 1'b0;
		else if (back) back_mode <= 1'b1;
		else if (forward) back_mode <= 1'b0;

	// play the corresponding audio data given upper or lower
	always_ff @(posedge clk, negedge rst_n)
		if (~rst_n) audio_data <= 8'd0;
		else if (load_upper) audio_data <= data_in[31:24];
		else if (load_lower) audio_data <= data_in[15:8];
endmodule 
`default_nettype wire 
