/* this module controls many of the functions of the snake game, including instantiating and updating the fsms controlling each LED on the 16x16 LED array, determining whether a collision has occured,
and regulating the decoding of input row and column locations of the apple and snakes into coordinates that will update the fsms controlling the LEDs
Parameters:
	clk: the clock that controls the sequential logic in the circuit
	reset: resets the game state back to its starting state
	appleCol: a 4 bit input that tells the controller the column that the apple is currently residing in
	appleRow: a 4 bit input that tells the controller the row that the apple is currently residing in
	snakeCol: a 4 bit input that tells the controller the column that the snake's head is currently residing in
	snakeRow: a 4 bit input that tells the controller the row that the snake's head is currently residing in
	redLED: a 16x16 double array output that will drive the red LEDs on the 16x16 LED array peripheral
	greenLED: a 16x16 double array output that will drive the green LEDs on the 16x16 LED array peripheral
	bcdEna: an output that directs the bcdCounters when to increment their count
	gameCollide: an output that tells the rest of the circuit when a game-ending collision has occured
*/
module controller(clk, reset, appleCol, appleRow, snakeCol, snakeRow, redLED, greenLED, bcdEna, gameCollide);
	input logic reset;
	input logic clk;
	// a total of 8 bits specifying the row and column that the snake head resides in, and 8 bits specifying the location that the apple resides in
	input logic [3:0] snakeCol, snakeRow, appleCol, appleRow;
	// the array of output LED logic
	output logic [15:0] [15:0] redLED, greenLED;
	// a total of 8 bits specifying the row and column that the apple resides in
	logic [3:0] prevSnakeRow, prevSnakeCol, prevAppleRow, prevAppleCol;
	// the current coordinates on the LxW (length by width) grid specifying the location of the head and apple, only one literal within each array should ever be active
	logic [15:0] [15:0] headCoordinates, appleCoordinates; 
	output logic gameCollide, bcdEna;
	
	
	logic [7:0] length;
	logic enable;
	
				
	// coordinate decoder and collision detection system
	always_ff@(posedge clk)begin
		if(reset)begin
			headCoordinates <='0;
			length <= 8'd2;
			gameCollide <= 0;
		end else begin
			headCoordinates[snakeRow][snakeCol] <= 1;
			// means that the snakeHead has moved
			if((snakeRow != prevSnakeRow)|(snakeCol != prevSnakeCol))begin
				headCoordinates[prevSnakeRow][prevSnakeCol] <= 0;
				gameCollide <= greenLED[snakeRow][snakeCol];
			end
			prevSnakeRow <= snakeRow;
			prevSnakeCol <= snakeCol;
			appleCoordinates[appleRow][appleCol] <= 1;
			if((appleRow != prevAppleRow)|(appleCol != prevAppleCol))begin
				appleCoordinates[prevAppleRow][prevAppleCol] <= 0;
			end
			prevAppleRow <= appleRow;
			prevAppleCol <= appleCol;
			if(headCoordinates == appleCoordinates)begin
				length <= length + 1;
				bcdEna <= 1;
			end else begin
				bcdEna <= 0;
			end
		end	
	end
	
		
	//generates all 256 LEDs on the LED array
	genvar i, j;
	generate
		for (i = 0; i <= 4'd15; i = i + 1)begin: ledArray
			for (j = 0; j <= 4'd15; j = j + 1)begin: ledArray2
				gridLight LED(.clk(clk), .Reset(reset), .gameEnd(gameCollide), .headAtLED(headCoordinates[i][j]), .appleAtLED(appleCoordinates[i][j]), .snakeLength(length), .LEDGreen(greenLED[i][j]), .LEDRed(redLED[i][j]));
			end
		end
	endgenerate
endmodule

module controller_testbench();
	logic reset;
	logic clk;
	logic gameCollide, bcdEna;
	logic [3:0] snakeCol, snakeRow, appleCol, appleRow;
	logic [15:0][15:0] redLED, greenLED;
	
	controller dut(.clk, .reset, .gameCollide, .appleCol, .appleRow, .snakeCol, .snakeRow, .redLED, .greenLED, .bcdEna);
	
	parameter clock_period = 100;
		
	initial begin
		clk <= 0;
		forever #(clock_period /2) clk <= ~clk;
	end //initial
	integer i;
	initial begin
		reset <= 1; snakeCol <= 5; snakeRow <= 5;	      							@(posedge clk);
															@(posedge clk);
															@(posedge clk);
															@(posedge clk);
															@(posedge clk);
		reset <= 0;									@(posedge clk);
		for(i = 0; i < 4'd10; i++)begin
			snakeCol <=snakeCol + 1; @(posedge clk);
		end
		$stop;
	end
endmodule
	