@echo off
set xv_path=E:\\Xilinx2\\Vivado\\2017.1\\bin
call %xv_path%/xelab  -wto 4e2013ae107d43a6af39e82c59ed3979 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot sim_counters_behav xil_defaultlib.sim_counters -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
