# 
# Synthesis run script generated by Vivado
# 

set_param xicom.use_bs_reader 1
create_project -in_memory -part xc7a15tcpg236-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir E:/Nora/Xilinx/mux_adc_intan_simplified/PCB_board/PCB_board.cache/wt [current_project]
set_property parent.project_path E:/Nora/Xilinx/mux_adc_intan_simplified/PCB_board/PCB_board.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language VHDL [current_project]
set_property board_part digilentinc.com:cmod_a7-15t:part0:1.1 [current_project]
set_property ip_output_repo e:/Nora/Xilinx/mux_adc_intan_simplified/PCB_board/PCB_board.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_vhdl -library xil_defaultlib {
  E:/Nora/Xilinx/mux_adc_intan_simplified/PCB_board/PCB_board.srcs/sources_1/new/commands.vhd
  E:/Nora/Xilinx/mux_adc_intan_simplified/PCB_board/PCB_board.srcs/sources_1/new/mux_adc_block.vhd
  E:/Nora/Xilinx/mux_adc_intan_simplified/PCB_board/PCB_board.srcs/sources_1/new/counters.vhd
}
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc E:/Nora/Xilinx/mux_adc_intan_simplified/PCB_board/PCB_board.srcs/constrs_1/new/constr.xdc
set_property used_in_implementation false [get_files E:/Nora/Xilinx/mux_adc_intan_simplified/PCB_board/PCB_board.srcs/constrs_1/new/constr.xdc]


synth_design -top SPI_counter -part xc7a15tcpg236-1


write_checkpoint -force -noxdef SPI_counter.dcp

catch { report_utilization -file SPI_counter_utilization_synth.rpt -pb SPI_counter_utilization_synth.pb }
