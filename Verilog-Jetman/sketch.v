// Etch-and-sketch
// Etch-and-sketch

module sketch
	(
		CLOCK_50,						//	On Board 50 MHz
		KEY,							//	Push Button[3:0]
		SW,								//	DPDT Switch[17:0]
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK,						//	VGA BLANK
		VGA_SYNC,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B,   						//	VGA Blue[9:0]
		LEDR,
		HEX0, HEX1, HEX2, HEX3
	);

	input			CLOCK_50;				//	50 MHz
	input	[3:0]	KEY;					//	Button[3:0]
	input	[17:0]	SW;						//	Switches[0:0]
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK;				//	VGA BLANK
	output			VGA_SYNC;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	output [17:0]LEDR;
	assign LEDR[2] = color1[2];
	assign LEDR[1] = color1[1];
	assign LEDR[0] = color1[0];
	assign LEDR[3] = halfsec;
	wire resetn;
	assign resetn = SW[0];
	wire [8:0] blockleft1, blockright1, blockleft2, blockright2, blockleft3, blockright3, blockleft4, blockright4, blockleft5, blockright5, blockleft6, blockright6, blockleft7, blockright7, blockleft8, blockright8, blockleft9, blockright9, blockleft10, blockright10, blockleft11, blockright11;
	wire [6:0] blockup1, blockdown1, blockup2, blockdown2, blockup3, blockdown3, blockup4, blockdown4, blockup5, blockdown5, blockup6, blockdown6, blockup7, blockdown7, blockup8, blockdown8, blockup9, blockdown9, blockup10, blockdown10, blockup11, blockdown11;
	// block 1
	assign blockleft1 = 160; 	assign blockright1 = 167; assign blockup1 = 50; assign blockdown1 =57;
	// block 2
	assign blockleft2 = 195; 	assign blockright2 = 202; assign blockup2 = 90; assign blockdown2 = 97;
	// block 3
	assign blockleft3 = 225; 	assign blockright3 = 230; assign blockup3 = 70; assign blockdown3 = 75;
	// block 4
	assign blockleft4 = 255; 	assign blockright4 = 262; assign blockup4 = 95; assign blockdown4 = 102;
	// block 5
	assign blockleft5 = 300; 	assign blockright5 = 310; assign blockup5 = 35 ; assign blockdown5 = 45;
	// block 6
	assign blockleft6 = 350; 	assign blockright6 = 355; assign blockup6 = 60; assign blockdown6 = 65;
	// block 7
	assign blockleft7 = 400; 	assign blockright7 = 405; assign blockup7 = 20; assign blockdown7 = 25;
	// block 8
	assign blockleft8 = 440; 	assign blockright8 = 445; assign blockup8 = 70; assign blockdown8 = 75;
	// block 9
	assign blockleft9 = 495; 	assign blockright9 = 500; assign blockup9 = 40; assign blockdown9 = 45;
	// block 10
	assign blockleft10 = 50; 	assign blockright10 = 60; assign blockup10 = 80; assign blockdown10 = 85;
	// block 11
	assign blockleft11 = 90; 	assign blockright11 = 95; assign blockup11=  65; assign blockdown11 = 70;
	
	wire writeEn;
	assign writeEn = 1;
	// Create the color, x, y and writeEn wires that are inputs to the controller.

	wire [2:0] color;
	reg [2:0] color1;
	wire [2:0] colorObj;
	wire [2:0] colorback;

	// assigns the color of the output to the colour we want at a certain time
	assign color[2]= color1[2];
	assign color[1]= color1[1];
	assign color[0]= color1[0];
	reg [7:0] x, eraseX;
	reg [6:0] y, eraseY;
	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(color),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK),
			.VGA_SYNC(VGA_SYNC),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "gameStart.mif";
			
	// Put your code here. Your code should produce signals x,y,color and writeEn
	// for the VGA controller, in addition to any other functionality your design may require.
		reg [6:0] gravity; // pulls the character down
		reg halfsec;		 // sets a delay for the erase
		reg [8:0] constantLEFT; // moves the character to the left 
		wire [6:0]sum;		 // y position including all the variable add ons
		assign sum = 14 + A + gravity + down - up;
		reg[26:0]count;
		always@(posedge VGA_CLK)
		begin
			if (count == 26'd2500000)
			begin
				count <= 26'b0;
				halfsec <= 1;
				if (sum > 10 & sum <110) // while the character is in the proper bounds, increment
				begin
					gravity <= gravity + 1;
					constantLEFT <= constantLEFT + 4;
				end
				if (curr == START) // reset if we go back to the first state
				begin
					gravity <= 0;
					constantLEFT <= 0;
				end
			end
			else 
			begin	
				count <= count + 1'b1;
				halfsec <= 0;
			end
		end
		
	initial
	begin
		curr = START;
	end	
	
	reg [7:0] up, down, right, left;
	
	
		// up movement when key 3 is clicked
	always@(negedge KEY[3]) // move up
	begin
		up = up + 9;
		if (curr == START) up <= 0;
	end
	
	// down movement when key 2 is clicked
	always@(negedge KEY[2])
	begin
		down <= down + 5;
		if (curr == START) down <= 0;
	end
	
	// left movement when key 1 is clicked
	always@(negedge KEY[1])
	begin
		left <= left + 5;
		if (curr == START) left <= 0;
	end
	
	// right movement when key 0 is clicked
	always@(negedge KEY[0]) // move up
	begin
		right = right + 5;
		if (curr == START) right <= 0;
	end
	
	
		wire [7:0] address;
		reg [3:0] A; // jetman
		reg [3:0] B;

		assign address = {A,B}; // for jetman
		//instantiating ROM with picture of superman
		drawer test(address, CLOCK_50, colorObj); // JETMAN CHARACTER
		
		assign LEDR[17:13] = curr; // to show which state of the FSM we are currently on 
		reg [3:0]next; //next
		reg[3:0]curr; //curr 
		parameter[3:0] START = 4'b0001, MOVE = 4'b0010, ERASE = 4'b0100, STOP = 4'b1000;
		always@(next, curr, halfsec)
		begin
			case(curr)
				START: // the start state
					if (SW[1] == 1) next = MOVE;
					else next = START;
				MOVE: // the jetman movement and collision state
				begin
					if (y == 110 | y == 10) begin // if the character hits the wall
						next = STOP;
					end 
					// collision for block1 ----- START OF COLLISION DETECTION
					else if (( (x > (blockleft1 - constantLEFT)) & x < ((blockright1 - constantLEFT)) ) & ( (y > blockup1) & ( y < blockdown1) ) ) next = STOP;
					// collision for block2
					else if (( (x > (blockleft2 - constantLEFT)) & x < ((blockright2 - constantLEFT)) ) & ( (y > blockup2) & ( y < blockdown2) ) ) next = STOP;
					// collision for block3
					else if (( (x > (blockleft3 - constantLEFT)) & x < ((blockright3 - constantLEFT)) ) & ( (y > blockup3) & ( y < blockdown3) ) ) next = STOP;
					// collision for block4
					else if (( (x > (blockleft4 - constantLEFT)) & x < ((blockright4 - constantLEFT)) ) & ( (y > blockup4) & ( y < blockdown4) ) ) next = STOP;
					// collision for block5
					else if (( (x > (blockleft5 - constantLEFT)) & x < ((blockright5 - constantLEFT)) ) & ( (y > blockup5) & ( y < blockdown5) ) ) next = STOP;
					// collision for block6
					else if (( (x > (blockleft6 - constantLEFT)) & x < ((blockright6 - constantLEFT)) ) & ( (y > blockup6) & ( y < blockdown6) ) ) next = STOP;
					// collision for block7
					else if (( (x > (blockleft7 - constantLEFT)) & x < ((blockright7 - constantLEFT)) ) & ( (y > blockup7) & ( y < blockdown7) ) ) next = STOP;
					// collision for block8
					else if (( (x > (blockleft8 - constantLEFT)) & x < ((blockright8 - constantLEFT)) ) & ( (y > blockup8) & ( y < blockdown8) ) ) next = STOP;
					// collision for block9
					else if (( (x > (blockleft9 - constantLEFT)) & x < ((blockright9 - constantLEFT)) ) & ( (y > blockup9) & ( y < blockdown9) ) ) next = STOP;
					// collision for block10
					else if (( (x > (blockleft10 - constantLEFT)) & x < ((blockright10 - constantLEFT)) ) & ( (y > blockup10) & ( y < blockdown10) ) ) next = STOP;
					// collision for block11
					else if (( (x > (blockleft11 - constantLEFT)) & x < ((blockright11 - constantLEFT)) ) & ( (y > blockup11) & ( y < blockdown11) ) ) next = STOP;
					else 
					begin
						if (halfsec) begin
							next = ERASE;
						end
						else begin // halfsec is 0, its 0 for half a sec
							next = MOVE;
						end
					end	
				end
				ERASE: // Erasing the screen state
					if ((x==160) & (y == 120)) begin // if we are done going through every pixel
						next = MOVE;
					end
					else begin
						next = ERASE;	
					end
				STOP: //the stop state
					begin
						if (SW[17] == 1) next = START;
						else next = STOP; 
					end
					
			endcase
		end
			
		// passes the next state to curr	
		always@(posedge CLOCK_50)
		begin
				curr <= next;
		end
		
		
	reg endofdraw, didGamefinish;
	always@(posedge CLOCK_50)
	begin
		// definition of starting state
		if (curr == START)
		begin		
			didGamefinish <= 1;
			x <= 10;
			y <= 16;
		end
		// definition of move the jetman character state
		if (curr == MOVE)
		begin			
			endofdraw <= 1;
			color1 = colorObj;
			if(B==4'b1111)
			begin					
				A <= A + 1;
			end
			B <= B + 1;
			x<=B + 10 + right - left;
			y<=16 + A + gravity + down - up;
		end
		// definition of the erase the entire screen by drawing the background state
		else if (curr == ERASE)
		begin
			if (endofdraw)
			begin // erases all the initial 0 state
				eraseX <= 0;
				eraseY <= 0;
				endofdraw <= 0;
			end		
			if (eraseY < 10 | eraseY > 110) color1 = 3'b101; // purple top and bottom.
			// block 1
			else if (((eraseX > (blockleft1- constantLEFT)) & eraseX < (blockright1- constantLEFT)) & (eraseY > 50 & eraseY < 60)) color1 = 3'b011;
			// block 2
			else if (((eraseX > (blockleft2- constantLEFT)) & eraseX < (blockright2- constantLEFT)) & (eraseY > 90 & eraseY < 97)) color1 = 3'b011;
			// block 3
			else if (((eraseX > (blockleft3- constantLEFT)) & eraseX < (blockright3- constantLEFT)) & (eraseY > 70 & eraseY < 80)) color1 = 3'b011;
			// block 4
			else if (((eraseX > (blockleft4- constantLEFT)) & eraseX < (blockright4- constantLEFT)) & (eraseY > 95 & eraseY < 105)) color1 = 3'b011;
			// block 5
			else if (((eraseX > (blockleft5- constantLEFT)) & eraseX < (blockright5- constantLEFT)) & (eraseY > 35 & eraseY < 50)) color1 = 3'b011;
			// block 6
			else if (((eraseX > (blockleft6- constantLEFT)) & eraseX < (blockright6- constantLEFT)) & (eraseY > 55 & eraseY < 75)) color1 = 3'b011;
			// block 7
			else if (((eraseX > (blockleft7- constantLEFT)) & eraseX < (blockright7- constantLEFT)) & (eraseY > 20 & eraseY < 25)) color1 = 3'b011;
			// block 8
			else if (((eraseX > (blockleft8- constantLEFT)) & eraseX < (blockright8- constantLEFT)) & (eraseY > 70 & eraseY < 75)) color1 = 3'b011;
			// block 9
			else if (((eraseX > (blockleft9- constantLEFT)) & eraseX < (blockright9- constantLEFT)) & (eraseY > 40 & eraseY < 45)) color1 = 3'b011;
			// block 10
			else if (((eraseX > (blockleft10- constantLEFT)) & eraseX < (blockright10- constantLEFT)) & (eraseY > 80 & eraseY < 85)) color1 = 3'b011;
			// block 11
			else if (((eraseX > (blockleft11- constantLEFT)) & eraseX < (blockright11- constantLEFT)) & (eraseY > 65 & eraseY < 70)) color1 = 3'b011;
			else color1 = 3'b000; // black interior		
			if(eraseX == 160)
			begin					
				eraseY <= eraseY + 1;
			end
			eraseX <= eraseX + 1;
				
			x <= eraseX;
			y <= eraseY;
		end
		// definition for the stop state, stopping/ending our game
		else if (curr == STOP)
		begin
			if (didGamefinish) // erases background
			begin
				x <= 0;
				y <= 0;
				didGamefinish <= 0;
			end
			if (y < 10 | y > 110) color1 = 3'b000; 
			else if (x < 10 | x > 150) color1 = 3'b000; 
			// G
			else if (x > 55 & x < 65 & y ==50) color1 = 3'b001; // -
			else if (y > 50 & y < 65 & x ==55) color1 = 3'b001; // |
			else if (x > 55 & x < 65 & y ==65) color1 = 3'b001; // _
			else if (y > 58 & y < 65 & x ==65) color1 = 3'b001;
			// G
			else if (x > 85 & x < 95 & y ==50) color1 = 3'b001;
			else if (y > 50 & y < 65 & x ==85) color1 = 3'b001;
			else if (x > 85 & x < 95 & y ==65) color1 = 3'b001;
			else if (y > 58 & y < 65 & x ==95) color1 = 3'b001;
			else color1 = 3'b111;
						
			if(x == 160)
			begin					
				y <= y + 1;
			end
			x <= x + 1;
		end	
	end
 
 // for score display
	output [0:6] HEX0, HEX1, HEX2, HEX3;
	reg [26:0] counterTIME;
	reg [15:0]enable;
	 always@(posedge CLOCK_50)
		 begin
			 if (curr == START)enable <= 0;
			 if (sum != STOP)
			 begin 
				 if(counterTIME==26'd2500000)
					 begin
						 counterTIME <= 0;
						 enable <= enable + 1;
					 end
				 else
					 begin
						 counterTIME <= counterTIME + 1;
					 end
			end
		 end
	 SEG7(enable[3:0], HEX0);
	 SEG7(enable[7:4], HEX1);
	 SEG7(enable[11:8], HEX2);
	 SEG7(enable[15:12], HEX3);
	
endmodule

// for colour
module SEG7(X, A);
	 input [3:0] X;
	 output reg [0:6] A;
	 always @(X)
		 begin
			 case({X})
		  4'b0000: A = 'b0000001; // 0
		  4'b0001: A = 'b1001111;
		  4'b0010: A = 'b0010010;
		  4'b0011: A = 'b0000110;
		  4'b0100: A = 'b1001100;
		  4'b0101: A = 'b0100100;
		  4'b0110: A = 'b0100000;
		  4'b0111: A = 'b0001101;
		  4'b1000: A = 'b0000000;
		  4'b1001: A = 'b0001100; //9
		  4'b1010: A = 'b0001000; // A
		  4'b1011: A = 'b1100000;
		  4'b1100: A = 'b0110001; // C
		  4'b1101: A = 'b1000010;
		  4'b1110: A = 'b0110000; // E
		  4'b1111: A = 'b0111000; // F
		  endcase
		 end
endmodule

	/*
		// Etch-and-sketch

module sketch
	(
		CLOCK_50,						//	On Board 50 MHz
		KEY,							//	Push Button[3:0]
		SW,								//	DPDT Switch[17:0]
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK,						//	VGA BLANK
		VGA_SYNC,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B,   						//	VGA Blue[9:0]
		LEDR,
		HEX0, HEX1, HEX2, HEX3
	);

	input			CLOCK_50;				//	50 MHz
	input	[3:0]	KEY;					//	Button[3:0]
	input	[17:0]	SW;						//	Switches[0:0]
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK;				//	VGA BLANK
	output			VGA_SYNC;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	output [17:0]LEDR;
	assign LEDR[2] = color1[2];
	assign LEDR[1] = color1[1];
	assign LEDR[0] = color1[0];
	assign LEDR[3] = halfsec;
	wire resetn;
	assign resetn = SW[0];
	wire [8:0] blockleft1, blockright1, blockleft2, blockright2, blockleft3, blockright3, blockleft4, blockright4, blockleft5, blockright5, blockleft6, blockright6, blockleft7, blockright7, blockleft8, blockright8, blockleft9, blockright9, blockleft10, blockright10, blockleft11, blockright11;
	wire [6:0] blockup1, blockdown1, blockup2, blockdown2, blockup3, blockdown3, blockup4, blockdown4, blockup5, blockdown5, blockup6, blockdown6, blockup7, blockdown7, blockup8, blockdown8, blockup9, blockdown9, blockup10, blockdown10, blockup11, blockdown11;
	// block 1
	assign blockleft1 = 160; 	assign blockright1 = 167; assign blockup1 = 50; assign blockdown1 =57;
	// block 2
	assign blockleft2 = 195; 	assign blockright2 = 202; assign blockup2 = 90; assign blockdown2 = 97;
	// block 3
	assign blockleft3 = 225; 	assign blockright3 = 230; assign blockup3 = 70; assign blockdown3 = 75;
	// block 4
	assign blockleft4 = 255; 	assign blockright4 = 262; assign blockup4 = 95; assign blockdown4 = 102;
	// block 5
	assign blockleft5 = 300; 	assign blockright5 = 310; assign blockup5 = 35 ; assign blockdown5 = 45;
	// block 6
	assign blockleft6 = 350; 	assign blockright6 = 355; assign blockup6 = 60; assign blockdown6 = 65;
	// block 7
	assign blockleft7 = 400; 	assign blockright7 = 405; assign blockup7 = 20; assign blockdown7 = 25;
	// block 8
	assign blockleft8 = 440; 	assign blockright8 = 445; assign blockup8 = 70; assign blockdown8 = 75;
	// block 9
	assign blockleft9 = 495; 	assign blockright9 = 500; assign blockup9 = 40; assign blockdown9 = 45;
	// block 10
	assign blockleft10 = 50; 	assign blockright10 = 60; assign blockup10 = 80; assign blockdown10 = 85;
	// block 11
	assign blockleft11 = 90; 	assign blockright11 = 95; assign blockup11=  65; assign blockdown11 = 70;
	
	wire writeEn;
	assign writeEn = 1;
	// Create the color, x, y and writeEn wires that are inputs to the controller.

	wire [2:0] color;
	reg [2:0] color1;
	wire [2:0] colorObj;
	wire [2:0] colorback;
	//assign color2 = 3'b011;
	reg mux; // used to tell the computer when to draw the picture and when to draw a black screen
	//multiplexer(color1, color2, color, mux);
	
	//if mux is 1, we have black
	assign color[2]= color1[2];
	assign color[1]= color1[1];
	assign color[0]= color1[0];
	reg [7:0] x, eraseX;
	reg [6:0] y, eraseY;
	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(color),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. 
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK),
			.VGA_SYNC(VGA_SYNC),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "gameSign.mif";
			
	// Put your code here. Your code should produce signals x,y,color and writeEn
	// for the VGA controller, in addition to any other functionality your design may require.
		reg [6:0] gravity;
		wire [6:0]sum;
		reg halfsec;
		reg [8:0] constantLEFT;
		assign sum = 14 + A + gravity + down - up;
		reg[26:0]count;
		always@(posedge VGA_CLK)
		begin
			if (count == 26'd2500000)
			begin
				count <= 26'b0;
				halfsec <= 1;
				if (sum > 10 & sum <110) 
				begin
					gravity <= gravity + 1;
					constantLEFT <= constantLEFT + 4;
				end
				if (curr == START)
				begin
					gravity <= 0;
					constantLEFT <= 0;
				end
			end
			else 
			begin	
				count <= count + 1'b1;
				halfsec <= 0;
			end
		end
		
	initial
	begin
		curr = START;
	end	
	
	reg [7:0] up, down, right, left;
	
	// down movement when key 1 is clicked
	always@(negedge KEY[2])
	begin
		down <= down + 5;
		if (curr == START) down <= 0;
	end
	
	always@(negedge KEY[3]) // move up
	begin
		up = up + 9;
		if (curr == START) up <= 0;
	end
	
	// down movement when key 1 is clicked
	always@(negedge KEY[1])
	begin
		left <= left + 5;
		if (curr == START) left <= 0;
	end
	
	always@(negedge KEY[0]) // move up
	begin
		right = right + 5;
		if (curr == START) right <= 0;
	end
		wire [7:0] address;
		reg [3:0] A; // jetman
		reg [3:0] B;

		assign address = {A,B}; // for jetman
		//instantiating ROM with picture of superman
		drawer test(address, CLOCK_50, colorObj);
		
		wire [14:0] address1;
		reg [6:0] C; // jetman
		reg [7:0] D;
		assign address1 = {C,D}; // for jetman
		//instantiating ROM with picture of superman
		//gameover hello(address1, CLOCK_50, colorback);
		
		
		assign LEDR[17:13] = curr;
		reg [4:0]next; //next
		reg[4:0]curr; //curr 
		parameter[4:0] START = 5'b00001, MOVE = 5'b00010, ERASE = 5'b00100, STOP = 5'b01000, BLOCK = 5'b10000;
		always@(next, curr, halfsec)
		begin
			case(curr)
				START:
					if (SW[1] == 1) next = MOVE;
					else next = START;
				MOVE: // ze jetman
				begin
					if (y == 110 | y == 10) begin
						next = STOP;
					end
					// collision for block1
					else if (( (x > (blockleft1 - constantLEFT)) & x < ((blockright1 - constantLEFT)) ) & ( (y > blockup1) & ( y < blockdown1) ) ) next = STOP;
					// collision for block2
					else if (( (x > (blockleft2 - constantLEFT)) & x < ((blockright2 - constantLEFT)) ) & ( (y > blockup2) & ( y < blockdown2) ) ) next = STOP;
					// collision for block3
					else if (( (x > (blockleft3 - constantLEFT)) & x < ((blockright3 - constantLEFT)) ) & ( (y > blockup3) & ( y < blockdown3) ) ) next = STOP;
					// collision for block4
					else if (( (x > (blockleft4 - constantLEFT)) & x < ((blockright4 - constantLEFT)) ) & ( (y > blockup4) & ( y < blockdown4) ) ) next = STOP;
					// collision for block5
					else if (( (x > (blockleft5 - constantLEFT)) & x < ((blockright5 - constantLEFT)) ) & ( (y > blockup5) & ( y < blockdown5) ) ) next = STOP;
					// collision for block6
					else if (( (x > (blockleft6 - constantLEFT)) & x < ((blockright6 - constantLEFT)) ) & ( (y > blockup6) & ( y < blockdown6) ) ) next = STOP;
					// collision for block7
					else if (( (x > (blockleft7 - constantLEFT)) & x < ((blockright7 - constantLEFT)) ) & ( (y > blockup7) & ( y < blockdown7) ) ) next = STOP;
					// collision for block8
					else if (( (x > (blockleft8 - constantLEFT)) & x < ((blockright8 - constantLEFT)) ) & ( (y > blockup8) & ( y < blockdown8) ) ) next = STOP;
					// collision for block9
					else if (( (x > (blockleft9 - constantLEFT)) & x < ((blockright9 - constantLEFT)) ) & ( (y > blockup9) & ( y < blockdown9) ) ) next = STOP;
					// collision for block10
					else if (( (x > (blockleft10 - constantLEFT)) & x < ((blockright10 - constantLEFT)) ) & ( (y > blockup10) & ( y < blockdown10) ) ) next = STOP;
					// collision for block11
					else if (( (x > (blockleft11 - constantLEFT)) & x < ((blockright11 - constantLEFT)) ) & ( (y > blockup11) & ( y < blockdown11) ) ) next = STOP;
					else 
					begin
						if (halfsec) begin
							next = ERASE;
						end
						else begin // halfsec is 0, its 0 for half a sec
							next = MOVE;
						end
					end	
				end
				BLOCK: //ze enemy
					begin
					//	if (C == 8 & D == 8) begin
					//		next = ERASE;
					//	end
					//	else begin // halfsec is 0, its 0 for half a sec
					//	   next = BLOCK;
					//	end
					end
				ERASE: //ze erase the screen
					if ((x==160) & (y == 120)) begin
						next = MOVE;
					end
					else begin
						next = ERASE;	
					end
				STOP: //ze estop estate
					begin
						if (SW[17] == 1) next = START;
						else next = STOP; 
					end
					
			endcase
		end
				
		always@(posedge CLOCK_50)
		begin
				curr <= next;
		end
		
		
	reg endofdraw, didGamefinish;
	always@(posedge CLOCK_50)
	begin
		// definition of starting state
		if (curr == START)
		begin		
			didGamefinish <= 1;
			x <= 10;
			y <= 16;
		end
		// definition of move the jetman character state
		if (curr == MOVE)
		begin			
			endofdraw <= 1;
			color1 = colorObj;
			if(B==4'b1111)
			begin					
				A <= A + 1;
			end
			B <= B + 1;
			x<=B + 10 + right - left;
			y<=16 + A + gravity + down - up;
		end
		// move the block definition
		if (curr == BLOCK)
		begin			
			//color1 = 3'b001;
			//if(D==3'b111)
			//begin					
			//	C <= C + 1;
			//end
			//D <= D + 1;
			//x<=D + 140 - constantLEFT;
			//y<=50 + B;
		end
		// definition of the erase the entire screen by drawing the background state
		else if (curr == ERASE)
		begin
			if (endofdraw)
			begin // erases all the initial 0 state
				eraseX <= 0;
				eraseY <= 0;
				endofdraw <= 0;
			end		
			if (eraseY < 10 | eraseY > 110) color1 = 3'b101; // purple top and bottom.
			// block 1
			else if (((eraseX > (blockleft1- constantLEFT)) & eraseX < (blockright1- constantLEFT)) & (eraseY > 50 & eraseY < 60)) color1 = 3'b011;
			// block 2
			else if (((eraseX > (blockleft2- constantLEFT)) & eraseX < (blockright2- constantLEFT)) & (eraseY > 90 & eraseY < 97)) color1 = 3'b011;
			// block 3
			else if (((eraseX > (blockleft3- constantLEFT)) & eraseX < (blockright3- constantLEFT)) & (eraseY > 70 & eraseY < 80)) color1 = 3'b011;
			// block 4
			else if (((eraseX > (blockleft4- constantLEFT)) & eraseX < (blockright4- constantLEFT)) & (eraseY > 95 & eraseY < 105)) color1 = 3'b100;
			// block 5
			else if (((eraseX > (blockleft5- constantLEFT)) & eraseX < (blockright5- constantLEFT)) & (eraseY > 35 & eraseY < 50)) color1 = 3'b011;
			// block 6
			else if (((eraseX > (blockleft6- constantLEFT)) & eraseX < (blockright6- constantLEFT)) & (eraseY > 55 & eraseY < 75)) color1 = 3'b011;
			// block 7
			else if (((eraseX > (blockleft7- constantLEFT)) & eraseX < (blockright7- constantLEFT)) & (eraseY > 20 & eraseY < 25)) color1 = 3'b011;
			// block 8
			else if (((eraseX > (blockleft8- constantLEFT)) & eraseX < (blockright8- constantLEFT)) & (eraseY > 70 & eraseY < 75)) color1 = 3'b011;
			// block 9
			else if (((eraseX > (blockleft9- constantLEFT)) & eraseX < (blockright9- constantLEFT)) & (eraseY > 40 & eraseY < 45)) color1 = 3'b011;
			// block 10
			else if (((eraseX > (blockleft10- constantLEFT)) & eraseX < (blockright10- constantLEFT)) & (eraseY > 80 & eraseY < 85)) color1 = 3'b011;
			// block 11
			else if (((eraseX > (blockleft11- constantLEFT)) & eraseX < (blockright11- constantLEFT)) & (eraseY > 65 & eraseY < 70)) color1 = 3'b011;
			else color1 = 3'b000; // black interior		
			if(eraseX == 160)
			begin					
				eraseY <= eraseY + 1;
			end
			eraseX <= eraseX + 1;
				
			x <= eraseX;
			y <= eraseY;
		end
		// definition for the stop state, stopping/ending our game
		else if (curr == STOP)
		begin
			color1 = 3'b000;
			if (didGamefinish) // erases background
			begin
				x <= 0;
				y <= 0;
				didGamefinish <= 0;
			end
			if (y < 10 | y > 110) color1 = 3'b011; 
			else if (x < 10 | x > 150) color1 = 3'b011; 
			// G
			else if (x > 55 & x < 65 & y ==50) color1 = 3'b001; // -
			else if (y > 50 & y < 65 & x ==55) color1 = 3'b001; // |
			else if (x > 55 & x < 65 & y ==65) color1 = 3'b001; // _
			else if (y > 58 & y < 65 & x ==65) color1 = 3'b001;
			// G
			else if (x > 85 & x < 95 & y ==50) color1 = 3'b001;
			else if (y > 50 & y < 65 & x ==85) color1 = 3'b001;
			else if (x > 85 & x < 95 & y ==65) color1 = 3'b001;
			else if (y > 58 & y < 65 & x ==95) color1 = 3'b001;
			else color1 = 3'b111;
			
			
			if(x == 160)
			begin					
				y <= y + 1;
			end
			x <= x + 1;
		end	
	end

	output [0:6] HEX0, HEX1, HEX2, HEX3;
	reg [26:0] counterTIME;
	reg [15:0]enable;
	 always@(posedge CLOCK_50)
		 begin
			 if (curr == START)enable <= 0;
			 if (sum > 10 & sum <110)
			 begin 
				 if(counterTIME==26'd2500000)
					 begin
						 counterTIME <= 0;
						 enable <= enable + 1;
					 end
				 else
					 begin
						 counterTIME <= counterTIME + 1;
					 end
			end
		 end
	 SEG7(enable[3:0], HEX0);
	 SEG7(enable[7:4], HEX1);
	 SEG7(enable[11:8], HEX2);
	 SEG7(enable[15:12], HEX3);
	
endmodule

// for colour
module SEG7(X, A);
	 input [3:0] X;
	 output reg [0:6] A;
	 always @(X)
		 begin
			 case({X})
		  4'b0000: A = 'b0000001; // 0
		  4'b0001: A = 'b1001111;
		  4'b0010: A = 'b0010010;
		  4'b0011: A = 'b0000110;
		  4'b0100: A = 'b1001100;
		  4'b0101: A = 'b0100100;
		  4'b0110: A = 'b0100000;
		  4'b0111: A = 'b0001101;
		  4'b1000: A = 'b0000000;
		  4'b1001: A = 'b0001100; //9
		  4'b1010: A = 'b0001000; // A
		  4'b1011: A = 'b1100000;
		  4'b1100: A = 'b0110001; // C
		  4'b1101: A = 'b1000010;
		  4'b1110: A = 'b0110000; // E
		  4'b1111: A = 'b0111000; // F
		  endcase
		 end
endmodule


	*/
