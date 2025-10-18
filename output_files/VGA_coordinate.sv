module VGA_coordinate(clk, reset, x, y, RedPixels, GrnPixels, r, g, b);
	input logic clk, reset;
	input logic [15:0][15:0] RedPixels, GrnPixels;
	input logic [9:0] x;
	input logic [8:0] y;
	output logic [7:0] r, g, b;
	
	always_comb begin
	end
	
	
endmodule 