/* this module controls the position of the snake's head
Parameters:
	clk: the clock that controls the DFFs within the module
	Reset: resets the snake's head position back to default
	move: a 4 bit input that determines which of the four directions the snake's head should be moving
	gameEnd: logic that tells the snake head to stop moving or accepting inputs
	rowPosition: the row position of the snake head
	colPosition: the column position of the snake head
*/
module snakeHead (clk, Reset, move, gameEnd, rowPosition, colPosition);
input logic clk, Reset, gameEnd;
input logic [3:0] move;
output logic [3:0] rowPosition, colPosition;

parameter colDefault = 4'd8;
parameter rowDefault = 4'd8; 

enum {Idle, Up, Down, Left, Right, End} ps, ns;
always_comb begin
	case (ps)
		Idle: if((move == 0)|(move[1])) ns = Idle;
				else if (move[0]) ns = Right;
				else if (move[2]) ns = Up;
				else if (move[3]) ns = Left;
				else ns = Idle;
		Right: if (gameEnd) ns = End; 
				else if ((move == 0)|(move[0])|(move[3])) ns = Right;
				else if (move[2]) ns = Up;
				else if (move[1]) ns = Down;
				else if (gameEnd) ns = End;
				else ns = Right;
		Left: if (gameEnd) ns = End;
				else if ((move == 0)|(move[0])|(move[3])) ns = Left;
				else if (move[2]) ns = Up;
				else if (move[1]) ns = Down;
				else if (gameEnd) ns = End;
				else ns = Left;
		Up: if (gameEnd) ns = End;
				else if ((move == 0)|(move[2])|(move[1])) ns = Up;
				else if (move[3]) ns = Left;
				else if (move[0]) ns = Right;
				else if (gameEnd) ns = End;
				else ns = Up;
		Down: if (gameEnd) ns = End;
				else if ((move == 0)|(move[2])|(move[1])) ns = Down;
				else if (move[3]) ns = Left;
				else if (move[0]) ns = Right;
				
				else ns = Down;
		End: ns = End;
	endcase
end

always_ff@(posedge clk)begin
	if(Reset)begin
		ps <= Idle;
		colPosition <= colDefault;
		rowPosition <= rowDefault;
	end else begin
		ps <= ns;
		colPosition <= (ns == Right)?(colPosition + 1):((ns == Left)?(colPosition - 1):colPosition);
		rowPosition <= (ns == Up)?(rowPosition + 1):((ns == Down)?(rowPosition - 1):rowPosition);
	end
end

endmodule

module snakeHead_testbench();

		logic clk, Reset, gameEnd;
		logic [3:0] move;
		logic [3:0] colPosition, rowPosition;
		
		snakeHead dut(.clk, .Reset, .move, .gameEnd, .rowPosition, .colPosition);
		
		//clock setup
		parameter clock_period = 100;
		
		initial begin
			clk <= 0;
			forever #(clock_period /2) clk <= ~clk;
		end //initial
		
		initial begin
		
			Reset <= 1;         							@(posedge clk);
			Reset <= 0; move[0] <= 1;   				@(posedge clk);
																@(posedge clk);
																@(posedge clk);	
			move[0] <= 0; move[1] <= 1;				@(posedge clk);	
																@(posedge clk);	
					move[1] <= 0; move[3] <= 1;		@(posedge clk);	
																@(posedge clk);
					move[3] <= 0; move[2] <= 1;		@(posedge clk);
																@(posedge clk);
																@(posedge clk);
					move[2] <= 0; move[0] <= 1;		@(posedge clk);
			Reset <= 1;						  				@(posedge clk);	
			$stop; //end simulation							
							
		end //initial
		
endmodule	