/* an 8-bit pseudo-random number generator that determines the coordinates of the apple on a 16x16 grid
Parameters:
	clk: the clock that sets the rate at which generations come out
	reset: resets the apple's coordinates back to original state
	enable: enables the apple's coordinates to move around
	q: the output coordinates of an apple
*/
module LFSR_8bit(clk, reset, enable, q);
	input logic clk, reset, enable;
	output logic [7:0] q;
	parameter defaultSetting = 8'b00100001;
	
	always_ff@(posedge clk)begin
		if(reset) q <= defaultSetting;
		else if(enable)begin
			q[0] <= q[3]^q[4]^q[5]^q[7];
			q[7:1] <= q[6:0];
		end
	end
endmodule

module LFSR_8bit_testbench();
	logic clk, reset, enable; 
	logic [7:0] q;
	
	LFSR_8bit dut(.clk, .reset, .enable, .q);
	
	parameter clock_period = 100;
	integer i;
		
	initial begin
		clk <= 0;
		forever #(clock_period /2) clk <= ~clk;
	end //initial
		
	initial begin
		reset <= 1; @(posedge clk);
		reset <= 0; @(posedge clk);
		for(i = 0; i < 2**8; i++) begin
			enable <= 1;  @(posedge clk);
		end
		$stop;
	end
endmodule 