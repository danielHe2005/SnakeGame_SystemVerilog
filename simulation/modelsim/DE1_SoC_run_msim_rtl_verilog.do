transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/Tarta/Downloads/KeyboardFiles {C:/Users/Tarta/Downloads/KeyboardFiles/keyboard_inner_driver.v}
vlog -vlog01compat -work work +incdir+C:/Users/Tarta/Downloads/KeyboardFiles {C:/Users/Tarta/Downloads/KeyboardFiles/keyboard_press_driver.v}
vlog -sv -work work +incdir+C:/labs/ledDriverTest/fsm {C:/labs/ledDriverTest/fsm/snakeHead.sv}
vlog -sv -work work +incdir+C:/labs/ledDriverTest/fsm {C:/labs/ledDriverTest/fsm/LFSR_8bit.sv}
vlog -sv -work work +incdir+C:/labs/ledDriverTest/fsm {C:/labs/ledDriverTest/fsm/gridLight.sv}
vlog -sv -work work +incdir+C:/labs/ledDriverTest/fsm {C:/labs/ledDriverTest/fsm/dFlipFlop.sv}
vlog -sv -work work +incdir+C:/labs/ledDriverTest/fsm {C:/labs/ledDriverTest/fsm/countDown.sv}
vlog -sv -work work +incdir+C:/labs/ledDriverTest/fsm {C:/labs/ledDriverTest/fsm/controller.sv}
vlog -sv -work work +incdir+C:/Users/Tarta/Downloads/led_driver {C:/Users/Tarta/Downloads/led_driver/clock_divider.sv}
vlog -sv -work work +incdir+C:/Users/Tarta/Downloads/led_driver {C:/Users/Tarta/Downloads/led_driver/LEDDriver.sv}
vlog -sv -work work +incdir+C:/labs/redoneLEDTEST {C:/labs/redoneLEDTEST/bcdCounter.sv}
vlog -sv -work work +incdir+C:/labs/redoneLEDTEST {C:/labs/redoneLEDTEST/bcdControl.sv}
vlog -sv -work work +incdir+C:/labs/redoneLEDTEST {C:/labs/redoneLEDTEST/hexControl.sv}
vlog -sv -work work +incdir+C:/labs/redoneLEDTEST/output_files {C:/labs/redoneLEDTEST/output_files/keyboardTranslate.sv}
vlog -sv -work work +incdir+C:/Users/Tarta/Downloads/led_driver {C:/Users/Tarta/Downloads/led_driver/DE1_SoC.sv}

