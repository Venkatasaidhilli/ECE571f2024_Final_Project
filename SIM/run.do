# Compile the design files
vlog -timescale 1ns/1ps ../RTL/i2c_pkg.sv ../RTL/module.sv ../RTL/testbench.sv

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
