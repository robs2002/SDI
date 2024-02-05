set project_path "C:/Users/manue/Desktop/SDI/butterfly" # path del progetto modelsim
set main_file "fft.vhd" # file che utilizzo per descrivere il blocco in esame
set testbench_file "fft16x16_tb.vhd" # file di testbench
set library_name work # libreria di modelsim
set output_path "$project_path/work" # path delle uscite
set additional_files {
    reg.vhd
    adder.vhd
    subtractor.vhd
    multiplier.vhd
    round.vhd              # file che creano il file principale
    microrom.vhd
    datapath.vhd
    sequencer.vhd
    butterfly_element.vhd
}

cd $project_path # cambio la directory a quella del progetto

vlib $library_name # creo la libreria

vcom -work $library_name $main_file # compilo il file principale
vcom -work $library_name $testbench_file # compilo il file di testbench
foreach file $additional_files {
    vcom -work $library_name $file   # compilo tutti i file che creano il principale
}
vsim -c $library_name.fft16x16_tb # simulo il file di testbench

run 10us # simulazione per 10 microsecondi

quit -f # chiudo modelsim
