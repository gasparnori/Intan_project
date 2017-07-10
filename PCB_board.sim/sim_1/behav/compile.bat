@echo off
set xv_path=E:\\Xilinx2\\Vivado\\2017.1\\bin
echo "xvhdl -m64 --relax -prj sim_counters_vhdl.prj"
call %xv_path%/xvhdl  -m64 --relax -prj sim_counters_vhdl.prj -log xvhdl.log
call type xvhdl.log > compile.log
if "%errorlevel%"=="1" goto END
if "%errorlevel%"=="0" goto SUCCESS
:END
exit 1
:SUCCESS
exit 0
