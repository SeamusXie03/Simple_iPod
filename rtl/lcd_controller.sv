`default_nettype none
module lcd_controller (input wire [7:0] SW, input wire [7:0] audio_data, output reg [31:0] scopeA_info, 
						output wire [7:0] valueH, output wire [7:0] valueG);	
	//numbers
	localparam character_2 =8'h32;
	
	//Uppercase Letters
	localparam character_D =8'h44;
	localparam character_L =8'h4C;
	localparam character_M =8'h4D;
	localparam character_R =8'h52;
	localparam character_S =8'h53;
	localparam character_F =8'h46;
	
	//Lowercase Letters
	localparam character_lowercase_a= 8'h61;
	localparam character_lowercase_e= 8'h65;
	localparam character_lowercase_i= 8'h69;
	localparam character_lowercase_o= 8'h6F;

	localparam character_space=8'h20;

	// we only need SW[3:1] since SW[0] is an enabler
	wire [2:0] tone = SW[3:1];

	// scope info section
	always_comb
		case (tone)
			3'd0: scopeA_info = {character_D, character_lowercase_o, character_space, character_space};
			3'd1: scopeA_info = {character_R, character_lowercase_e, character_space, character_space};
			3'd2: scopeA_info = {character_M, character_lowercase_i, character_space, character_space};
			3'd3: scopeA_info = {character_F, character_lowercase_a, character_space, character_space};
			3'd4: scopeA_info = {character_S, character_lowercase_o, character_space, character_space};
			3'd5: scopeA_info = {character_L, character_lowercase_a, character_space, character_space};
			3'd6: scopeA_info = {character_S, character_lowercase_i, character_space, character_space};
			3'd7: scopeA_info = {character_D, character_lowercase_o, character_2, character_space};
		endcase
		
	// display 0 when SW[0] is low
	assign valueH = SW[0] ? audio_data : 2'h00; 
	assign valueG = SW;
endmodule
`default_nettype wire
