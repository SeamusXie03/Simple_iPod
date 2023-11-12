`default_nettype none
`define USE_PACOBLAZE
module picoblaze (input wire clk, input wire [7:0] input_data, input wire data_ready, 
				output reg [7:0] led_2_to_9, output wire led_0);
	//--
	//------------------------------------------------------------------------------------
	//--
	//-- Signals used to connect KCPSM3 to program ROM and I/O logic
	//--
	wire[9:0]  address;
	wire[17:0]  instruction;
	wire[7:0]  port_id;
	wire[7:0]  out_port;
	reg[7:0]  in_port;
	wire  write_strobe;
	wire  read_strobe;
	reg  interrupt;
	wire  interrupt_ack;
	wire  kcpsm3_reset;
	
	pacoblaze3 led_8seg_kcpsm
	(
		.address(address),
		.instruction(instruction),
		.port_id(port_id),
		.write_strobe(write_strobe),
		.out_port(out_port),
		.read_strobe(read_strobe),
		.in_port(in_port),
		.interrupt(interrupt),
		.interrupt_ack(interrupt_ack),
		.reset(kcpsm3_reset),
		.clk(clk));

	wire [19:0] raw_instruction;
	
	pacoblaze_instruction_memory 
	pacoblaze_instruction_memory_inst(
		.addr(address),
		.outdata(raw_instruction)
	);
	
	always_ff @(posedge clk)
	      instruction <= raw_instruction[17:0];

    assign kcpsm3_reset = 0;                       
  
	//  ----------------------------------------------------------------------------------------------------------
	//  -- Interrupt 
	//  ----------------------------------------------------------------------------------------------------------
	//  --
	//  --
	//  -- Interrupt is used to provide a 1 second time reference.
	//  --
	//  --
	//  -- A simple binary counter is used to divide the 50MHz system clock and provide interrupt pulses.
	//  --
	
	// Note that because we are using clock enable we DO NOT need to synchronize with clk
	
	always_ff @(posedge clk, posedge interrupt_ack) 
		if (interrupt_ack) //if we get reset, reset interrupt in order to wait for next clock.
			interrupt <= 0;
		else if (data_ready) interrupt <= 1;

	//  --
	//  ----------------------------------------------------------------------------------------------------------
	//  -- KCPSM3 input ports 
	//  ----------------------------------------------------------------------------------------------------------
	//  --
	//  --
	//  -- The inputs connect via a pipelined multiplexer
	//  --
	always_ff @(posedge clk)	
		case (port_id[7:0])
			8'h0:    in_port <= input_data;
			default: in_port <= 8'bx;
		endcase
   
	//
	//  --
	//  ----------------------------------------------------------------------------------------------------------
	//  -- KCPSM3 output ports 
	//  ----------------------------------------------------------------------------------------------------------
	//  --
	//  -- adding the output registers to the processor
	//  --
	//   
	always_ff @(posedge clk) begin
		//port 40 hex for led_0 
		if (write_strobe & port_id[6])  //clock enable 
			led_0 <= out_port[0];

		//port 80 hex for led_2_to_9 
		if (write_strobe & port_id[7])  //clock enable 
			led_2_to_9 <= out_port;
	end
endmodule
