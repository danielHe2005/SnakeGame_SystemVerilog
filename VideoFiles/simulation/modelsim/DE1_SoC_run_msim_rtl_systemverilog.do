transcript on
if ![file isdirectory DE1_SoC_iputf_libs] {
	file mkdir DE1_SoC_iputf_libs
}

if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

###### Libraries for IPUTF cores 
###### End libraries for IPUTF cores 
###### MIF file copy and HDL compilation commands for IPUTF cores 


vlog "C:/Users/Tarta/Downloads/VideoFiles/CLOCK25_PLL_sim/CLOCK25_PLL.vo"

vlog -vlog01compat -work work +incdir+C:/Users/Tarta/Downloads/VideoFiles {C:/Users/Tarta/Downloads/VideoFiles/altera_up_avalon_video_vga_timing.v}
vlog -sv -work work +incdir+C:/Users/Tarta/Downloads/VideoFiles {C:/Users/Tarta/Downloads/VideoFiles/DE1_SoC.sv}
vlog -sv -work work +incdir+C:/Users/Tarta/Downloads/VideoFiles {C:/Users/Tarta/Downloads/VideoFiles/video_driver.sv}

