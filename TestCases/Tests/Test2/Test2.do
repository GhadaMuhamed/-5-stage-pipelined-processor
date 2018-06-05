
vsim -gui work.master

add wave -position insertpoint  \
sim:/master/Clk \
sim:/master/Rst \
sim:/master/interuupt \
sim:/master/flagC \
sim:/master/decodeStage/controlunit/outSignal \
sim:/master/ACK
mem load -i C:/Users/ghada/Desktop/instr.mem  /master/fetchstage/ram0/ram
mem load -i C:/Users/ghada/Desktop/data.mem /master/stagememStage/memory/memoryEntry
add wave -position insertpoint sim:/master/FEDE/*
add wave -position insertpoint sim:/master/DEEX/*
add wave -position insertpoint sim:/master/EXMEM/*
add wave -position insertpoint sim:/master/MEMWB/*
add wave -position insertpoint sim:/master/decodeStage/registerfile/r0/q
add wave -position insertpoint sim:/master/decodeStage/registerfile/r1/q
add wave -position insertpoint sim:/master/decodeStage/registerfile/r2/q
add wave -position insertpoint sim:/master/decodeStage/rst1
add wave -position insertpoint sim:/master/decodeStage/rst2

add wave -position insertpoint sim:/master/fetchstage/pc_out
sim:/master/Reg1

force -freeze sim:/master/Clk 0 0, 1 {50 ps} -r 100
force -freeze sim:/master/Rst 1 0
force -freeze sim:/master/interuupt 0 0
run
force -freeze sim:/master/Rst 0 0
run
run
run
run
run
run
run
run
run
run
run
run
force -freeze sim:/master/interuupt 1 0
run
force -freeze sim:/master/interuupt 0 0
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
