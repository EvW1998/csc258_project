module saveyourta
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
        KEY,
        SW,
		  HEX0,
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
	output [6:0] HEX0;

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
    wire [2:0] enable;
	 wire one_second;
	 wire four_second;
	 wire six_second;
	 wire eight_second;
	 wire nine_second;
	 wire [15:0] floor;
	 wire [15:0] floor_value;
	 wire [15:0] select;
	 wire [15:0] select_value;
	 wire laser;
	 wire [27:0] laser_value;
	 
	 wire monster1;
	 wire [20:0] monster1_value;
	 wire monster1_pre;
	 wire [20:0] monster1_pre_value;
	 wire [1:0] monster1_active;
	 
	 wire monster2;
	 wire [20:0] monster2_value;
	 wire monster2_pre;
	 wire [20:0] monster2_pre_value;
	 wire [2:0] monster2_active;
	 
	 wire monster3;
	 wire [20:0] monster3_value;
	 wire monster3_pre;
	 wire [20:0] monster3_pre_value;
	 wire [2:0] monster3_active;
	 
	 wire monster4;
	 wire [20:0] monster4_value;
	 wire monster4_pre;
	 wire [20:0] monster4_pre_value;
	 wire [2:0] monster4_active;
	 
	 wire monster5;
	 wire [20:0] monster5_value;
	 wire monster5_pre;
	 wire [20:0] monster5_pre_value;
	 wire [2:0] monster5_active;

	 
	 wire [3:0] score;
	 
	 wire [20:0] m;
	 wire [20:0] m_value;
	 wire [1:0] m_active;
	 
	 
	/*
	 always @(*) begin
		 m_value[0] = 1'b1;
		 m_value[1] = 1'b0;
		 m_value[2] = 1'b1;
		 m_value[3] = 1'b0;
	 end
	*/
	
    // Instansiate datapath
	// datapath d0(...);
	
	rateDivider r1(1'b1, 29'd49999999, CLOCK_50, KEY[0], one_second);
	//rateDivider r2(1'b1, 29'd199999999, CLOCK_50, KEY[0], four_second);
	//rateDivider r3(1'b1, 29'd299999999, CLOCK_50, KEY[0], six_second);
	//rateDivider r4(1'b1, 29'd399999999, CLOCK_50, KEY[0], eight_second);
	//rateDivider r5(1'b1, 29'd449999999, CLOCK_50, KEY[0], nine_second);
	
	//monster_manage mm1(CLOCK_50, m_active[1:0], KEY[0], m_value[20:0]);
	//monster_manage mm2(four_second, monster2_active[2:0], KEY[0]);
	//monster_manage mm3(six_second, monster3_active[2:0], KEY[0]);
	//monster_manage mm4(eight_second, monster4_active[2:0], KEY[0]);
	//monster_manage mm5(nine_second, monster5_active[2:0], KEY[0]);
	
	monster_control mc1(one_second, m_value[20:0], floor_value[15:0], m_active[1:0], 1'b0);
	//monster_control mc2(one_second, monster2_value[20:0], monster2_pre_value[20:0], floor_value[15:0], monster2_active[2:0], 1'b1);
	//monster_control mc3(one_second, monster3_value[20:0], monster3_pre_value[20:0], floor_value[15:0], monster3_active[2:0], 1'b0);
	//monster_control mc4(one_second, monster4_value[20:0], monster4_pre_value[20:0], floor_value[15:0], monster4_active[2:0], 1'b1);
	//monster_control mc5(one_second, monster5_value[20:0], monster5_pre_value[20:0], floor_value[15:0], monster5_active[2:0], 1'b0);
	
	select_control sc1(~KEY[3], KEY[0], CLOCK_50, select_value[15:0]);

	floor_control fc1(~KEY[2], KEY[0], select_value[15:0], floor_value[15:0]);
	
	laser_control lc1(~KEY[1], KEY[0], CLOCK_50, laser_value[27:0], score, m_value[20:0], monster1_active[1:0], monster2_value[20:0], monster2_active[2:0], monster3_value[20:0], monster3_active[2:0], monster4_value[20:0], monster4_active[2:0], monster5_value[20:0], monster5_active[2:0]);
	
   datapath d0(CLOCK_50,KEY[0], enable[2:0], floor[15:0], floor_value[15:0], select[15:0], select_value[15:0], laser, laser_value[27:0], m[20:0], m_value[20:0], x, y, colour);
	
    // Instansiate FSM control
    // control c0(...);
   control c0(KEY[0],CLOCK_50,enable[2:0], floor[15:0], select[15:0], laser, m[20:0], writeEn); 
	
	hex_decoder H0(
        .hex_digit(score[1:0]), 
        .segments(HEX0)
        );
	
endmodule




module rateDivider(input enable, input[28:0] d,
                   input clock, input reset_n, output o);
	  reg[28:0] q;
	  always@(posedge clock)
	  begin
		  if(enable == 1'b1) // decrement q only when enable is 1
		    begin
			    if(q == 0)
				    q <= d;
			    else
				    q <= q - 1'b1; // decrement q
		    end
	  end

    assign o = (q == 0)? 1 : 0;
endmodule

module monster_manage(clock, monster1_active, reset_n, monster_value);
	input clock;
	input reset_n;
	output reg [1:0] monster1_active;
	output reg [20:0] monster_value;
	
	always @(posedge clock) begin
		/*
		if (reset_n == 1'b0) begin
			monster1_active <= 2'b00;

		end
		*/
		if (monster1_active == 2'b00) begin
			monster1_active <= 2'b01;
			monster_value <= 21'b0_00000_00000_00000_00001;
		end
	end
endmodule

module monster_control(clock, monster1_value, floor_value, monster1_active, start_position);
	input clock, start_position;
	input [15:0] floor_value;
	output reg [20:0] monster1_value;
	output reg [1:0] monster1_active;
	
	reg m_v;
	
	always @(posedge clock) begin
		//monster1_active <= 2'b01;
		
		if (monster1_active == 2'b00) begin
			if (monster1_value == 21'd0)
				monster1_value <= 21'b0_00000_00000_00000_00001;
			else if (monster1_value[0] == 1'b1 && floor_value[0] == 1'b1) begin
				monster1_value <= 21'b0_00000_00000_10000_00000;
			end
			else if (monster1_value[1] == 1'b1 && floor_value[1] == 1'b1) begin
				monster1_value <= 21'b0_00000_00000_01000_00000;
			end
			else if (monster1_value[2] == 1'b1 && floor_value[2] == 1'b1) begin
				monster1_value <= 21'b0_00000_00000_00100_00000;
			end
			else if (monster1_value[3] == 1'b1 && floor_value[3] == 1'b1) begin
				monster1_value <= 21'b0_00000_00000_00010_00000;
			end
			////
			else if (monster1_value[5] == 1'b1 && floor_value[4] == 1'b1) begin
				monster1_value <= 21'b0_00000_10000_00000_00000;
			end
			else if (monster1_value[6] == 1'b1 && floor_value[5] == 1'b1) begin
				monster1_value <= 21'b0_00000_01000_00000_00000;
			end
			else if (monster1_value[7] == 1'b1 && floor_value[6] == 1'b1) begin
				monster1_value <= 21'b0_00000_00100_00000_00000;
			end
			else if (monster1_value[8] == 1'b1 && floor_value[7] == 1'b1) begin
				monster1_value <= 21'b0_00000_00010_00000_00000;
			end
			////
			else if (monster1_value[10] == 1'b1 && floor_value[8] == 1'b1) begin
				monster1_value <= 21'b0_10000_00000_00000_00000;
			end
			else if (monster1_value[11] == 1'b1 && floor_value[9] == 1'b1) begin
				monster1_value <= 21'b0_01000_00000_00000_00000;
			end
			else if (monster1_value[12] == 1'b1 && floor_value[10] == 1'b1) begin
				monster1_value <= 21'b0_00100_00000_00000_00000;
			end
			else if (monster1_value[13] == 1'b1 && floor_value[11] == 1'b1) begin
				monster1_value <= 21'b0_00010_00000_00000_00000;
			end
			////
			else if (monster1_value[15] == 1'b1 && floor_value[12] == 1'b1) begin
				monster1_value <= 21'b1_00000_00000_00000_00000;
			end
			else if (monster1_value[16] == 1'b1 && floor_value[13] == 1'b1) begin
				monster1_value <= 21'b1_00000_00000_00000_00000;
			end
			else if (monster1_value[17] == 1'b1 && floor_value[14] == 1'b1) begin
				monster1_value <= 21'b1_00000_00000_00000_00000;
			end
			else if (monster1_value[18] == 1'b1 && floor_value[15] == 1'b1) begin
				monster1_value <= 21'b1_00000_00000_00000_00000;
			end
			////
			else if (monster1_value[20] == 1'b1) begin
				//monster1_active <= 2'b10;
				monster1_value <= 21'b0_00000_00000_00000_00000;
			end
			
			else
				monster1_value <= monster1_value << 1'b1;
		end

		
		//if (monster1_active == 2'b01) begin
			/*
			if (monster1_value == 21'd0) begin
				if (start_position == 1'b0)
					monster1_value <= 21'b0_00000_00000_00000_00001;
				else
					monster1_value <= 21'b0_00000_00000_00001_00000;
			end
			else if (monster1_value[0] == 1'b1 && floor_value[0] == 1'b1) begin
				monster1_value <= 21'b0_00000_00000_10000_00000;
			end
			else if (monster1_value[1] == 1'b1 && floor_value[1] == 1'b1) begin
				monster1_value <= 21'b0_00000_00000_01000_00000;
			end
			else if (monster1_value[2] == 1'b1 && floor_value[2] == 1'b1) begin
				monster1_value <= 21'b0_00000_00000_00100_00000;
			end
			else if (monster1_value[3] == 1'b1 && floor_value[3] == 1'b1) begin
				monster1_value <= 21'b0_00000_00000_00010_00000;
			end
			////
			else if (monster1_value[5] == 1'b1 && floor_value[4] == 1'b1) begin
				monster1_value <= 21'b0_00000_10000_00000_00000;
			end
			else if (monster1_value[6] == 1'b1 && floor_value[5] == 1'b1) begin
				monster1_value <= 21'b0_00000_01000_00000_00000;
			end
			else if (monster1_value[7] == 1'b1 && floor_value[6] == 1'b1) begin
				monster1_value <= 21'b0_00000_00100_00000_00000;
			end
			else if (monster1_value[8] == 1'b1 && floor_value[7] == 1'b1) begin
				monster1_value <= 21'b0_00000_00010_00000_00000;
			end
			////
			else if (monster1_value[10] == 1'b1 && floor_value[8] == 1'b1) begin
				monster1_value <= 21'b0_10000_00000_00000_00000;
			end
			else if (monster1_value[11] == 1'b1 && floor_value[9] == 1'b1) begin
				monster1_value <= 21'b0_01000_00000_00000_00000;
			end
			else if (monster1_value[12] == 1'b1 && floor_value[10] == 1'b1) begin
				monster1_value <= 21'b0_00100_00000_00000_00000;
			end
			else if (monster1_value[13] == 1'b1 && floor_value[11] == 1'b1) begin
				monster1_value <= 21'b0_00010_00000_00000_00000;
			end
			////
			else if (monster1_value[15] == 1'b1 && floor_value[12] == 1'b1) begin
				monster1_value <= 21'b1_00000_00000_00000_00000;
			end
			else if (monster1_value[16] == 1'b1 && floor_value[13] == 1'b1) begin
				monster1_value <= 21'b1_00000_00000_00000_00000;
			end
			else if (monster1_value[17] == 1'b1 && floor_value[14] == 1'b1) begin
				monster1_value <= 21'b1_00000_00000_00000_00000;
			end
			else if (monster1_value[18] == 1'b1 && floor_value[15] == 1'b1) begin
				monster1_value <= 21'b1_00000_00000_00000_00000;
			end
			////
			else if (monster1_value[20] == 1'b1) begin
				monster1_active <= 2'b10;
				monster1_value <= 21'b0_00000_00000_00000_00000;
			end
			else begin
				monster1_value <= monster1_value << 1'b1;
			end
			*/
		//end
		//else begin
			//monster1_value <= 21'b0_00000_00000_00000_00000;
		//end
	end
endmodule


module laser_control(shoot, reset_n, clock, laser_value, score, monster1_value, monster1_active, monster2_value, monster2_active, monster3_value, monster3_active, monster4_value, monster4_active, monster5_value, monster5_active);
	input shoot, reset_n, clock;
	output reg [27:0] laser_value;
	output reg [3:0] score;
	input [20:0] monster1_value;
	output reg [1:0] monster1_active;
	input [20:0] monster2_value;
	output reg [2:0] monster2_active;
	input [20:0] monster3_value;
	output reg [2:0] monster3_active;
	input [20:0] monster4_value;
	output reg [2:0] monster4_active;
	input [20:0] monster5_value;
	output reg [2:0] monster5_active;
	
	always @(posedge clock, negedge reset_n) begin
		if (reset_n == 1'b0) begin
			laser_value <= 25'd0;
			score <= 4'd0;
		end
		else if (laser_value > 25'd0) begin
			laser_value <= laser_value - 1'd1;
		end
		else if (shoot) begin
			laser_value <= 28'd1_9999_9999;
			if (monster1_value[2] == 1'b1 || monster1_value[7] == 1'b1 || monster1_value[12] == 1'b1 || monster1_value[17] == 1'b1) begin
				score <= score + 1'b1;
				monster1_active <= 2'b10;
			end
			if (monster2_value[2] == 1'b1 || monster2_value[7] == 1'b1 || monster2_value[12] == 1'b1 || monster2_value[17] == 1'b1) begin
				score <= score + 1'b1;
				monster2_active <= 2'b10;
			end
			if (monster3_value[2] == 1'b1 || monster3_value[7] == 1'b1 || monster3_value[12] == 1'b1 || monster3_value[17] == 1'b1) begin
				score <= score + 1'b1;
				monster3_active <= 2'b10;
			end
			if (monster4_value[2] == 1'b1 || monster4_value[7] == 1'b1 || monster4_value[12] == 1'b1 || monster4_value[17] == 1'b1) begin
				score <= score + 1'b1;
				monster4_active <= 2'b10;
			end
			if (monster5_value[2] == 1'b1 || monster5_value[7] == 1'b1 || monster5_value[12] == 1'b1 || monster5_value[17] == 1'b1) begin
				score <= score + 1'b1;
				monster5_active <= 2'b10;
			end
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



module control(reset_n,clock,enable, floor, select, laser, monster, plot);
	
      input reset_n,clock;
		output reg [2:0] enable;
		output reg plot;
		output reg [15:0] floor;
		output reg [15:0] select;
		output reg laser;
		output reg [20:0] monster;
		
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
					S_LASER_WAIT		= 8'd65,
					
					S_MONSTER_0			= 8'd66,
					S_MONSTER_0_WAIT 	= 8'd67,
					S_MONSTER_1			= 8'd68,
					S_MONSTER_1_WAIT 	= 8'd69,
					S_MONSTER_2			= 8'd71,
					S_MONSTER_2_WAIT 	= 8'd72,				
					S_MONSTER_3			= 8'd73,
					S_MONSTER_3_WAIT 	= 8'd74,				
					S_MONSTER_4			= 8'd75,
					S_MONSTER_4_WAIT 	= 8'd76,
					
					S_MONSTER_5			= 8'd77,
					S_MONSTER_5_WAIT 	= 8'd78,
					S_MONSTER_6			= 8'd79,
					S_MONSTER_6_WAIT 	= 8'd80,
					S_MONSTER_7			= 8'd81,
					S_MONSTER_7_WAIT 	= 8'd82,	
					S_MONSTER_8			= 8'd83,
					S_MONSTER_8_WAIT 	= 8'd84,				
					S_MONSTER_9			= 8'd85,
					S_MONSTER_9_WAIT 	= 8'd86,
					
					S_MONSTER_10		= 8'd87,
					S_MONSTER_10_WAIT 	= 8'd88,
					S_MONSTER_11			= 8'd89,
					S_MONSTER_11_WAIT 	= 8'd90,
					S_MONSTER_12			= 8'd91,
					S_MONSTER_12_WAIT 	= 8'd92,	
					S_MONSTER_13			= 8'd93,
					S_MONSTER_13_WAIT 	= 8'd94,				
					S_MONSTER_14			= 8'd95,
					S_MONSTER_14_WAIT 	= 8'd96,
					
					S_MONSTER_15		= 8'd97,
					S_MONSTER_15_WAIT 	= 8'd98,
					S_MONSTER_16			= 8'd99,
					S_MONSTER_16_WAIT 	= 8'd100,
					S_MONSTER_17			= 8'd101,
					S_MONSTER_17_WAIT 	= 8'd102,	
					S_MONSTER_18			= 8'd103,
					S_MONSTER_18_WAIT 	= 8'd104,				
					S_MONSTER_19			= 8'd105,
					S_MONSTER_19_WAIT 	= 8'd106,
					
					S_MONSTER_20			= 8'd107,
					S_MONSTER_20_WAIT 	= 8'd108;
		
		
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
					 S_LASER_WAIT: next_state = S_MONSTER_0;
					 
					 
					 S_MONSTER_0: next_state = S_MONSTER_0_WAIT;
					S_MONSTER_0_WAIT: next_state = S_MONSTER_1;
					S_MONSTER_1: next_state = S_MONSTER_1_WAIT;
					S_MONSTER_1_WAIT: next_state = S_MONSTER_2;
					S_MONSTER_2: next_state = S_MONSTER_2_WAIT;
					S_MONSTER_2_WAIT: next_state = S_MONSTER_3;
					S_MONSTER_3: next_state = S_MONSTER_3_WAIT;
					S_MONSTER_3_WAIT: next_state = S_MONSTER_4;				
					S_MONSTER_4: next_state = S_MONSTER_4_WAIT;
					S_MONSTER_4_WAIT: next_state = S_MONSTER_5;		
					
					S_MONSTER_5: next_state = S_MONSTER_5_WAIT;
					S_MONSTER_5_WAIT: next_state = S_MONSTER_6;
					S_MONSTER_6: next_state = S_MONSTER_6_WAIT;
					S_MONSTER_6_WAIT: next_state = S_MONSTER_7;
					S_MONSTER_7: next_state = S_MONSTER_7_WAIT;
					S_MONSTER_7_WAIT: next_state = S_MONSTER_8;
					S_MONSTER_8: next_state = S_MONSTER_8_WAIT;
					S_MONSTER_8_WAIT: next_state = S_MONSTER_9;				
					S_MONSTER_9: next_state = S_MONSTER_9_WAIT;
					S_MONSTER_9_WAIT: next_state = S_MONSTER_10;	
					
					S_MONSTER_10: next_state = S_MONSTER_10_WAIT;
					S_MONSTER_10_WAIT: next_state = S_MONSTER_11;
					S_MONSTER_11: next_state = S_MONSTER_11_WAIT;
					S_MONSTER_11_WAIT: next_state = S_MONSTER_12;
					S_MONSTER_12: next_state = S_MONSTER_12_WAIT;
					S_MONSTER_12_WAIT: next_state = S_MONSTER_13;
					S_MONSTER_13: next_state = S_MONSTER_13_WAIT;
					S_MONSTER_13_WAIT: next_state = S_MONSTER_14;				
					S_MONSTER_14: next_state = S_MONSTER_14_WAIT;
					S_MONSTER_14_WAIT: next_state = S_MONSTER_15;	
					
					S_MONSTER_15: next_state = S_MONSTER_15_WAIT;
					S_MONSTER_15_WAIT: next_state = S_MONSTER_16;
					S_MONSTER_16: next_state = S_MONSTER_16_WAIT;
					S_MONSTER_16_WAIT: next_state = S_MONSTER_17;
					S_MONSTER_17: next_state = S_MONSTER_17_WAIT;
					S_MONSTER_17_WAIT: next_state = S_MONSTER_18;
					S_MONSTER_18: next_state = S_MONSTER_18_WAIT;
					S_MONSTER_18_WAIT: next_state = S_MONSTER_19;				
					S_MONSTER_19: next_state = S_MONSTER_19_WAIT;
					S_MONSTER_19_WAIT: next_state = S_MONSTER_20;	
					
					S_MONSTER_20: next_state = S_MONSTER_20_WAIT;
					S_MONSTER_20_WAIT: next_state = S_FLOOR_0;	
					 
					 
					 
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
				
				
				monster[0] = 1'b0;
				monster[1] = 1'b0;
				monster[2] = 1'b0;
				monster[3] = 1'b0;
				
				monster[4] = 1'b0;
				monster[5] = 1'b0;
				monster[6] = 1'b0;
				monster[7] = 1'b0;
				
				monster[8] = 1'b0;
				monster[9] = 1'b0;
				monster[10] = 1'b0;
				monster[11] = 1'b0;
				
				monster[12] = 1'b0;
				monster[13] = 1'b0;
				monster[14] = 1'b0;
				monster[15] = 1'b0;
				
				monster[16] = 1'b0;
				monster[17] = 1'b0;
				
				monster[18] = 1'b0;
				monster[19] = 1'b0;
				monster[20] = 1'b0;
				
	         enable = 3'b000;
		      plot = 1'b0;
		    
		    case(current_state)
		      	S_FLOOR_0:begin
		      		floor[0] = 1'b1;
		      		end
					S_FLOOR_0_WAIT:begin
					   enable = 3'b001;
		      		plot = 1'b1;
						end
					S_FLOOR_1:begin
		      		floor[1] = 1'b1;
		      		end
					S_FLOOR_1_WAIT:begin
					   enable = 3'b001;
		      		plot = 1'b1;
						end
					S_FLOOR_2:begin
		      		floor[2] = 1'b1;
		      		end
					S_FLOOR_2_WAIT:begin
					   enable = 3'b001;
		      		plot = 1'b1;
						end
					S_FLOOR_3:begin
		      		floor[3] = 1'b1;
		      		end
					S_FLOOR_3_WAIT:begin
					   enable = 3'b001;
		      		plot = 1'b1;
						end
						
					S_FLOOR_4:begin
		      		floor[4] = 1'b1;
		      		end
					S_FLOOR_4_WAIT:begin
					   enable = 3'b001;
		      		plot = 1'b1;
						end
					S_FLOOR_5:begin
		      		floor[5] = 1'b1;
		      		end
					S_FLOOR_5_WAIT:begin
					   enable = 3'b001;
		      		plot = 1'b1;
						end
					S_FLOOR_6:begin
		      		floor[6] = 1'b1;
		      		end
					S_FLOOR_6_WAIT:begin
					   enable = 3'b001;
		      		plot = 1'b1;
						end
					S_FLOOR_7:begin
		      		floor[7] = 1'b1;
		      		end
					S_FLOOR_7_WAIT:begin
					   enable = 3'b001;
		      		plot = 1'b1;
						end
						
					S_FLOOR_8:begin
		      		floor[8] = 1'b1;
		      		end
					S_FLOOR_8_WAIT:begin
					   enable = 3'b001;
		      		plot = 1'b1;
						end
					S_FLOOR_9:begin
		      		floor[9] = 1'b1;
		      		end
					S_FLOOR_9_WAIT:begin
					   enable = 3'b001;
		      		plot = 1'b1;
						end
					S_FLOOR_10:begin
		      		floor[10] = 1'b1;
		      		end
					S_FLOOR_10_WAIT:begin
					   enable = 3'b001;
		      		plot = 1'b1;
						end
					S_FLOOR_11:begin
		      		floor[11] = 1'b1;
		      		end
					S_FLOOR_11_WAIT:begin
					   enable = 3'b001;
		      		plot = 1'b1;
						end
						
					S_FLOOR_12:begin
		      		floor[12] = 1'b1;
		      		end
					S_FLOOR_12_WAIT:begin
					   enable = 3'b001;
		      		plot = 1'b1;
						end
					S_FLOOR_13:begin
		      		floor[13] = 1'b1;
		      		end
					S_FLOOR_13_WAIT:begin
					   enable = 3'b001;
		      		plot = 1'b1;
						end
					S_FLOOR_14:begin
		      		floor[14] = 1'b1;
		      		end
					S_FLOOR_14_WAIT:begin
					   enable = 3'b001;
		      		plot = 1'b1;
						end
					S_FLOOR_15:begin
		      		floor[15] = 1'b1;
		      		end
					S_FLOOR_15_WAIT:begin
					   enable = 3'b001;
		      		plot = 1'b1;
						end
						
						
				
					//////////
					
					
					S_SELECT_0:begin
		      		select[0] = 1'b1;
		      		end
					S_SELECT_0_WAIT:begin
					   enable = 3'b010;
		      		plot = 1'b1;
						end
					S_SELECT_1:begin
		      		select[1] = 1'b1;
		      		end
					S_SELECT_1_WAIT:begin
					   enable = 3'b010;
		      		plot = 1'b1;
						end
					S_SELECT_2:begin
		      		select[2] = 1'b1;
		      		end
					S_SELECT_2_WAIT:begin
					   enable = 3'b010;
		      		plot = 1'b1;
						end
					S_SELECT_3:begin
		      		select[3] = 1'b1;
		      		end
					S_SELECT_3_WAIT:begin
					   enable = 3'b010;
		      		plot = 1'b1;
						end
						
					S_SELECT_4:begin
		      		select[4] = 1'b1;
		      		end
					S_SELECT_4_WAIT:begin
					   enable = 3'b010;
		      		plot = 1'b1;
						end
					S_SELECT_5:begin
		      		select[5] = 1'b1;
		      		end
					S_SELECT_5_WAIT:begin
					   enable = 3'b010;
		      		plot = 1'b1;
						end
					S_SELECT_6:begin
		      		select[6] = 1'b1;
		      		end
					S_SELECT_6_WAIT:begin
					   enable = 3'b010;
		      		plot = 1'b1;
						end
					S_SELECT_7:begin
		      		select[7] = 1'b1;
		      		end
					S_SELECT_7_WAIT:begin
					   enable = 3'b010;
		      		plot = 1'b1;
						end
						
					S_SELECT_8:begin
		      		select[8] = 1'b1;
		      		end
					S_SELECT_8_WAIT:begin
					   enable = 3'b010;
		      		plot = 1'b1;
						end
					S_SELECT_9:begin
		      		select[9] = 1'b1;
		      		end
					S_SELECT_9_WAIT:begin
					   enable = 3'b010;
		      		plot = 1'b1;
						end
					S_SELECT_10:begin
		      		select[10] = 1'b1;
		      		end
					S_SELECT_10_WAIT:begin
					   enable = 3'b010;
		      		plot = 1'b1;
						end
					S_SELECT_11:begin
		      		select[11] = 1'b1;
		      		end
					S_SELECT_11_WAIT:begin
					   enable = 3'b010;
		      		plot = 1'b1;
						end
						
					S_SELECT_12:begin
		      		select[12] = 1'b1;
		      		end
					S_SELECT_12_WAIT:begin
					   enable = 3'b010;
		      		plot = 1'b1;
						end
					S_SELECT_13:begin
		      		select[13] = 1'b1;
		      		end
					S_SELECT_13_WAIT:begin
					   enable = 3'b010;
		      		plot = 1'b1;
						end
					S_SELECT_14:begin
		      		select[14] = 1'b1;
		      		end
					S_SELECT_14_WAIT:begin
					   enable = 3'b010;
		      		plot = 1'b1;
						end
					S_SELECT_15:begin
		      		select[15] = 1'b1;
		      		end
					S_SELECT_15_WAIT:begin
					   enable = 3'b010;
		      		plot = 1'b1;
						end
						
					S_LASER:begin
		      		laser = 1'b1;
		      		end
					S_LASER_WAIT:begin
					   enable = 3'b011;
		      		plot = 1'b1;
						end
						
						
					///monster
					S_MONSTER_0:begin
		      		monster[0] = 1'b1;
		      		end
					S_MONSTER_0_WAIT:begin
					   enable = 3'b100;
		      		plot = 1'b1;
						end
					S_MONSTER_1:begin
		      		monster[1] = 1'b1;
		      		end
					S_MONSTER_1_WAIT:begin
					   enable = 3'b100;
		      		plot = 1'b1;
						end
					S_MONSTER_2:begin
		      		monster[2] = 1'b1;
		      		end
					S_MONSTER_2_WAIT:begin
					   enable = 3'b100;
		      		plot = 1'b1;
						end
					S_MONSTER_3:begin
		      		monster[3] = 1'b1;
		      		end
					S_MONSTER_3_WAIT:begin
					   enable = 3'b100;
		      		plot = 1'b1;
						end
						
					S_MONSTER_4:begin
		      		monster[4] = 1'b1;
		      		end
					S_MONSTER_4_WAIT:begin
					   enable = 3'b100;
		      		plot = 1'b1;
						end
					S_MONSTER_5:begin
		      		monster[5] = 1'b1;
		      		end
					S_MONSTER_5_WAIT:begin
					   enable = 3'b100;
		      		plot = 1'b1;
						end
					S_MONSTER_6:begin
		      		monster[6] = 1'b1;
		      		end
					S_MONSTER_6_WAIT:begin
					   enable = 3'b100;
		      		plot = 1'b1;
						end
					S_MONSTER_7:begin
		      		monster[7] = 1'b1;
		      		end
					S_MONSTER_7_WAIT:begin
					   enable = 3'b100;
		      		plot = 1'b1;
						end
						
					S_MONSTER_8:begin
		      		monster[8] = 1'b1;
		      		end
					S_MONSTER_8_WAIT:begin
					   enable = 3'b100;
		      		plot = 1'b1;
						end
					S_MONSTER_9:begin
		      		monster[9] = 1'b1;
		      		end
					S_MONSTER_9_WAIT:begin
					   enable = 3'b100;
		      		plot = 1'b1;
						end
					S_MONSTER_10:begin
		      		monster[10] = 1'b1;
		      		end
					S_MONSTER_10_WAIT:begin
					   enable = 3'b100;
		      		plot = 1'b1;
						end
					S_MONSTER_11:begin
		      		monster[11] = 1'b1;
		      		end
					S_MONSTER_11_WAIT:begin
					   enable = 3'b100;
		      		plot = 1'b1;
						end
						
					S_MONSTER_12:begin
		      		monster[12] = 1'b1;
		      		end
					S_MONSTER_12_WAIT:begin
					   enable = 3'b100;
		      		plot = 1'b1;
						end
					S_MONSTER_13:begin
		      		monster[13] = 1'b1;
		      		end
					S_MONSTER_13_WAIT:begin
					   enable = 3'b100;
		      		plot = 1'b1;
						end
					S_MONSTER_14:begin
		      		monster[14] = 1'b1;
		      		end
					S_MONSTER_14_WAIT:begin
					   enable = 3'b100;
		      		plot = 1'b1;
						end
					S_MONSTER_15:begin
		      		monster[15] = 1'b1;
		      		end
					S_MONSTER_15_WAIT:begin
					   enable = 3'b100;
		      		plot = 1'b1;
						end
						
					S_MONSTER_16:begin
		      		monster[16] = 1'b1;
		      		end
					S_MONSTER_16_WAIT:begin
					   enable = 3'b100;
		      		plot = 1'b1;
						end
						
					S_MONSTER_17:begin
		      		monster[17] = 1'b1;
		      		end
					S_MONSTER_17_WAIT:begin
					   enable = 3'b100;
		      		plot = 1'b1;
						end
					S_MONSTER_18:begin
		      		monster[18] = 1'b1;
		      		end
					S_MONSTER_18_WAIT:begin
					   enable = 3'b100;
		      		plot = 1'b1;
						end
					S_MONSTER_19:begin
		      		monster[19] = 1'b1;
		      		end
					S_MONSTER_19_WAIT:begin
					   enable = 3'b100;
		      		plot = 1'b1;
						end
					S_MONSTER_20:begin
		      		monster[20] = 1'b1;
		      		end
					S_MONSTER_20_WAIT:begin
					   enable = 3'b100;
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




module datapath(clock, reset_n, enable, floor, floor_value, select, select_value, laser, laser_value, monster, monster_value, x, y, colour_out);
	input           	reset_n, clock;
	input	[2:0] enable;
	input	[15:0] floor;
	input	[15:0] floor_value;
	
	input	[15:0] select;
	input	[15:0] select_value;
	
	input laser;
	input [27:0] laser_value;
	
	input [20:0] monster;
	input [20:0] monster_value;
	

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
		if (enable == 3'b001) begin
			floor_position_x = floor_position[6:2];
			floor_position_y = {5'b00000 , floor_position[1:0]};
		end
		else if (enable == 3'b010) begin
			floor_position_x = floor_position[4:0];
			floor_position_y = {5'b00000 , floor_position[6:5]};
		end
		else if (enable == 3'b011) begin
			floor_position_x = {4'b0000 , floor_position[0:0]};
			floor_position_y = floor_position[7:1];
		end
		else if (enable == 3'b100) begin
			floor_position_x = floor_position[7:3];
			floor_position_y = {4'b0000 , floor_position[2:0]};
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
				////
				else if (monster[0]) begin
                regX <= 8'd14;
					 regY <= 7'd9;
					 if (monster_value[0] == 0)
						regC <= 3'b000;
					 else
						regC <= 3'b010;
				end
				else if (monster[1]) begin
                regX <= 8'd44;
					 regY <= 7'd9;
					 if (monster_value[1] == 0)
						regC <= 3'b000;
					 else
						regC <= 3'b010;
				end
				else if (monster[2]) begin
                regX <= 8'd74;
					 regY <= 7'd9;
					 if (monster_value[2] == 0)
						regC <= 3'b000;
					 else
						regC <= 3'b010;
				end
				else if (monster[3]) begin
                regX <= 8'd104;
					 regY <= 7'd9;
					 if (monster_value[3] == 0)
						regC <= 3'b000;
					 else
						regC <= 3'b010;
				end
				
				///////////////////////////
				
				else if (monster[4]) begin
                regX <= 8'd134;
					 regY <= 7'd9;
					 if (monster_value[4] == 0)
						regC <= 3'b000;
					 else
						regC <= 3'b010;
				end
				else if (monster[5]) begin
                regX <= 8'd134;
					 regY <= 7'd25;
					 if (monster_value[5] == 0)
						regC <= 3'b000;
					 else
						regC <= 3'b010;
				end
				else if (monster[6]) begin
                regX <= 8'd104;
					 regY <= 7'd25;
					 if (monster_value[6] == 0)
						regC <= 3'b000;
					 else
						regC <= 3'b010;
				end
				else if (monster[7]) begin
                regX <= 8'd74;
					 regY <= 7'd25;
					 if (monster_value[7] == 0)
						regC <= 3'b000;
					 else
						regC <= 3'b010;
				end
				
				///////////////////////////
				
				else if (monster[8]) begin
                regX <= 8'd44;
					 regY <= 7'd25;
					 if (monster_value[8] == 0)
						regC <= 3'b000;
					 else
						regC <= 3'b010;
				end
				else if (monster[9]) begin
                regX <= 8'd14;
					 regY <= 7'd25;
					 if (monster_value[9] == 0)
						regC <= 3'b000;
					 else
						regC <= 3'b010;
				end
				else if (monster[10]) begin
                regX <= 8'd14;
					 regY <= 7'd41;
					 if (monster_value[10] == 0)
						regC <= 3'b000;
					 else
						regC <= 3'b010;
				end
				else if (monster[11]) begin
                regX <= 8'd44;
					 regY <= 7'd41;
					 if (monster_value[11] == 0)
						regC <= 3'b000;
					 else
						regC <= 3'b010;
				end
				///////////////////////////
				
				else if (monster[12]) begin
                regX <= 8'd74;
					 regY <= 7'd41;
					 if (monster_value[12] == 0)
						regC <= 3'b000;
					 else
						regC <= 3'b010;
				end
				else if (monster[13]) begin
                regX <= 8'd104;
					 regY <= 7'd41;
					 if (monster_value[13] == 0)
						regC <= 3'b000;
					 else
						regC <= 3'b010;
				end
				else if (monster[14]) begin
                regX <= 8'd134;
					 regY <= 7'd41;
					 if (monster_value[14] == 0)
						regC <= 3'b000;
					 else
						regC <= 3'b010;
				end
				else if (monster[15]) begin
                regX <= 8'd134;
					 regY <= 7'd57;
					 if (monster_value[15] == 0)
						regC <= 3'b000;
					 else
						regC <= 3'b010;
				end
				
				else if (monster[16]) begin
                regX <= 8'd104;
					 regY <= 7'd57;
					 if (monster_value[16] == 0)
						regC <= 3'b000;
					 else
						regC <= 3'b010;
				end
				else if (monster[17]) begin
                regX <= 8'd74;
					 regY <= 7'd57;
					 if (monster_value[17] == 0)
						regC <= 3'b000;
					 else
						regC <= 3'b010;
				end
				else if (monster[18]) begin
                regX <= 8'd44;
					 regY <= 7'd57;
					 if (monster_value[18] == 0)
						regC <= 3'b000;
					 else
						regC <= 3'b010;
				end
				else if (monster[19]) begin
                regX <= 8'd14;
					 regY <= 7'd57;
					 if (monster_value[19] == 0)
						regC <= 3'b000;
					 else
						regC <= 3'b010;
				end
				else if (monster[20]) begin
                regX <= 8'd14;
					 regY <= 7'd80;
					 if (monster_value[20] == 0)
						regC <= 3'b000;
					 else
						regC <= 3'b010;
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
	input	[2:0] enable;
	output reg [7:0] out;
	
	always @(posedge clock) begin
		if(reset_n == 1'b0)
			out <= 8'd0;
		else if (enable == 3'b001)
		    begin
		    if (out == 8'b010011_11)
			    out <= 8'd0;
		    else
			    out <= out + 1'b1;
		end
		else if (enable == 3'b010)
		    begin
		    if (out == 8'b00010011)
			    out <= 8'd0;
		    else
			    out <= out + 1'b1;
		end
		else if (enable == 3'b011)
		    begin
		    if (out == 8'b1100100_0)
			    out <= 8'd0;
		    else
			    out <= out + 1'b1;
		end
		else if (enable == 3'b100)
		    begin
		    if (out == 8'b01001_111)
			    out <= 8'd0;
			/*
			 else if (out == 8'd0)
				 out <= 8'b00000_010;
			 else if (out == 8'b00000_111)
				 out <= 8'b00001_001;
			 else if (out == 8'b00001_010)
				 out <= 8'b00001_100;
			 else if (out == 8'b00001_110)
				 out <= 8'b00010_000;
			 else if (out == 8'b00010_001)
				 out <= 8'b00010_101;
			 else if (out == 8'b00010_110)
				 out <= 8'b00011_000;
			 else if (out == 8'b00011_010)
				 out <= 8'b00011_100;
			 else if (out == 8'b00110_010)
				 out <= 8'b00110_100;
			 else if (out == 8'b00111_001)
				 out <= 8'b00111_101;
			 else if (out == 8'b00111_110)
				 out <= 8'b01000_001;
			 else if (out == 8'b01000_010)
				 out <= 8'b01000_100;
			 else if (out == 8'b01000_110)
				 out <= 8'b01001_000;
			 else if (out == 8'b01001_000)
				 out <= 8'b01001_010;
			*/
		    else
			    out <= out + 1'b1;
		end
   end
	
endmodule

module hex_decoder(hex_digit, segments);
    input [3:0] hex_digit;
    output reg [6:0] segments;
   
    always @(*)
        case (hex_digit)
            4'h0: segments = 7'b100_0000;
            4'h1: segments = 7'b111_1001;
            4'h2: segments = 7'b010_0100;
            4'h3: segments = 7'b011_0000;
            4'h4: segments = 7'b001_1001;
            4'h5: segments = 7'b001_0010;
            4'h6: segments = 7'b000_0010;
            4'h7: segments = 7'b111_1000;
            4'h8: segments = 7'b000_0000;
            4'h9: segments = 7'b001_1000;
            4'hA: segments = 7'b000_1000;
            4'hB: segments = 7'b000_0011;
            4'hC: segments = 7'b100_0110;
            4'hD: segments = 7'b010_0001;
            4'hE: segments = 7'b000_0110;
            4'hF: segments = 7'b000_1110;   
            default: segments = 7'h7f;
        endcase
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

