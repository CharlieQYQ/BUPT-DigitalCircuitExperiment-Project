transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/QuartusProjects/Experiment {D:/QuartusProjects/Experiment/ARKLED_2020.11.15.v}

vlog -vlog01compat -work work +incdir+D:/QuartusProjects/Experiment {D:/QuartusProjects/Experiment/ARKLED_TestBench.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  ARKLED_TestBench

add wave *
view structure
view signals
run -all
