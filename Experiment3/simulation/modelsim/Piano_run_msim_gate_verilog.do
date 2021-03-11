transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {Piano.vo}

vlog -vlog01compat -work work +incdir+D:/QuartusProjects/Experiment3 {D:/QuartusProjects/Experiment3/Testbench_Piano.v}

vsim -t 1ps -L maxii_ver -L gate_work -L work -voptargs="+acc"  PianoTest

add wave *
view structure
view signals
run -all
