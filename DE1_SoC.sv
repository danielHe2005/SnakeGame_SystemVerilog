
// Top-level module that defines the I/Os for the DE-1 SoC board
module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, SW, LEDR, GPIO_1, CLOCK_50, PS2_CLK, PS2_DAT, VGA_R, VGA_G, VGA_B, VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS,
						CLOCK2_50, FPGA_I2C_SCLK, FPGA_I2C_SDAT, AUD_XCK, AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK, AUD_ADCDAT, AUD_DACDAT);
    output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	 output logic [9:0]  LEDR;
    input  logic [3:0]  KEY;
    input  logic [9:0]  SW;
	 //keyboard logic
	 input logic PS2_CLK, PS2_DAT;
    output logic [35:0] GPIO_1;
	 //clock
    input logic CLOCK_50, CLOCK2_50;
	 //video display logic
	 output [7:0] VGA_R;
	 output [7:0] VGA_G;
	 output [7:0] VGA_B;
	 output VGA_BLANK_N;
	 output VGA_CLK;
	 output VGA_HS;
	 output VGA_SYNC_N;
	 output VGA_VS;

	 // Turn off HEX displays
    assign HEX3 = '1;
    assign HEX4 = '1;
    assign HEX5 = '1;
	 
	 
	 /* Set up system base clock to 1526 Hz (50 MHz / 2**(14+1))
	    ===========================================================*/
	 logic [31:0] clk;
	 logic SYSTEM_CLOCK;
	 
	 clock_divider divider (.clock(CLOCK_50), .divided_clocks(clk));
	 
	 assign SYSTEM_CLOCK = clk[15]; // 14 is 1526 Hz clock signal	 
	 
	 /* If you notice flickering, set SYSTEM_CLOCK faster.
	    However, this may reduce the brightness of the LED board. */
	
	 
	 /* Set up LED board driver
	    ================================================================== */
	 logic [15:0][15:0]RedPixels; // 16 x 16 array representing red LEDs
    logic [15:0][15:0]GrnPixels; // 16 x 16 array representing green LEDs
	 logic reset;
	 
	 assign reset = SW[9];
	 
	 
	 
	 
	// I2C Audio/Video config interface
	output FPGA_I2C_SCLK;
	inout FPGA_I2C_SDAT;
	// Audio CODEC
	output AUD_XCK;
	input AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK;
	input AUD_ADCDAT;
	output AUD_DACDAT;
	
	// Local wires
	logic read_ready, write_ready, read, write;
	logic signed [23:0] readdata_left, readdata_right;
	logic signed [23:0] writedata_left, writedata_right;
	logic signed [23:0] task2_left, task2_right, task3_left, task3_right;
	logic signed [23:0] noisy_left, noisy_right;
	
	logic [23:0] noise;
	noise_gen noise_generator (.clk(CLOCK_50), .en(read), .rst(reset), .out(noise));
	assign noisy_left = readdata_left + noise;
	assign noisy_right = readdata_right + noise;
	
	always_comb begin
		case(KEY[2:0])
			3'b110: begin // KEY0 outputs noise
				writedata_left = noisy_left;
				writedata_right = noisy_right;
			end
			3'b101: begin // KEY1 outputs task2 filtered noise
				writedata_left = task2_left;
				writedata_right = task2_right;
			end
			3'b011: begin // KEY2 outputs task3 filtered noise
				writedata_left = task3_left;
				writedata_right = task3_right;
			end
			default: begin // default output raw data
				writedata_left = readdata_left;
				writedata_right = readdata_right;
			end
		endcase
	end

	// only read or write when both are possible
	assign read = read_ready & write_ready;
	assign write = read_ready & write_ready;
	
/////////////////////////////////////////////////////////////////////////////////
// Audio CODEC interface. 
//
// The interface consists of the following wires:
// read_ready, write_ready - CODEC ready for read/write operation 
// readdata_left, readdata_right - left and right channel data from the CODEC
// read - send data from the CODEC (both channels)
// writedata_left, writedata_right - left and right channel data to the CODEC
// write - send data to the CODEC (both channels)
// AUD_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio CODEC
// I2C_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio/Video Config module
/////////////////////////////////////////////////////////////////////////////////
	clock_generator my_clock_gen(
		// inputs
		CLOCK2_50,
		1'b0,

		// outputs
		AUD_XCK
	);

	audio_and_video_config cfg(
		// Inputs
		CLOCK_50,
		1'b0,

		// Bidirectionals
		FPGA_I2C_SDAT,
		FPGA_I2C_SCLK
	);

	audio_codec codec(
		// Inputs
		CLOCK_50,
		1'b0,

		read,	write,
		writedata_left, writedata_right,

		AUD_ADCDAT,

		// Bidirectionals
		AUD_BCLK,
		AUD_ADCLRCK,
		AUD_DACLRCK,

		// Outputs
		read_ready, write_ready,
		readdata_left, readdata_right,
		AUD_DACDAT
	);

	 
	 
	 
	 
	 /* Standard LED Driver instantiation - set once and 'forget it'. 
	    See LEDDriver.sv for more info. Do not modify unless you know what you are doing! */
	 LEDDriver Driver (.CLK(SYSTEM_CLOCK), .RST(reset), .EnableCount(1'b1), .RedPixels, .GrnPixels, .GPIO_1);
	 
	 
	 // experimental code for testing snake game
	 logic [3:0] alternateIn;
	 logic [3:0] detectedMoves, snakeRow, snakeCol, appleCol, appleRow;
	 logic enable, left, right, up, down;
	 assign left = ~KEY[0]|alternateIn[0];
	 assign up = ~KEY[1]|alternateIn[1];
	 assign down = ~KEY[2]|alternateIn[2];
	 assign right = ~KEY[3]|alternateIn[3];
	 
	 // DFF to deal with metastability
	 dFlipFlop player(.clk(clk[0]), .reset(reset), .d({left, up, down, right}), .q(detectedMoves));
	 // takes in the inputs from the user and translates it to whether the snake's head is moving horizontally or vertically and which direction its moving in
	 snakeHead snake(.clk(clk[23]), .Reset(reset), .move(detectedMoves), .rowPosition(snakeRow), .colPosition(snakeCol), .gameEnd(endGame));
	 // controls many aspects of the game such as the 
	 controller controlSystem(.clk(clk[23]), .reset(reset), .gameCollide(endGame), .bcdEna(bcdEna), .appleCol(appleCol), .appleRow(appleRow), .snakeCol(snakeCol), .snakeRow(snakeRow), .redLED(RedPixels), .greenLED(GrnPixels));
	 
	 // apple coordinate generator
	 LFSR_8bit appleGen(.clk(clk[0]), .reset(reset), .enable(enable), .q({appleCol, appleRow}));
	assign enable = GrnPixels[appleRow][appleCol];
	
	logic endGame, bcdEna;
	logic [11:0] hexScore;
	// HEX score control
	bcdControl scoreCount(.clk(clk[0]), .reset(reset), .ena(bcdEna), .q(hexScore));
	hexControl hexOne(.q(hexScore[3:0]), .hex(HEX0));
	hexControl hexTen(.q(hexScore[7:4]), .hex(HEX1));
	hexControl hexHundred(.q(hexScore[11:8]), .hex(HEX2));
	
	// PS2 Keyboard input
	logic valid, makeBreak;
	logic [7:0] outCode;
	keyboard_press_driver keyDrive(.CLOCK_50(CLOCK_50), .valid(valid), .makeBreak(makeBreak), .outCode(outCode), .PS2_DAT(PS2_DAT), .PS2_CLK(PS2_CLK), .reset(reset));
	keyboardTranslate keyIn(.clk(CLOCK_50), .reset(reset), .valid(valid), .makeBreak(makeBreak), .outCode(outCode), .directionCommand(alternateIn));
	
	
	// VGA video display
	logic [9:0] x;
	logic [8:0] y;
	logic [7:0] r, g, b;
	video_driver #(.WIDTH(480), .HEIGHT(480))
		v1 (.CLOCK_50, .reset, .x, .y, .r, .g, .b,
			 .VGA_R, .VGA_G, .VGA_B, .VGA_BLANK_N,
			 .VGA_CLK, .VGA_HS, .VGA_SYNC_N, .VGA_VS);
	VGA_coordinate vga_driver(.reset(reset), .x(x), .y(y), .RedPixels(RedPixels), .GrnPixels(GrnPixels), .r(r), .g(g), .b(b)); 
	
endmodule 

module DE1_SoC_testbench();

	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;
	logic CLOCK_50;
	logic [35:0] GPIO_1;
	logic PS2_CLK;
	logic PS2_DAT;
	logic [7:0] VGA_R;
	logic [7:0] VGA_G;
	logic [7:0] VGA_B;
	logic VGA_BLANK_N;
	logic VGA_CLK;
	logic VGA_HS;
	logic VGA_SYNC_N;
	logic VGA_VS;
	
	DE1_SoC dut (.HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .SW, .LEDR, .GPIO_1, .CLOCK_50, .PS2_CLK, .PS2_DAT, .VGA_R, .VGA_G, .VGA_B, .VGA_BLANK_N, .VGA_CLK, .VGA_HS, .VGA_SYNC_N, .VGA_VS);

	//clock setup
		parameter clock_period = 100;
		
		initial begin
			CLOCK_50 <= 0;
			forever #(clock_period /2) CLOCK_50 <= ~CLOCK_50;
					
		end //initial
		
	initial begin
		
			KEY[0] <= 0;                         @(posedge CLOCK_50); // every time posedge CLOCK_50, advances by one clock cycle (to the next pos edge)
															 @(posedge CLOCK_50);
															 @(posedge CLOCK_50);
															 @(posedge CLOCK_50);
															 @(posedge CLOCK_50);
															 @(posedge CLOCK_50);
															 @(posedge CLOCK_50);
						
			$stop; //end simulation							
							
		end //initial
		
endmodule	