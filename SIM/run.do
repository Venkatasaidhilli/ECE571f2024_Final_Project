# Compile the design files
vlog RTL/module.sv
vlog RTL/testbench.sv 
vlog RTL/i2c_pkg.sv

# Simulate the top-level testbench
vsim -voptargs="+acc" work.i2c_top_tb

# Add specific signals to the waveform
add wave -position insertpoint sim:/i2c_top_tb/clk
add wave -position insertpoint sim:/i2c_top_tb/rst
add wave -position insertpoint sim:/i2c_top_tb/newd
add wave -position insertpoint sim:/i2c_top_tb/op
add wave -position insertpoint sim:/i2c_top_tb/addr
add wave -position insertpoint sim:/i2c_top_tb/din
add wave -position insertpoint sim:/i2c_top_tb/dout
add wave -position insertpoint sim:/i2c_top_tb/busy
add wave -position insertpoint sim:/i2c_top_tb/ack_err
add wave -position insertpoint sim:/i2c_top_tb/done

# Run the simulation
run -all

# Save the waveform data for post-simulation analysis
wlfsave simulation_waveform.wlf
