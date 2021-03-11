transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {Piano.vo}

vlog -vlog01compat -work work +incdir+D:/QuartusProjects/Experiment {D:/QuartusProjects/Experiment/ARKLED_TestBench.v}

vsim -t 1ps -L altera_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L gate_work -L work -voptargs="+acc"  ARKLED_TestBench

add wave *
view structure
view signals
run -all
