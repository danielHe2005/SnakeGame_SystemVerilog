# Snake And Apples Game (SystemVerilog)

This project implements a version of the Snake and Apples game that has the player controlling a snake to eat apples, with the snake continually growing until the game ends when the snake hits its own body. This implementation utilizes FSMs,
control modules and generate blocks in order to control how the apple moves, collision detection between apple and snake, how the snake moves, video and audio interfaces, and how the user inputs affect the gamestate.
The row and column positions within a 30x30 double matrix determine the positions of the various objects

---

## ⚙️ Features
- DE1_SoC.sv: toplevel module that connects the control ports, FSM datapaths, and various I/O support file and controls together
- VGA_coordinate.sv: translates the gamestate of the 16x16 GPIO LED board onto a VGA display by utilizing ratios and checking to see if an LED was lit on the board and how it corresponded to the playing field on the VGA displayat 480x480,
with each LED occupied 30x30 or 900 pixels on the VGA display
- snakeHead.sv: the finite state machine that takes in user inputs and outputs commands for the row position and column position of the snake head.
- gridLight.sv: the FSM that controls the LED output on the external GPIO-port 30x30 LED display connected to the DE1_SoC, with states for off, red if an apple is at the location, and green if the snake head or body is at the location.
- keyboardTranslate.sv: the FSM that, given a makeBreak signal and a valid outcode from the PS/2 keyboard (WASD and arrow keys for movement) will issue an output signal corresponding to up, left, right, or down to the rest of the system, translating user inputs to change the gamestate.

---

## 🧰 Tools
- **Language:** SystemVerilog/Verilog  
- **Simulation:** ModelSim 
- **Synthesis:** Intel Quartus Prime Lite  
- **Version Control:** Git / GitHub  

---

## 🧪 How to Run

Open in Quartus
Click "Start Analysis and Synthesis" Ctrl+K (for simulation purposes) or "Start Compilation" to generate the bitstream necessary for simulation on the Altera DE1_SoC board
Open ModelSim in order to check waveforms on testbench, or connect to a DE1_SoC board that is also connected via VGA to a monitor, PS/2 to a PS/2 keyboard, and via GPIO pins to a 30x30 LED board to play the game.
