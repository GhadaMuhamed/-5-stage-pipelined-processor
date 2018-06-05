vsim -gui work.master
add wave -position insertpoint  \
sim:/master/Clk \
sim:/master/Rst \
sim:/master/interuupt \
sim:/master/flagC \
sim:/master/ACK
mem load -i C:/Users/ghada/Desktop/instr.mem  /master/fetchstage/ram0/ram
mem load -i C:/Users/ghada/Desktop/data.mem /master/stagememStage/memory/memoryEntry
add wave -position insertpoint  \
sim:/master/flagC \
sim:/master/flagN \
sim:/master/flagZ
add wave -position insertpoint  \
sim:/master/excuteStage/outOutport
add wave -position insertpoint  \
sim:/master/decodeStage/inportdata
add wave -position insertpoint sim:/master/decodeStage/registerfile/r0/q
add wave -position insertpoint sim:/master/decodeStage/registerfile/r1/q
add wave -position insertpoint sim:/master/decodeStage/registerfile/r2/q
add wave -position insertpoint sim:/master/decodeStage/registerfile/r3/q
add wave -position insertpoint sim:/master/decodeStage/registerfile/r4/q
add wave -position insertpoint sim:/master/decodeStage/registerfile/r5/q
add wave -position insertpoint sim:/master/fetchstage/pc_out

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
run
run
force -freeze sim:/master/decodeStage/inportdata 0000000000000100 0
run
run
run
run
run
run