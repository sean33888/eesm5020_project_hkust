verdiSetActWin -dock widgetDock_<Decl._Tree>
simSetSimulator "-vcssv" -exec \
           "/dfs/usrhome/kjyu/Desktop/eesm5020/design_project/layout_sim/simv" \
           -args \
           "-ucli +PLAINTEXT=/dfs/usrhome/kjyu/Desktop/eesm5020/design_project/tb/tc_data/plaintext_sanity.txt +PARAM=/dfs/usrhome/kjyu/Desktop/eesm5020/design_project/tb/tc_data/param_sanity.txt"
debImport "-dbdir" \
          "/dfs/usrhome/kjyu/Desktop/eesm5020/design_project/layout_sim/simv.daidir"
debLoadSimResult \
           /dfs/usrhome/kjyu/Desktop/eesm5020/design_project/layout_sim/waves.fsdb
wvCreateWindow
verdiWindowResize -win $_Verdi_1 "820" "442" "900" "700"
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
wvSelectGroup -win $_nWave2 {G1}
verdiSetActWin -win $_nWave2
verdiWindowResize -win $_Verdi_1 "820" "442" "1319" "700"
verdiWindowResize -win $_Verdi_1 "572" "285" "1319" "1007"
srcHBSelect "tb_hybrid_chaotic_encryption.clk_gen_inst" -win $_nTrace1
verdiSetActWin -dock widgetDock_<Inst._Tree>
srcHBSelect "tb_hybrid_chaotic_encryption.uut1" -win $_nTrace1
srcHBSelect "tb_hybrid_chaotic_encryption.uut1" -win $_nTrace1
srcSetScope "tb_hybrid_chaotic_encryption.uut1" -delim "." -win $_nTrace1
srcHBSelect "tb_hybrid_chaotic_encryption.uut1" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "rst_n" -line 24010 -pos 1 -win $_nTrace1
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
srcDeselectAll -win $_nTrace1
srcSelect -signal "clk" -line 24009 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "rst_n" -line 24010 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "key_valid_in" -line 24012 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "key" -line 24014 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "plaintext_valid_in" -line 24013 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "plaintext" -line 24011 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "ciphertext_valid" -line 24016 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "ciphertext" -line 24015 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
wvSetPosition -win $_nWave2 {("G2" 0)}
verdiSetActWin -win $_nWave2
verdiSetActWin -dock widgetDock_<Inst._Tree>
srcHBSelect "tb_hybrid_chaotic_encryption.uut2" -win $_nTrace1
srcSetScope "tb_hybrid_chaotic_encryption.uut2" -delim "." -win $_nTrace1
srcHBSelect "tb_hybrid_chaotic_encryption.uut2" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "clk" -line 24009 -pos 1 -win $_nTrace1
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "rst_n" -line 24010 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "key_valid_in" -line 24012 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "key" -line 24014 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "plaintext_valid_in" -line 24013 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "plaintext" -line 24011 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "ciphertext_valid" -line 24016 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "ciphertext" -line 24015 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 0
verdiSetActWin -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
verdiWindowResize -win $_Verdi_1 "259" "355" "2001" "1007"
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvSetCursor -win $_nWave2 1155576.574097 -snap {("G1" 1)}
