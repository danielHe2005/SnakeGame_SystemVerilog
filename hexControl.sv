/* translates the bcd digit into a HEX code for the HEX displays
Parameters:
	q: the 4 bit bcd input
	hex: the 7 bit HEX code output
*/
module hexControl(q, hex);
	input logic [3:0] q;
	output logic [6:0] hex;
	always_comb begin
		case(q)
			0: hex = 7'b1000000;
			1: hex = 7'b1111001;
			2: hex = 7'b0100100;
			3: hex = 7'b0110000;
			4: hex = 7'b0011001;
			5: hex = 7'b0010010;
			6: hex = 7'b0000010;
			7: hex = 7'b1111000;
			8: hex = 7'b0000000;
			9: hex = 7'b0010000;
			default: hex = 7'b1000000;
		endcase
	end
endmodule 

module hexControl_testbench();
	logic [3:0] q;
	logic [6:0] hex;
	
	hexControl dut(.q, .hex);
	
	integer i;
		
	initial begin
		q = 0; #10;
		for(i = 0; i < 10; i++) begin
			q++; #10;
		end
	end
endmodule 