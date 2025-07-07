#######################################################
#                                                     
#  Encounter Command Logging File                     
#  Created on Mon Apr 21 17:30:49 2025                
#                                                     
#######################################################

#@(#)CDS: Encounter v14.26-s039_1 (64bit) 07/15/2015 11:34 (Linux 2.6.18-194.el5)
#@(#)CDS: NanoRoute v14.26-s022 NR150713-1956/14_26-UB (database version 2.30, 267.6.1) {superthreading v1.25}
#@(#)CDS: CeltIC v14.26-s013_1 (64bit) 07/14/2015 03:32:40 (Linux 2.6.18-194.el5)
#@(#)CDS: AAE 14.26-s007 (64bit) 07/15/2015 (Linux 2.6.18-194.el5)
#@(#)CDS: CTE 14.26-s010_1 (64bit) Jul 15 2015 01:38:12 (Linux 2.6.18-194.el5)
#@(#)CDS: CPE v14.26-s026
#@(#)CDS: IQRC/TQRC 14.2.2-s217 (64bit) Wed Apr 15 23:10:24 PDT 2015 (Linux 2.6.18-194.el5)

set_global _enable_mmmc_by_default_flow      $CTE::mmmc_default
suppressMessage ENCEXT-2799
set init_verilog ../syn/results/encoder.mapped.v
set init_mmmc_file scripts/mmc2.view
set init_lef_file /afs/ee.ust.hk/sun4x_56/usr/eelocal/tsmc_icdc/tsmc180/tsmc180_MS_RF_G/SC/tcb018g3d3/Rev280a/Back_End/lef/tcb018g3d3_280a/lef/tcb018g3d3_6lm.lef
set init_pwr_net VDD
set init_gnd_net VSS
init_design
win
