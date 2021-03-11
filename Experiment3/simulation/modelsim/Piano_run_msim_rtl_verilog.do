transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/QuartusProjects/Experiment3 {D:/QuartusProjects/Experiment3/Piano.v}

vlog -vlog01compat -work work +incdir+D:/QuartusProjects/Experiment3 {D:/QuartusProjects/Experiment3/Testbench_Piano.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L maxii_ver -L rtl_work -L work -voptargs="+acc"  PianoTest

add wave *
view structure
view signals
run -all
