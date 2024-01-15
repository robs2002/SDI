set project_path "C:/Users/manue/Desktop/SDI/butterfly"
set main_file "fft.vhd"
set testbench_file "fft16x16_tb.vhd"
set library_name work
set output_path "$project_path/work"
set additional_files {
    reg.vhd
    adder.vhd
    subtractor.vhd
    multiplier.vhd
    round.vhd
    microrom.vhd
    datapath.vhd
    sequencer.vhd
    butterfly_element.vhd
}

cd $project_path

vlib $library_name

vcom -work $library_name $main_file
vcom -work $library_name $testbench_file
foreach file $additional_files {
    vcom -work $library_name $file
}
vsim -c $library_name.fft16x16_tb

run 10us

quit -f
