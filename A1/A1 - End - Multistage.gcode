;=== Bambu Lab A1 End of print G-code for multi-stage prints ===
;=== Based on Orca Slicer default G-code =======================
;=== Original date: 20231229 ===================================
;=== Modified date: 20250105 ===================================
;=== https://github.com/frankysan/Bambu_AMS-less ===============

G392 S0 ; turn off nozzle clog detection

M400 ; wait for the movement buffer to clear
G92 E0 ; reset the extruder position to zero
G1 E-0.8 F1800 ; retract the filament slightly to prevent stringing
G1 Z{max_layer_z + 0.5} F900 ; raise the nozzle slightly above the maximum print height
G1 X0 Y{first_layer_center_no_wipe_tower[1]} F18000 ; move to a safe position in X and Y
G1 X-13.0 F3000 ; adjust the safe position further
