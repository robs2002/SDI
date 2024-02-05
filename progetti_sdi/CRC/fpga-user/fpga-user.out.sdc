## Generated SDC file "fpga-user.out.sdc"

## Copyright (C) 2020  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and any partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel FPGA IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Intel and sold by Intel or its authorized distributors.  Please
## refer to the applicable agreement for further details, at
## https://fpgasoftware.intel.com/eula.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 20.1.0 Build 711 06/05/2020 SJ Lite Edition"

## DATE    "Sun Jul 19 12:40:44 2020"

##
## DEVICE  "10CL025YE144C8G"
##

#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3

#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {mainClk} -period 100.000 -waveform { 0.000 50.000 } [get_ports {mainClk}]

#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {myAltPll_inst|altpll_component|auto_generated|pll1|clk[0]} -source [get_pins {myAltPll_inst|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50/1 -multiply_by 1 -master_clock {mainClk} [get_pins {myAltPll_inst|altpll_component|auto_generated|pll1|clk[0]}] 

#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {myAltPll_inst|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {myAltPll_inst|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {myAltPll_inst|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {myAltPll_inst|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {myAltPll_inst|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {myAltPll_inst|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {myAltPll_inst|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {myAltPll_inst|altpll_component|auto_generated|pll1|clk[0]}]  0.020  


#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay  -clock [get_clocks {mainClk}]  5.000 [get_ports {reset}]
set_input_delay -add_delay  -clock [get_clocks {mainClk}]  5.000 [get_ports {mcuSpiCk}]
set_input_delay -add_delay  -clock [get_clocks {mainClk}]  5.000 [get_ports {mcuSpiCs}]

#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -clock {
	myAltPll_inst|altpll_component|auto_generated|pll1|clk[0]
} 5 [get_ports {
	hBusCk hBusCs
	hBusD[0] hBusD[1] hBusD[2] hBusD[3] hBusD[4] hBusD[5] hBusD[6] hBusD[7]
	hBusRst hBusRwds
	lsasBus[0] lsasBus[1] lsasBus[2] lsasBus[3] lsasBus[4] lsasBus[5] lsasBus[6] lsasBus[7]
	lsasBus[8] lsasBus[9] lsasBus[10] lsasBus[11] lsasBus[12] lsasBus[13] lsasBus[14] lsasBus[15]
	lsasBus[16] lsasBus[17] lsasBus[18] lsasBus[19] lsasBus[20] lsasBus[21] lsasBus[22] lsasBus[23]
	lsasBus[24] lsasBus[25] lsasBus[26] lsasBus[27] lsasBus[28] lsasBus[29] lsasBus[30] lsasBus[31]
	mcuSpiIo[0] mcuSpiIo[1] mcuSpiIo[2] mcuSpiIo[3]
}]

#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

