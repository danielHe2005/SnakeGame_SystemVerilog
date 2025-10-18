/* translates the gamestate of the 16x16 LED board onto a VGA display by utilizing ratios and checking to see if an LED was lit on the board and how it corresponded to the playing field on the VGA display
at 480x480, each LED occupied 30x30 or 900 pixels on the VGA display
Parameters:
	reset: resets the screen to white
	x: the current x coordinate that the video driver is evaluating
	y: the current y coordinate that the video driver is evaluating
	RedPixels: the LED array's red LED statuses
	GrnPixels: the LED array's green LED statuses
	r: the red value to be put at the evaluated pixel
	g: the green value to be put at the evaluated pixel
	b: the blue value to be put at the evaluated pixel
*/
module VGA_coordinate(reset, x, y, RedPixels, GrnPixels, r, g, b);
	input logic reset;
	input logic [15:0][15:0] RedPixels, GrnPixels;
	input logic [9:0] x;
	input logic [8:0] y;
	output logic [7:0] r, g, b;
	
	logic [4:0] yPixel, xPixel;
	
	assign yPixel = y%30;
	assign xPixel = x%30;
	
	always_comb begin
		if(reset)begin
			b = 8'b11111111;
			r = 8'b11111111;
			g = 8'b11111111;
		end else begin
			r = 8'b11111111;
			g = 8'b11111111;
			b = 8'b11111111;
			if(RedPixels[y/30][(479-x)/30])begin
				if((yPixel<5)&(10<xPixel<20))begin
					r = 8'd51;
					g = 8'b00000000;
					b = 8'b00000000;
				end else if(((10<yPixel<25)|((5<xPixel<25))))begin
					r = 8'd255;
					g = 8'b00000000;
					b = 8'b00000000;
				end
			end
			if(GrnPixels[y/30][(479-x)/30])begin
				r = 8'b00000000;
				b = 8'b00000000;
			end
		end
	end
endmodule 

module VGA_coordinate_testbench();

		logic reset;
		logic [9:0] x;
		logic [8:0] y;
		logic [7:0] r, g, b;
		logic [15:0][15:0] RedPixels, GrnPixels;
		
		VGA_coordinate dut(.reset, .x, .y, .RedPixels, .GrnPixels, .r, .g, .b);
		
		//clock setup
		integer i, j;
		initial begin
			reset = 1; #10;
			reset = 0; #10;
			x = 0; #10;
			y = 0; #10;
			RedPixels[0] = 16'b1000000000000000; #10;
			GrnPixels[3] = 16'b1000000000000000;; #10;
			for(i=0; i<480; i++) begin
				for(j = 0; j < 480; j++)begin
					x++; #10;
				end
				y++; #10;
			end
		end //initial
endmodule		