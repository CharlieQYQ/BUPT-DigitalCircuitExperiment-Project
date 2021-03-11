onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /PianoTest/CLK
add wave -noupdate -expand /PianoTest/Switch
add wave -noupdate -expand /PianoTest/Key
add wave -noupdate /PianoTest/ROW
add wave -noupdate /PianoTest/COL_RED
add wave -noupdate /PianoTest/COL_GREEN
add wave -noupdate /PianoTest/SEG
add wave -noupdate /PianoTest/SEG_Neg
add wave -noupdate /PianoTest/Beep
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {7771827174378 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {10643276595 ns}
