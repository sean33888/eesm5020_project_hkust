################################################################################
# Filename: divider.constraints.tcl
# Author: ZHU Jingyang
# Email: jzhuak@connect.ust.hk
# Affiliation: Hong Kong University of Science and Technology
# -------------------------------------------------------------------------------
# This is the template constraint script for ELEC5160/EESM5020.
################################################################################

################################################################################
# Timing constraint
################################################################################
# Critical path constraint: set the desired clock frequency
create_clock -period 10.0 [get_ports clk]

# Input delay and output delay
set_input_delay -max 2.7 -clock clk \
  [remove_from_collection [all_inputs] [get_ports clk]]
set_output_delay -max 0.8 -clock clk [all_outputs]
set_input_delay -min 2.3 -clock clk \
  [remove_from_collection [all_inputs] [get_ports clk]]
set_output_delay -min 1.2 -clock clk [all_outputs]
################################################################################
# Enviornement attribute constraint
################################################################################
# Load on the output ports
set_load 1 [all_outputs]

# Input transition time on all inputs except clock
set_input_transition 0.1 \
  [remove_from_collection [all_inputs] [get_ports clk]]
