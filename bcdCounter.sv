/* instantiates a bcdCounter, which utilizes an enable input to count between zero to nine following a clock edge
Parameters:
	clk: the clock that controls the system
	reset: resets the counter back to zero
	ena: determines whether to increment the counter on a clock edge
	out: a 4 bit output signal for the counter's count
*/
module bcdCounter(clk, reset, ena, out);
	input logic clk, reset, ena;
	output logic [3:0] out;
	logic enable;
	
	enum {currZero, currOne} ps, ns;
	 
	 always_ff@(posedge clk)begin
		if(reset) ps <= currZero;
		else ps <= ns;
	 end
	 
	 assign enable = ena&(ps == currZero);
	 
	 always_comb begin
		case(ps)
			currZero: ns = ena?currOne:currZero;
			currOne: ns = ena?currOne:currZero;
		endcase
	 end
	 
	 
	 
   always_ff@(posedge clk)begin
		if(~reset&~enable)
			out <= out;
      else
			out <= (reset|(out == 9))?0:(out + 1);
   end
endmodule

module bcdCounter_testbench();
	logic clk, reset, ena; 
	logic [3:0] out;
	
	bcdCounter dut(.clk, .reset, .ena, .out);
	
	parameter clock_period = 100;
	integer i;
		
	initial begin
		clk <= 0;
		forever #(clock_period /2) clk <= ~clk;
	end //initial
		
	initial begin
		reset <= 1; @(posedge clk);
		reset <= 0; @(posedge clk);
		for(i = 0; i < 2**4; i++) begin
			ena <= 1;  @(posedge clk);
		end
		$stop;
	end
endmodule 