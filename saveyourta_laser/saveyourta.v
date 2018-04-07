module saveyourta
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
        KEY,
        SW,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input			CLOCK_50;				//	50 MHz
	input   [9:0]   SW;
	input   [3:0]   KEY;

	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	
	wire resetn;
	assign resetn = KEY[0];
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn/plot
	// for the VGA controller, in addition to any other functionality your design may require.

    // wires to connect datapath and controller
    wire [1:0]enable;
	 wire [15:0] floor;
	 wire [15:0] floor_value;
	 wire [15:0] select;
	 wire [15:0] select_value;
	 wire laser;
	 wire [27:0] laser_value;
	 
	 
	/*
	 always @(*) begin
		 floor_value[0] = 1'b1;
		 floor_value[1] = 1'b0;
		 floor_value[2] = 1'b1;
		 floor_value[3] = 1'b0;
		 select_value[4] = 1'b1;
		 select_value[5] = 1'b1;
		 select_value[6] = 1'b1;
		 select_value[7] = 1'b1;
	 end
	*/
	
    // Instansiate datapath
	// datapath d0(...);
	
	select_control(~KEY[3], KEY[0], CLOCK_50, select_value[15:0]);

	floor_control(~KEY[2], KEY[0], select_value[15:0], floor_value[15:0]);
	
	laser_control(~KEY[1], KEY[0], CLOCK_50, laser_value[27:0]);
	
   datapath d0(CLOCK_50,KEY[0], enable[1:0], floor[15:0], floor_value[15:0], select[15:0], select_value[15:0], laser, laser_value[27:0], x, y, colour);
	
    // Instansiate FSM control
    // control c0(...);
   control c0(KEY[0],CLOCK_50,enable[1:0], floor[15:0], select[15:0], laser, writeEn); 
endmodule

module laser_control(shoot, reset_n, clock, laser_value);
	input shoot, reset_n, clock;
	output reg [27:0] laser_value;
	
	always @(posedge clock) begin
		if (laser_value > 25'd0) begin
			laser_value <= laser_value - 1'd1;
		end
		else if (shoot) begin
			laser_value <= 28'd1_9999_9999;
		end
		
	end
endmodule

module floor_control(change, reset_n, selections, floor_value);
	input change, reset_n;
	input [15:0] selections;
	
	output reg [15:0] floor_value;
	
	always @(posedge change) begin
		if (!reset_n) begin
			floor_value <= 16'b0000_0000_0000_0000;
		end
		////
		else if (selections[0] == 1'b1) begin
			floor_value[0] <= ~floor_value[0];
		end
		else if (selections[1] == 1'b1) begin
			floor_value[1] <= ~floor_value[1];
		end
		else if (selections[2] == 1'b1) begin
			floor_value[2] <= ~floor_value[2];
		end
		else if (selections[3] == 1'b1) begin
			floor_value[3] <= ~floor_value[3];
		end
		////
		else if (selections[4] == 1'b1) begin
			floor_value[4] <= ~floor_value[4];
		end
		else if (selections[5] == 1'b1) begin
			floor_value[5] <= ~floor_value[5];
		end
		else if (selections[6] == 1'b1) begin
			floor_value[6] <= ~floor_value[6];
		end
		else if (selections[7] == 1'b1) begin
			floor_value[7] <= ~floor_value[7];
		end
		////
		else if (selections[8] == 1'b1) begin
			floor_value[8] <= ~floor_value[8];
		end
		else if (selections[9] == 1'b1) begin
			floor_value[9] <= ~floor_value[9];
		end
		else if (selections[10] == 1'b1) begin
			floor_value[10] <= ~floor_value[10];
		end
		else if (selections[11] == 1'b1) begin
			floor_value[11] <= ~floor_value[11];
		end
		////
		else if (selections[12] == 1'b1) begin
			floor_value[12] <= ~floor_value[12];
		end
		else if (selections[13] == 1'b1) begin
			floor_value[13] <= ~floor_value[13];
		end
		else if (selections[14] == 1'b1) begin
			floor_value[14] <= ~floor_value[14];
		end
		else if (selections[15] == 1'b1) begin
			floor_value[15] <= ~floor_value[15];
		end
	end
endmodule


module select_control(go, reset_n, clock, selections);
	input go;
	input reset_n;
	input clock;

	
	output reg [15:0] selections;
	
	reg [4:0] current_select, next_select;
	
	localparam	S_0			= 5'd0,
					S_0_WAIT		= 5'd1,
					S_1			= 5'd2,
					S_1_WAIT		= 5'd3,
					S_2			= 5'd4,
					S_2_WAIT		= 5'd5,
					S_3			= 5'd6,
					S_3_WAIT		= 5'd7,
					
					
					S_4			= 5'd8,
					S_4_WAIT		= 5'd9,
					S_5			= 5'd10,
					S_5_WAIT		= 5'd11,
					S_6			= 5'd12,
					S_6_WAIT		= 5'd13,
					S_7			= 5'd14,
					S_7_WAIT		= 5'd15,
					
					
					S_8			= 5'd16,
					S_8_WAIT		= 5'd17,
					S_9			= 5'd18,
					S_9_WAIT		= 5'd19,
					S_10			= 5'd20,
					S_10_WAIT	= 5'd21,
					S_11			= 5'd22,
					S_11_WAIT	= 5'd23,
					
					S_12			= 5'd24,
					S_12_WAIT	= 5'd25,
					S_13			= 5'd26,
					S_13_WAIT	= 5'd27,
					S_14			= 5'd28,
					S_14_WAIT	= 5'd29,
					S_15			= 5'd30,
					S_15_WAIT	= 5'd31;
					
	always @(*)
        begin: state_table 
            case (current_select)
                S_0: next_select = go ? S_0_WAIT : S_0; 
                S_0_WAIT: next_select = go ? S_0_WAIT : S_1; 
					 S_1: next_select = go ? S_1_WAIT : S_1; 
					 S_1_WAIT: next_select = go ? S_1_WAIT : S_2;
					 S_2: next_select = go ? S_2_WAIT : S_2; 
					 S_2_WAIT: next_select = go ? S_2_WAIT : S_3;
					 S_3: next_select = go ? S_3_WAIT : S_3; 
					 S_3_WAIT: next_select = go ? S_3_WAIT : S_4;
					 
					 S_4: next_select = go ? S_4_WAIT : S_4; 
                S_4_WAIT: next_select = go ? S_4_WAIT : S_5; 
					 S_5: next_select = go ? S_5_WAIT : S_5; 
					 S_5_WAIT: next_select = go ? S_5_WAIT : S_6;
					 S_6: next_select = go ? S_6_WAIT : S_6; 
					 S_6_WAIT: next_select = go ? S_6_WAIT : S_7;
					 S_7: next_select = go ? S_7_WAIT : S_7; 
					 S_7_WAIT: next_select = go ? S_7_WAIT : S_8;
					 
					 S_8: next_select = go ? S_8_WAIT : S_8; 
                S_8_WAIT: next_select = go ? S_8_WAIT : S_9; 
					 S_9: next_select = go ? S_9_WAIT : S_9; 
					 S_9_WAIT: next_select = go ? S_9_WAIT : S_10;
					 S_10: next_select = go ? S_10_WAIT : S_10; 
					 S_10_WAIT: next_select = go ? S_10_WAIT : S_11;
					 S_11: next_select = go ? S_11_WAIT : S_11; 
					 S_11_WAIT: next_select = go ? S_11_WAIT : S_12;
					 
					 S_12: next_select = go ? S_12_WAIT : S_12; 
                S_12_WAIT: next_select = go ? S_12_WAIT : S_13; 
					 S_13: next_select = go ? S_13_WAIT : S_13; 
					 S_13_WAIT: next_select = go ? S_13_WAIT : S_14;
					 S_14: next_select = go ? S_14_WAIT : S_14; 
					 S_14_WAIT: next_select = go ? S_14_WAIT : S_15;
					 S_15: next_select = go ? S_15_WAIT : S_15; 
					 S_15_WAIT: next_select = go ? S_15_WAIT : S_0;
					 
                default:     next_select = S_0;
        endcase
   end
		  
	always @(*)
        begin: enable_signals
            // By default make all our signals 0
            selections[0] = 1'b0;
				selections[1] = 1'b0;
				selections[2] = 1'b0;
				selections[3] = 1'b0;
				
				selections[4] = 1'b0;
				selections[5] = 1'b0;
				selections[6] = 1'b0;
				selections[7] = 1'b0;
				
				selections[8] = 1'b0;
				selections[9] = 1'b0;
				selections[10] = 1'b0;
				selections[11] = 1'b0;
				
				selections[12] = 1'b0;
				selections[13] = 1'b0;
				selections[14] = 1'b0;
				selections[15] = 1'b0;
		    
		    case(current_select)
		      	S_0:begin
		      		selections[0] = 1'b1;
		      		end
					S_1:begin
		      		selections[1] = 1'b1;
		      		end
					S_2:begin
		      		selections[2] = 1'b1;
		      		end
					S_3:begin
		      		selections[3] = 1'b1;
		      		end
						
					S_4:begin
		      		selections[4] = 1'b1;
		      		end
					S_5:begin
		      		selections[5] = 1'b1;
		      		end
					S_6:begin
		      		selections[6] = 1'b1;
		      		end
					S_7:begin
		      		selections[7] = 1'b1;
		      		end
						
					S_8:begin
		      		selections[8] = 1'b1;
		      		end
					S_9:begin
		      		selections[9] = 1'b1;
		      		end
					S_10:begin
		      		selections[10] = 1'b1;
		      		end
					S_11:begin
		      		selections[11] = 1'b1;
		      		end
						
					S_12:begin
		      		selections[12] = 1'b1;
		      		end
					S_13:begin
		      		selections[13] = 1'b1;
		      		end
					S_14:begin
		      		selections[14] = 1'b1;
		      		end
					S_15:begin
		      		selections[15] = 1'b1;
		      		end
						
		    endcase
	end
   
	
	// current_state registers
    always@(posedge clock)
    begin: state_FFs
        if(!reset_n)
            current_select <= S_0;
        else
            current_select <= next_select;
    end // state_FFS
	
endmodule



module control(reset_n,clock,enable, floor, select, laser, plot);
	
      input reset_n,clock;
		output reg [1:0] enable;
		output reg plot;
		output reg [15:0] floor;
		output reg [15:0] select;
		output reg laser;
		
		reg [7:0] current_state, next_state;

		
	localparam	S_FLOOR_0			= 8'd0,
					S_FLOOR_0_WAIT		= 8'd1,
               S_FLOOR_1      	= 8'd2,
               S_FLOOR_1_WAIT 	= 8'd3,
				   S_FLOOR_2  	      = 8'd4,
               S_FLOOR_2_WAIT   	= 8'd5,
			  	   S_FLOOR_3        	= 8'd6,
               S_FLOOR_3_WAIT   	= 8'd7,
					
					S_FLOOR_4        	= 8'd8,
               S_FLOOR_4_WAIT   	= 8'd9,
					S_FLOOR_5			= 8'd10,
					S_FLOOR_5_WAIT		= 8'd11,
               S_FLOOR_6      	= 8'd12,
               S_FLOOR_6_WAIT 	= 8'd13,
				   S_FLOOR_7  	      = 8'd14,
               S_FLOOR_7_WAIT   	= 8'd15,
					
			  	   S_FLOOR_8        	= 8'd16,
               S_FLOOR_8_WAIT   	= 8'd17,
					S_FLOOR_9        	= 8'd18,
               S_FLOOR_9_WAIT   	= 8'd19,
					S_FLOOR_10      	= 8'd20,
               S_FLOOR_10_WAIT 	= 8'd21,
				   S_FLOOR_11  	   = 8'd22,
               S_FLOOR_11_WAIT  	= 8'd23,
					
					S_FLOOR_12        = 8'd24,
               S_FLOOR_12_WAIT   = 8'd25,
					S_FLOOR_13        = 8'd26,
               S_FLOOR_13_WAIT   = 8'd27,
					S_FLOOR_14      	= 8'd28,
               S_FLOOR_14_WAIT 	= 8'd29,
				   S_FLOOR_15  	   = 8'd30,
               S_FLOOR_15_WAIT  	= 8'd31,
					
					
					S_SELECT_0			= 8'd32,
					S_SELECT_0_WAIT	= 8'd33,
               S_SELECT_1      	= 8'd34,
               S_SELECT_1_WAIT 	= 8'd35,
				   S_SELECT_2  	   = 8'd36,
               S_SELECT_2_WAIT   = 8'd37,
			  	   S_SELECT_3        = 8'd38,
               S_SELECT_3_WAIT   = 8'd39,
					
					S_SELECT_4        = 8'd40,
               S_SELECT_4_WAIT   = 8'd41,
					S_SELECT_5			= 8'd42,
					S_SELECT_5_WAIT	= 8'd43,
               S_SELECT_6      	= 8'd44,
               S_SELECT_6_WAIT 	= 8'd45,
				   S_SELECT_7  	   = 8'd46,
               S_SELECT_7_WAIT   = 8'd47,
					
			  	   S_SELECT_8        = 8'd48,
               S_SELECT_8_WAIT   = 8'd49,
					S_SELECT_9        = 8'd50,
               S_SELECT_9_WAIT   = 8'd51,
					S_SELECT_10      	= 8'd52,
               S_SELECT_10_WAIT 	= 8'd53,
				   S_SELECT_11  	   = 8'd54,
               S_SELECT_11_WAIT  = 8'd55,
					
					S_SELECT_12       = 8'd56,
               S_SELECT_12_WAIT  = 8'd57,
					S_SELECT_13       = 8'd58,
               S_SELECT_13_WAIT  = 8'd59,
					S_SELECT_14      	= 8'd60,
               S_SELECT_14_WAIT 	= 8'd61,
				   S_SELECT_15  	   = 8'd62,
               S_SELECT_15_WAIT  = 8'd63,
					
					S_LASER 				= 8'd64,
					S_LASER_WAIT		= 8'd65;
		
		
		always@(*)
        begin: state_table 
            case (current_state)
                S_FLOOR_0: next_state = S_FLOOR_0_WAIT; 
                S_FLOOR_0_WAIT: next_state = S_FLOOR_1; 
					 S_FLOOR_1: next_state = S_FLOOR_1_WAIT;
					 S_FLOOR_1_WAIT: next_state = S_FLOOR_2;
					 S_FLOOR_2: next_state = S_FLOOR_2_WAIT;
					 S_FLOOR_2_WAIT: next_state = S_FLOOR_3;
					 S_FLOOR_3: next_state = S_FLOOR_3_WAIT;
					 S_FLOOR_3_WAIT: next_state = S_FLOOR_4;
					 
					 S_FLOOR_4: next_state = S_FLOOR_4_WAIT;
					 S_FLOOR_4_WAIT: next_state = S_FLOOR_5;
					 S_FLOOR_5: next_state = S_FLOOR_5_WAIT;
					 S_FLOOR_5_WAIT: next_state = S_FLOOR_6;
					 S_FLOOR_6: next_state = S_FLOOR_6_WAIT;
					 S_FLOOR_6_WAIT: next_state = S_FLOOR_7;
					 S_FLOOR_7: next_state = S_FLOOR_7_WAIT;
					 S_FLOOR_7_WAIT: next_state = S_FLOOR_8;
					 
					 S_FLOOR_8: next_state = S_FLOOR_8_WAIT;
					 S_FLOOR_8_WAIT: next_state = S_FLOOR_9;
					 S_FLOOR_9: next_state = S_FLOOR_9_WAIT;
					 S_FLOOR_9_WAIT: next_state = S_FLOOR_10;
					 S_FLOOR_10: next_state = S_FLOOR_10_WAIT;
					 S_FLOOR_10_WAIT: next_state = S_FLOOR_11;
					 S_FLOOR_11: next_state = S_FLOOR_11_WAIT;
					 S_FLOOR_11_WAIT: next_state = S_FLOOR_12;
					 
					 S_FLOOR_12: next_state = S_FLOOR_12_WAIT;
					 S_FLOOR_12_WAIT: next_state = S_FLOOR_13;
					 S_FLOOR_13: next_state = S_FLOOR_13_WAIT;
					 S_FLOOR_13_WAIT: next_state = S_FLOOR_14;
					 S_FLOOR_14: next_state = S_FLOOR_14_WAIT;
					 S_FLOOR_14_WAIT: next_state = S_FLOOR_15;
					 S_FLOOR_15: next_state = S_FLOOR_15_WAIT;
					 S_FLOOR_15_WAIT: next_state = S_SELECT_0;
					 
					 /////////////////////
					 
					 S_SELECT_0: next_state = S_SELECT_0_WAIT; 
                S_SELECT_0_WAIT: next_state = S_SELECT_1; 
					 S_SELECT_1: next_state = S_SELECT_1_WAIT;
					 S_SELECT_1_WAIT: next_state = S_SELECT_2;
					 S_SELECT_2: next_state = S_SELECT_2_WAIT;
					 S_SELECT_2_WAIT: next_state = S_SELECT_3;
					 S_SELECT_3: next_state = S_SELECT_3_WAIT;
					 S_SELECT_3_WAIT: next_state = S_SELECT_4;
					 
					 S_SELECT_4: next_state = S_SELECT_4_WAIT;
					 S_SELECT_4_WAIT: next_state = S_SELECT_5;
					 S_SELECT_5: next_state = S_SELECT_5_WAIT;
					 S_SELECT_5_WAIT: next_state = S_SELECT_6;
					 S_SELECT_6: next_state = S_SELECT_6_WAIT;
					 S_SELECT_6_WAIT: next_state = S_SELECT_7;
					 S_SELECT_7: next_state = S_SELECT_7_WAIT;
					 S_SELECT_7_WAIT: next_state = S_SELECT_8;
					 
					 S_SELECT_8: next_state = S_SELECT_8_WAIT;
					 S_SELECT_8_WAIT: next_state = S_SELECT_9;
					 S_SELECT_9: next_state = S_SELECT_9_WAIT;
					 S_SELECT_9_WAIT: next_state = S_SELECT_10;
					 S_SELECT_10: next_state = S_SELECT_10_WAIT;
					 S_SELECT_10_WAIT: next_state = S_SELECT_11;
					 S_SELECT_11: next_state = S_SELECT_11_WAIT;
					 S_SELECT_11_WAIT: next_state = S_SELECT_12;
					 
					 S_SELECT_12: next_state = S_SELECT_12_WAIT;
					 S_SELECT_12_WAIT: next_state = S_SELECT_13;
					 S_SELECT_13: next_state = S_SELECT_13_WAIT;
					 S_SELECT_13_WAIT: next_state = S_SELECT_14;
					 S_SELECT_14: next_state = S_SELECT_14_WAIT;
					 S_SELECT_14_WAIT: next_state = S_SELECT_15;
					 S_SELECT_15: next_state = S_SELECT_15_WAIT;
					 S_SELECT_15_WAIT: next_state = S_LASER;
					 
					 S_LASER: next_state = S_LASER_WAIT;
					 S_LASER_WAIT: next_state = S_FLOOR_0;
					 
                default:     next_state = S_FLOOR_0;
        endcase
        end 
		
		always@(*)
        begin: enable_signals
            // By default make all our signals 0
            floor[0] = 1'b0;
				floor[1] = 1'b0;
				floor[2] = 1'b0;
				floor[3] = 1'b0;
				
				floor[4] = 1'b0;
				floor[5] = 1'b0;
				floor[6] = 1'b0;
				floor[7] = 1'b0;
				
				floor[8] = 1'b0;
				floor[9] = 1'b0;
				floor[10] = 1'b0;
				floor[11] = 1'b0;
				
				floor[12] = 1'b0;
				floor[13] = 1'b0;
				floor[14] = 1'b0;
				floor[15] = 1'b0;
				
				select[0] = 1'b0;
				select[1] = 1'b0;
				select[2] = 1'b0;
				select[3] = 1'b0;
				
				select[4] = 1'b0;
				select[5] = 1'b0;
				select[6] = 1'b0;
				select[7] = 1'b0;
				
				select[8] = 1'b0;
				select[9] = 1'b0;
				select[10] = 1'b0;
				select[11] = 1'b0;
				
				select[12] = 1'b0;
				select[13] = 1'b0;
				select[14] = 1'b0;
				select[15] = 1'b0;
				
				laser = 1'b0;
				
	         enable = 2'b00;
		      plot = 1'b0;
		    
		    case(current_state)
		      	S_FLOOR_0:begin
		      		floor[0] = 1'b1;
		      		end
					S_FLOOR_0_WAIT:begin
					   enable = 2'b01;
		      		plot = 1'b1;
						end
					S_FLOOR_1:begin
		      		floor[1] = 1'b1;
		      		end
					S_FLOOR_1_WAIT:begin
					   enable = 2'b01;
		      		plot = 1'b1;
						end
					S_FLOOR_2:begin
		      		floor[2] = 1'b1;
		      		end
					S_FLOOR_2_WAIT:begin
					   enable = 2'b01;
		      		plot = 1'b1;
						end
					S_FLOOR_3:begin
		      		floor[3] = 1'b1;
		      		end
					S_FLOOR_3_WAIT:begin
					   enable = 2'b01;
		      		plot = 1'b1;
						end
						
					S_FLOOR_4:begin
		      		floor[4] = 1'b1;
		      		end
					S_FLOOR_4_WAIT:begin
					   enable = 2'b01;
		      		plot = 1'b1;
						end
					S_FLOOR_5:begin
		      		floor[5] = 1'b1;
		      		end
					S_FLOOR_5_WAIT:begin
					   enable = 2'b01;
		      		plot = 1'b1;
						end
					S_FLOOR_6:begin
		      		floor[6] = 1'b1;
		      		end
					S_FLOOR_6_WAIT:begin
					   enable = 2'b01;
		      		plot = 1'b1;
						end
					S_FLOOR_7:begin
		      		floor[7] = 1'b1;
		      		end
					S_FLOOR_7_WAIT:begin
					   enable = 2'b01;
		      		plot = 1'b1;
						end
						
					S_FLOOR_8:begin
		      		floor[8] = 1'b1;
		      		end
					S_FLOOR_8_WAIT:begin
					   enable = 2'b01;
		      		plot = 1'b1;
						end
					S_FLOOR_9:begin
		      		floor[9] = 1'b1;
		      		end
					S_FLOOR_9_WAIT:begin
					   enable = 2'b01;
		      		plot = 1'b1;
						end
					S_FLOOR_10:begin
		      		floor[10] = 1'b1;
		      		end
					S_FLOOR_10_WAIT:begin
					   enable = 2'b01;
		      		plot = 1'b1;
						end
					S_FLOOR_11:begin
		      		floor[11] = 1'b1;
		      		end
					S_FLOOR_11_WAIT:begin
					   enable = 2'b01;
		      		plot = 1'b1;
						end
						
					S_FLOOR_12:begin
		      		floor[12] = 1'b1;
		      		end
					S_FLOOR_12_WAIT:begin
					   enable = 2'b01;
		      		plot = 1'b1;
						end
					S_FLOOR_13:begin
		      		floor[13] = 1'b1;
		      		end
					S_FLOOR_13_WAIT:begin
					   enable = 2'b01;
		      		plot = 1'b1;
						end
					S_FLOOR_14:begin
		      		floor[14] = 1'b1;
		      		end
					S_FLOOR_14_WAIT:begin
					   enable = 2'b01;
		      		plot = 1'b1;
						end
					S_FLOOR_15:begin
		      		floor[15] = 1'b1;
		      		end
					S_FLOOR_15_WAIT:begin
					   enable = 2'b01;
		      		plot = 1'b1;
						end
						
						
				
					//////////
					
					
					S_SELECT_0:begin
		      		select[0] = 1'b1;
		      		end
					S_SELECT_0_WAIT:begin
					   enable = 2'b10;
		      		plot = 1'b1;
						end
					S_SELECT_1:begin
		      		select[1] = 1'b1;
		      		end
					S_SELECT_1_WAIT:begin
					   enable = 2'b10;
		      		plot = 1'b1;
						end
					S_SELECT_2:begin
		      		select[2] = 1'b1;
		      		end
					S_SELECT_2_WAIT:begin
					   enable = 2'b10;
		      		plot = 1'b1;
						end
					S_SELECT_3:begin
		      		select[3] = 1'b1;
		      		end
					S_SELECT_3_WAIT:begin
					   enable = 2'b10;
		      		plot = 1'b1;
						end
						
					S_SELECT_4:begin
		      		select[4] = 1'b1;
		      		end
					S_SELECT_4_WAIT:begin
					   enable = 2'b10;
		      		plot = 1'b1;
						end
					S_SELECT_5:begin
		      		select[5] = 1'b1;
		      		end
					S_SELECT_5_WAIT:begin
					   enable = 2'b10;
		      		plot = 1'b1;
						end
					S_SELECT_6:begin
		      		select[6] = 1'b1;
		      		end
					S_SELECT_6_WAIT:begin
					   enable = 2'b10;
		      		plot = 1'b1;
						end
					S_SELECT_7:begin
		      		select[7] = 1'b1;
		      		end
					S_SELECT_7_WAIT:begin
					   enable = 2'b10;
		      		plot = 1'b1;
						end
						
					S_SELECT_8:begin
		      		select[8] = 1'b1;
		      		end
					S_SELECT_8_WAIT:begin
					   enable = 2'b10;
		      		plot = 1'b1;
						end
					S_SELECT_9:begin
		      		select[9] = 1'b1;
		      		end
					S_SELECT_9_WAIT:begin
					   enable = 2'b10;
		      		plot = 1'b1;
						end
					S_SELECT_10:begin
		      		select[10] = 1'b1;
		      		end
					S_SELECT_10_WAIT:begin
					   enable = 2'b10;
		      		plot = 1'b1;
						end
					S_SELECT_11:begin
		      		select[11] = 1'b1;
		      		end
					S_SELECT_11_WAIT:begin
					   enable = 2'b10;
		      		plot = 1'b1;
						end
						
					S_SELECT_12:begin
		      		select[12] = 1'b1;
		      		end
					S_SELECT_12_WAIT:begin
					   enable = 2'b10;
		      		plot = 1'b1;
						end
					S_SELECT_13:begin
		      		select[13] = 1'b1;
		      		end
					S_SELECT_13_WAIT:begin
					   enable = 2'b10;
		      		plot = 1'b1;
						end
					S_SELECT_14:begin
		      		select[14] = 1'b1;
		      		end
					S_SELECT_14_WAIT:begin
					   enable = 2'b10;
		      		plot = 1'b1;
						end
					S_SELECT_15:begin
		      		select[15] = 1'b1;
		      		end
					S_SELECT_15_WAIT:begin
					   enable = 2'b10;
		      		plot = 1'b1;
						end
						
					S_LASER:begin
		      		laser = 1'b1;
		      		end
					S_LASER_WAIT:begin
					   enable = 2'b11;
		      		plot = 1'b1;
						end
		    endcase
		end
		
		reg [7:0] clock_counter;
		
		always@(posedge clock)
        begin: state_FFs
            if(!reset_n) begin
                current_state <= S_FLOOR_0;
					 clock_counter <= 8'd250;
				end
            else if (clock_counter == 8'd0) begin
                current_state <= next_state;
					 clock_counter <= 8'd250;
				end
				else
					clock_counter <= clock_counter - 1'd1;
      end
 
endmodule





module datapath(clock, reset_n, enable, floor, floor_value, select, select_value, laser, laser_value, x, y, colour_out);
	input           	reset_n, clock;
	input	[1:0] enable;
	input	[15:0] floor;
	input	[15:0] floor_value;
	
	input	[15:0] select;
	input	[15:0] select_value;
	
	input laser;
	input [27:0] laser_value;

	output reg [7:0] x;
	output reg [6:0] y;
	output reg [2:0]	colour_out;
   reg	[7:0]	regX;
	reg   [6:0] regY;
   reg   [2:0] regC;
	
	
	
	reg [4:0] floor_position_x;
	reg [6:0] floor_position_y;
	wire [7:0] floor_position;
	
	//wire current_draw;
	
	/*
	always @(*) begin
		if (floor[0] || floor[1] || floor[2] || floor[3] || floor[4] || floor[5] || floor[6]  || floor[7] || floor[8] || floor[9]  || floor[10] || floor[11] || floor[12] || floor[13] || floor[14] || floor[15]) begin
			current_draw <= 1'b0;
		end
		else if (select[0] || select[1] || select[2] || select[3] || select[4] || select[5] || select[6]  || select[7] || select[8] || select[9]  || select[10] || select[11] || select[12] || select[13] || floor[14] || select[15]) begin
			current_draw <= 1'b1;		
		end
	end
	*/
	
	
	
	
	counter cnt0(
		.clock(clock),
		.reset_n(reset_n),
		.enable(enable),
		.out(floor_position)
	);
	
	always @(*) begin
		if (enable == 2'b01) begin
			floor_position_x = floor_position[6:2];
			floor_position_y = {5'b00000 , floor_position[1:0]};
		end
		else if (enable == 2'b10) begin
			floor_position_x = floor_position[4:0];
			floor_position_y = {5'b00000 , floor_position[6:5]};
		end
		else if (enable == 2'b11) begin
			floor_position_x = {4'b0000 , floor_position[0:0]};
			floor_position_y = floor_position[7:1];
		end
			
	end
	//assign floor_position_x = floor_position[6:2];
	//assign floor_position_y = floor_position[1:0];
	
	
	always @ (posedge clock) begin
        if (!reset_n) begin
            regX <= 8'd0; 
            regY <= 7'd0;
				regC <= 3'd0;
        end
        else begin
            if (floor[0]) begin
                regX <= 8'd9;
					 regY <= 7'd19;
					 if (floor_value[0] == 0)
						regC <= 3'b111;
					 else
						regC <= 3'b000;
				end
				else if (floor[1]) begin
                regX <= 8'd39;
					 regY <= 7'd19;
					 if (floor_value[1] == 0)
						regC <= 3'b111;
					 else
						regC <= 3'b000;
				end
				else if (floor[2]) begin
                regX <= 8'd69;
					 regY <= 7'd19;
					 if (floor_value[2] == 0)
						regC <= 3'b111;
					 else
						regC <= 3'b000;
				end
				else if (floor[3]) begin
                regX <= 8'd99;
					 regY <= 7'd19;
					 if (floor_value[3] == 0)
						regC <= 3'b111;
					 else
						regC <= 3'b000;
				end
				
				///////////////////////////
				
				else if (floor[4]) begin
                regX <= 8'd129;
					 regY <= 7'd35;
					 if (floor_value[4] == 0)
						regC <= 3'b111;
					 else
						regC <= 3'b000;
				end
				else if (floor[5]) begin
                regX <= 8'd99;
					 regY <= 7'd35;
					 if (floor_value[5] == 0)
						regC <= 3'b111;
					 else
						regC <= 3'b000;
				end
				else if (floor[6]) begin
                regX <= 8'd69;
					 regY <= 7'd35;
					 if (floor_value[6] == 0)
						regC <= 3'b111;
					 else
						regC <= 3'b000;
				end
				else if (floor[7]) begin
                regX <= 8'd39;
					 regY <= 7'd35;
					 if (floor_value[7] == 0)
						regC <= 3'b111;
					 else
						regC <= 3'b000;
				end
				
				///////////////////////////
				
				else if (floor[8]) begin
                regX <= 8'd9;
					 regY <= 7'd51;
					 if (floor_value[8] == 0)
						regC <= 3'b111;
					 else
						regC <= 3'b000;
				end
				else if (floor[9]) begin
                regX <= 8'd39;
					 regY <= 7'd51;
					 if (floor_value[9] == 0)
						regC <= 3'b111;
					 else
						regC <= 3'b000;
				end
				else if (floor[10]) begin
                regX <= 8'd69;
					 regY <= 7'd51;
					 if (floor_value[10] == 0)
						regC <= 3'b111;
					 else
						regC <= 3'b000;
				end
				else if (floor[11]) begin
                regX <= 8'd99;
					 regY <= 7'd51;
					 if (floor_value[11] == 0)
						regC <= 3'b111;
					 else
						regC <= 3'b000;
				end
				///////////////////////////
				
				else if (floor[12]) begin
                regX <= 8'd129;
					 regY <= 7'd67;
					 if (floor_value[12] == 0)
						regC <= 3'b111;
					 else
						regC <= 3'b000;
				end
				else if (floor[13]) begin
                regX <= 8'd99;
					 regY <= 7'd67;
					 if (floor_value[13] == 0)
						regC <= 3'b111;
					 else
						regC <= 3'b000;
				end
				else if (floor[14]) begin
                regX <= 8'd69;
					 regY <= 7'd67;
					 if (floor_value[14] == 0)
						regC <= 3'b111;
					 else
						regC <= 3'b000;
				end
				else if (floor[15]) begin
                regX <= 8'd39;
					 regY <= 7'd67;
					 if (floor_value[15] == 0)
						regC <= 3'b111;
					 else
						regC <= 3'b000;
				end
				
				/////////////////////////////////////////////////
				
				else if (select[0]) begin
                regX <= 8'd9;
					 regY <= 7'd23;
					 if (select_value[0] == 0)
						regC <= 3'b000;
					 else
						regC <= 3'b100;
				end
				else if (select[1]) begin
                regX <= 8'd39;
					 regY <= 7'd23;
					 if (select_value[1] == 0)
						regC <= 3'b000;
					 else
						regC <= 3'b100;
				end
				else if (select[2]) begin
                regX <= 8'd69;
					 regY <= 7'd23;
					 if (select_value[2] == 0)
						regC <= 3'b000;
					 else
						regC <= 3'b100;
				end
				else if (select[3]) begin
                regX <= 8'd99;
					 regY <= 7'd23;
					 if (select_value[3] == 0)
						regC <= 3'b000;
					 else
						regC <= 3'b100;
				end
				
				///////////////////////////
				
				else if (select[4]) begin
                regX <= 8'd129;
					 regY <= 7'd39;
					 if (select_value[4] == 0)
						regC <= 3'b000;
					 else
						regC <= 3'b100;
				end
				else if (select[5]) begin
                regX <= 8'd99;
					 regY <= 7'd39;
					 if (select_value[5] == 0)
						regC <= 3'b000;
					 else
						regC <= 3'b100;
				end
				else if (select[6]) begin
                regX <= 8'd69;
					 regY <= 7'd39;
					 if (select_value[6] == 0)
						regC <= 3'b000;
					 else
						regC <= 3'b100;
				end
				else if (select[7]) begin
                regX <= 8'd39;
					 regY <= 7'd39;
					 if (select_value[7] == 0)
						regC <= 3'b000;
					 else
						regC <= 3'b100;
				end
				
				///////////////////////////
				
				else if (select[8]) begin
                regX <= 8'd9;
					 regY <= 7'd55;
					 if (select_value[8] == 0)
						regC <= 3'b000;
					 else
						regC <= 3'b100;
				end
				else if (select[9]) begin
                regX <= 8'd39;
					 regY <= 7'd55;
					 if (select_value[9] == 0)
						regC <= 3'b000;
					 else
						regC <= 3'b100;
				end
				else if (select[10]) begin
                regX <= 8'd69;
					 regY <= 7'd55;
					 if (select_value[10] == 0)
						regC <= 3'b000;
					 else
						regC <= 3'b100;
				end
				else if (select[11]) begin
                regX <= 8'd99;
					 regY <= 7'd55;
					 if (select_value[11] == 0)
						regC <= 3'b000;
					 else
						regC <= 3'b100;
				end
				///////////////////////////
				
				else if (select[12]) begin
                regX <= 8'd129;
					 regY <= 7'd71;
					 if (select_value[12] == 0)
						regC <= 3'b000;
					 else
						regC <= 3'b100;
				end
				else if (select[13]) begin
                regX <= 8'd99;
					 regY <= 7'd71;
					 if (select_value[13] == 0)
						regC <= 3'b000;
					 else
						regC <= 3'b100;
				end
				else if (select[14]) begin
                regX <= 8'd69;
					 regY <= 7'd71;
					 if (select_value[14] == 0)
						regC <= 3'b000;
					 else
						regC <= 3'b100;
				end
				else if (select[15]) begin
                regX <= 8'd39;
					 regY <= 7'd71;
					 if (select_value[15] == 0)
						regC <= 3'b000;
					 else
						regC <= 3'b100;
				end
				
				else if (laser) begin
                regX <= 8'd78;
					 regY <= 7'd0;
					 if (laser_value > 28'd175000000)
						regC <= 3'b110;
					 else
						regC <= 3'b000;
				end
				
				
        end
    end

    always @ (posedge clock) begin
          if (!reset_n) begin
              x <= 8'd0;
              y <= 7'd0;
              colour_out <= 3'd0;
          end
          else begin
              x <= regX + floor_position_x;
              y <= regY + floor_position_y;
              colour_out <= regC;
          end
    end
	 
	 
	 


endmodule
	

module counter(clock, reset_n, enable, out);
	input 		clock, reset_n;
	input	[1:0] enable;
	output reg [7:0] out;
	
	always @(posedge clock) begin
		if(reset_n == 1'b0)
			out <= 8'd0;
		else if (enable == 2'b01)
		    begin
		    if (out == 8'b010011_11)
			    out <= 8'd0;
		    else
			    out <= out + 1'b1;
		end
		else if (enable == 2'b10)
		    begin
		    if (out == 8'b00010011)
			    out <= 8'd0;
		    else
			    out <= out + 1'b1;
		end
		else if (enable == 2'b11)
		    begin
		    if (out >= 8'b1100100_0)
			    out <= 8'd0;
		    else
			    out <= out + 1'b1;
		end
   end
	
endmodule









/*
module try(coordinate,colour_in,reset_n,clock,go,start,X,Y,colour_out);
		input [6:0] coordinate;
		input [2:0] colour_in;
		input reset_n,clock,go,start;
		output[6:0] X,Y;
		output[2:0] colour_out;
		
		wire enable,ld_x,ld_y,ld_c,plot;
		
		control m1(go,reset_n,start,clock,enable,ld_x,ld_y,ld_c,plot);
		datapath m2(coordinate,colour_in,clock,reset_n,enable,ld_x,ld_y,ld_c,X,Y,colour_out);
endmodule
*/

