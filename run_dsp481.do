
vlib work 
vlog  instantiation_model.v project_model.v model_tb.v
vsim -voptargs=+acc work.DSP48A1_tb 
add wave * 
run -all 
#quit -sim