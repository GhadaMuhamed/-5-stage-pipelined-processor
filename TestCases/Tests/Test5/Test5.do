
vsim -gui work.master
# vsim -gui work.master
# Start time: 09:29:45 on May 05,2018
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading work.master(flowmaster)
# Loading ieee.numeric_std(body)
# Loading work.excute(archex)
# Loading ieee.std_logic_arith(body)
# Loading ieee.std_logic_unsigned(body)
# Loading work.alu(archalu)
# Loading work.dff(archregister)
# Loading work.fulladder(archfulladder)
# Loading work.adder(archadder)
# Loading work.mux2(archmux)
# Loading work.ndffrising(a_my_ndff)
# Loading work.increment(incarch)
# Loading work.decodeforwardingunit(forwarding)
# Loading work.hazarddetectionunit(detection)
# Loading work.reghazard(hazard)
# Loading work.fetch(data_fetch)
# Loading work.mux4(archmux)
# Loading work.regpc(my_reg)
# Loading work.ram(sync_ram)
# Loading work.my_ndfffalling(a_my_ndff)
# Loading work.decode(flowdecode)
# Loading work.control(flowcontrol)
# Loading work.registerfiledecoding(dataflow)
# Loading work.my_ndffrising(a_my_ndff)
# Loading work.memstage(memstagearch)
# Loading work.decrement(decarch)
# Loading work.memoryforwardingunit(forwardingm)
# Loading work.mem(memarch)
# Loading work.intreg(intstore)
# Loading work.stackreg(stackregflow)
add wave -position insertpoint  \
sim:/master/Clk \
sim:/master/Rst \
sim:/master/RESET \
sim:/master/interuupt \
sim:/master/regreset \
sim:/master/regint

mem load -i C:/Users/Omnia/source/repos/Project4/Project4/instr.mem /master/fetchstage/ram0/ram
mem load -i C:/Users/Omnia/source/repos/Project4/Project4/data.mem /master/stagememStage/memory/memoryEntry
# (vsim-3632) Illegal character '5' for radix 'binary' on line 4 of file "C:/Users/Omnia/source/repos/Project4/Project4/data.mem".
add wave -position insertpoint sim:/master/FEDE/q
add wave -position insertpoint sim:/master/DEEX/q
add wave -position insertpoint sim:/master/EXMEM/q
add wave -position insertpoint sim:/master/MEMWB/q
add wave -position insertpoint sim:/master/decodeStage/registerfile/r0/q
add wave -position insertpoint sim:/master/decodeStage/registerfile/r1/q
 add wave -position insertpoint sim:/master/decodeStage/registerfile/r2/q
add wave -position insertpoint sim:/master/decodeStage/registerfile/r3/q
add wave -position insertpoint sim:/master/decodeStage/registerfile/r4/q
add wave -position insertpoint sim:/master/decodeStage/registerfile/r5/q
#add wave -position insertpoint sim:/master/excuteStage/ALu_Block/A
# add wave -position insertpoint sim:/master/excuteStage/ALu_Block/B
#add wave -position insertpoint sim:/master/sampledecodeForwardingUnit/EMwbDst
#add wave -position insertpoint sim:/master/samplehazardDetectionUnit/stall
#add wave -position insertpoint sim:/master/sampledecodeForwardingUnit/outSrc
#add wave -position insertpoint sim:/master/sampledecodeForwardingUnit/outdst
add wave -position insertpoint sim:/master/fetchstage/inst
add wave -position insertpoint sim:/master/excuteStage/outOutport
add wave -position insertpoint sim:/master/excuteStage/outflages
#add wave -position insertpoint sim:/master/decodeStage/outsignal
##add wave -position insertpoint sim:/master/decodeStage/data1
#add wave -position insertpoint sim:/master/decodeStage/data2
add wave -position insertpoint sim:/master/fetchstage/pc_out
#add wave -position insertpoint sim:/master/fetchstage/ramout
force -freeze sim:/master/Clk 0 0, 1 {50 ps} -r 100
force -freeze sim:/master/Rst 1 0
force -freeze sim:/master/RESET 0 0
force -freeze sim:/master/interuupt 0 0
force -freeze sim:/master/regreset 0000000101 0
force -freeze sim:/master/regint 0011011100 0
run
force -freeze sim:/master/Rst 0 0
force -freeze sim:/master/reset 1 0
run
force -freeze sim:/master/reset 0
run
# fede 362503
run
#fede 430089 deex 633318697648388
run
#fede 479520 deex 1266637395263748 exmem 3470316797970
run
#fede 479520 deex  exmem 3470316797970 memwb
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

