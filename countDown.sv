/* module was made in order to help determine how long an LED should stay on if a snake head has crossed over it
Parameters:
	clk: logic that drives the sequential logic within the system
	reset: resets the count back to one (due to technicals with the initial starting state of the game)
	incr: keeps the LED on for one cycle longer if an apple has been eaten
	set: determines whether to set the starting place of the countdown
	initialCount: the starting place of the countdown
	out: an 8 bit output that tells the LED how much longer to stay on for
*/
module countDown(clk, reset, incr, set, initialCount, out);
	input logic clk, reset, incr, set;
	input logic [7:0] initialCount;
	output logic [7:0] out;
	
	always_ff@(posedge clk)begin
		if(reset)begin
			out <= 1;
		end else if(set)begin
			out <= initialCount;
		end else begin
			out <= incr?(out):(out-1);
		end
	end
	
endmodule 

module countDown_testbench();
	logic clk, reset, incr, set;
	logic [7:0] initialCount, out;
	
	countDown dut(.clk, .reset, .incr, .set, .initialCount, .out);
	
	parameter clock_period = 100;
		
	initial begin
		clk <= 0;
		forever #(clock_period /2) clk <= ~clk;
	end
	
	integer i;
	
	initial begin
		reset <= 1; incr <= 0; @(posedge clk);
		reset <= 0; set <= 1; initialCount <= 8'b00010000; @(posedge clk);
		set <= 0; @(posedge clk);
		
		for(i = 0; i < 2**4; i++) begin
			@(posedge clk);
		end
		
		incr <= 1; @(posedge clk);
					  @(posedge clk);
					  @(posedge clk);
		$stop;
	end
endmodule
		
		
	