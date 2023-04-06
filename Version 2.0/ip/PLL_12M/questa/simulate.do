onbreak {quit -f}
onerror {quit -f}

vsim  -lib xil_defaultlib PLL_12M_opt

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {PLL_12M.udo}

run 1000ns

quit -force