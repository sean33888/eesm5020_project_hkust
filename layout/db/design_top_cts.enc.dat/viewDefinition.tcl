if {![namespace exists ::IMEX]} { namespace eval ::IMEX {} }
set ::IMEX::dataVar [file dirname [file normalize [info script]]]
set ::IMEX::libVar ${::IMEX::dataVar}/libs

create_library_set -name wc\
   -timing\
    [list ${::IMEX::libVar}/mmmc/tcb018g3d3wc_ccs.lib]
create_op_cond -name wc -library_file ${::IMEX::libVar}/mmmc/tcb018g3d3wc_ccs.lib -P 1 -V 2.97 -T 125
create_rc_corner -name CWORST_T\
   -cap_table ${::IMEX::libVar}/mmmc/t018lo_1p6m_typical.captable\
   -preRoute_res 1.3\
   -postRoute_res {1.3 1.3 1.3}\
   -preRoute_cap 1.3\
   -postRoute_cap {1.3 1.3 1.3}\
   -postRoute_xcap {1.3 1.3 1.3}\
   -preRoute_clkres 0\
   -preRoute_clkcap 0\
   -T 125
create_delay_corner -name wc_CWORST_T\
   -library_set wc\
   -rc_corner CWORST_T
create_constraint_mode -name SDC\
   -sdc_files\
    [list ${::IMEX::libVar}/mmmc/encoder.mapped.sdc]
create_analysis_view -name wc -constraint_mode SDC -delay_corner wc_CWORST_T
set_analysis_view -setup [list wc] -hold [list wc]
