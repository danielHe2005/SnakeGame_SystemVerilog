/* dFlipFlop instantiates two sets of DFFs to deal with metastability
Parameter:
	clk: the clock that drives the sequential logic
	reset: the logic that resets the module to it's original state
	d: the input to two pair of DFFs
	q: the output to the two pairs of DFFs
*/
module dFlipFlop(clk, reset, d, q);
	input logic clk, reset; 
	input logic [3:0] d;
	output logic [3:0] q;
	logic [3:0] inter;
	always_ff@(posedge clk)begin
		if(reset)begin
			q<=0;
			inter<=0;
		end
		else begin
			inter<=d;
			q<=inter;
		end
	end
endmodule

module dFlipFlop_testbench();

		logic clk, reset;
		logic d;
		logic q;
		
		dFlipFlop dut (.clk, .reset, .d, .q);
		
		//clock setup
		parameter clock_period = 100;
		
		initial begin
			clk <= 0;
			forever #(clock_period /2) clk <= ~clk;
		end //initial
		
		initial begin
		
			reset <= 1;         							@(posedge clk);
			reset <= 0; d <= 1;   						@(posedge clk);
																@(posedge clk);
																@(posedge clk);	
			reset <= 1;					               @(posedge clk);	
			reset <= 0; d <= 0;							@(posedge clk);	
																@(posedge clk);		
																@(posedge clk);	
			$stop; //end simulation							
							
		end //initial
		
endmodule	