/* regulates the three digit counter on the DE1_SoC by creating a chained counter system that counts up to 999
Parameters:
	clk: the clock that drives the sequential logic in the system
	reset: resets all the internal bcd counters back to zero
	ena: input that enables the one's place counter to start counting
	q: a 12 bit output for three decimal digits, 4 bits allocated per digit
*/
module bcdControl(clk, reset, ena, q);
	 input logic clk, reset;
	 input logic ena;
	 logic [2:1] enaChain;
	 output logic [11:0] q;
	 logic [7:0] qPrev;
	 
    bcdCounter ones(clk,reset,ena,q[3:0]);
    bcdCounter tens(clk,reset,enaChain[1],q[7:4]);
    bcdCounter hundreds(clk,reset,enaChain[2],q[11:8]);
	 
	 always_ff@(posedge clk)begin
		qPrev[3:0] <= q[3:0];
		qPrev[7:4] <= q[7:4];
	 end
	 
    always_comb begin
		if(reset)begin
			enaChain = 0;
		end else begin
			enaChain[1] = (q[3:0] == 0)&(qPrev[3:0] == 9);
			enaChain[2] = (q[7:4] == 0)&(qPrev[7:4] == 9)&enaChain[1];
		end
    end
endmodule

module bcdControl_testbench();
	logic clk, reset, ena; 
	logic [11:0] q;
	
	bcdControl dut(.clk, .reset, .ena, .q);
	
	parameter clock_period = 100;
	integer i;
		
	initial begin
		clk <= 0;
		forever #(clock_period /2) clk <= ~clk;
	end //initial
		
	initial begin
		reset <= 1; @(posedge clk);
		reset <= 0; @(posedge clk);
		for(i = 0; i < 2**12; i++) begin
			ena <= 1;  @(posedge clk);
		end
		$stop;
	end
endmodule 