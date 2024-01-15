# Imposta il percorso del progetto
set project_path "C:/Users/manue/Desktop/SDI/butterfly"

# Imposta il nome del file VHDL principale
set main_file "fft.vhd"

# Imposta il nome del file VHDL di testbench
set testbench_file "fft16x16_tb.vhd"

# Imposta il nome della libreria
set library_name work

# Imposta il percorso di uscita per i file compilati
set output_path "$project_path/work"

# Lista dei file aggiuntivi da compilare
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

# Cambia la directory di lavoro
cd $project_path

# Crea la libreria
vlib $library_name

# Compila il file VHDL principale
vcom -work $library_name $main_file

# Compila il file VHDL di testbench
vcom -work $library_name $testbench_file

# Compila gli altri file
foreach file $additional_files {
    vcom -work $library_name $file
}

# Esegui la simulazione
vsim -c $library_name.fft16x16_tb

# Esegui la simulazione per 10us
run 10us

# Esci da ModelSim
quit -f
