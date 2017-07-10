@echo off
set xv_path=E:\\Xilinx2\\Vivado\\2017.1\\bin
call %xv_path%/xsim sim_counters_behav -key {Behavioral:sim_1:Functional:sim_counters} -tclbatch sim_counters.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
