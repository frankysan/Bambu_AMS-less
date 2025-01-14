;=== Bambu Lab A1 Start of print G-code with Adaptive Purge position ===
;=== Based on Orca Slicer default G-code ===============================
;=== Original date: 20240620 ===========================================
;=== Modified date: 20250113 ===========================================
;=== https://github.com/frankysan/Bambu_AMS-less =======================

G392 S0 ; Stops PWM fans by setting their speed to 0.
M9833.2 ; Custom command, likely specific to the printer or firmware, possibly related to a status change.
;M400 ; Ensures all buffered commands are executed before proceeding (commented out).
;M73 P1.717 ; Sets the progress of the print to 1.717% (commented out).

;===== start to heat heatbead&hotend==========
M1002 gcode_claim_action : 2 ; Displays "Heatbed preheating" message.
M1002 set_filament_type:{filament_type[initial_no_support_extruder]} ; Sets the filament type for the initial extruder (likely replaced dynamically by slicer).
M104 S140 ; Sets the nozzle temperature to 140°C.
M140 S[bed_temperature_initial_layer_single] ; Sets the heated bed temperature for the initial layer (value dynamically replaced).

;=====start printer sound ===================
M17 ; Enables motors (stepper motor power on).
M400 S1 ; Waits until all moves are complete before continuing.
M1006 S1 ; Starts a sequence of sound commands.
; Below are a series of custom sound tones. Each `M1006` line represents a tone or sequence.
M1006 A0 B10 L100 C37 D10 M60 E37 F10 N60
M1006 A0 B10 L100 C41 D10 M60 E41 F10 N60
M1006 A0 B10 L100 C44 D10 M60 E44 F10 N60
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N60
M1006 A43 B10 L100 C46 D10 M70 E39 F10 N80
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N80
M1006 A0 B10 L100 C43 D10 M60 E39 F10 N80
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N80
M1006 A0 B10 L100 C41 D10 M80 E41 F10 N80
M1006 A0 B10 L100 C44 D10 M80 E44 F10 N80
M1006 A0 B10 L100 C49 D10 M80 E49 F10 N80
M1006 A0 B10 L100 C0 D10 M80 E0 F10 N80
M1006 A44 B10 L100 C48 D10 M60 E39 F10 N80
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N80
M1006 A0 B10 L100 C44 D10 M80 E39 F10 N80
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N80
M1006 A43 B10 L100 C46 D10 M60 E39 F10 N80
M1006 W ; Ends the sound sequence.
M18 ; Disables motors (stepper motor power off).

;=====avoid end stop =================
G91 ; Switches to relative positioning.
G380 S2 Z40 F1200 ; Moves Z-axis up by 40mm at 1200mm/min speed.
G380 S3 Z-15 F1200 ; Moves Z-axis down by 15mm at the same speed.
G90 ; Switches back to absolute positioning.

;===== reset machine status =================
;M290 X39 Y39 Z8 ; Reset machine's tool head offsets (commented out).
M204 S6000 ; Sets maximum acceleration for printing and travel moves to 6000 mm/s².

M630 S0 P0 ; Custom command to disable a specific feature or system component.
G91 ; Switches to relative positioning.
M17 Z0.3 ; Reduces Z-axis motor current to 0.3A to avoid overheating.

G90 ; Switches back to absolute positioning.
M17 X0.65 Y1.2 Z0.6 ; Restores default motor currents for X, Y, and Z axes.
M960 S5 P1 ; Turns on the logo lamp at intensity level 5.
G90
M220 S100 ; Resets feedrate to 100% (default speed).
M221 S100 ; Resets extrusion flowrate to 100%.
M73.2R1.0 ; Resets the left time magnitude display to 1.0.
;M211 X0 Y0 Z0 ; Disables software endstops to prevent logic conflicts (commented out).

;====== cog noise reduction=================
M982.2 S1 ; Enables cog noise reduction mode for smoother motor operation.

M1002 gcode_claim_action : 13 ; Displays "Homing toolhead" message.

G28 X ; Homes the X-axis.
G91 ; Switches to relative positioning.
G1 Z5 F1200 ; Lifts the Z-axis by 5mm.
G90 ; Switches back to absolute positioning.
G0 X128 F30000 ; Moves to X=128mm at high speed (30000 mm/min).
G0 Y254 F3000 ; Moves to Y=254mm at slower speed (3000 mm/min).
G91 ; Switches to relative positioning.
G1 Z-5 F1200 ; Lowers the Z-axis by 5mm.

M109 S25 H140 ; Waits for the hotend to cool to 25°C and heats bed to 140°C.

M17 E0.3 ; Enables extruder motor with reduced current (0.3A).
M83 ; Switches extruder to relative positioning.
G1 E10 F1200 ; Extrudes 10mm of filament at 1200 mm/min speed.
G1 E-0.5 F30 ; Retracts 0.5mm of filament at 30 mm/min speed.
M17 D ; Enables additional motor (specific to this printer, possibly dual extruder-related).

G28 Z P0 T140 ; Homes the Z-axis with low precision, permitting nozzle temperatures up to 300°C.
M104 S{nozzle_temperature_initial_layer[initial_extruder]} ; Sets the nozzle temperature for the initial layer (value dynamically replaced).

M1002 judge_flag build_plate_detect_flag ; Evaluates the build plate detection flag.
M622 S1 ; Enables a custom feature or setting (exact functionality unknown).
    G39.4 ; Custom G-code command (specific to firmware).
    G90 ; Switches back to absolute positioning.
    G1 Z5 F1200 ; Lifts the Z-axis by 5mm.
M623 ; Ends the custom sequence started by M622.

;M400 ; Ensures all movements are complete before proceeding (commented out).
;M73 P1.717 ; Sets print progress to 1.717% (commented out).

;===== prepare print temperature and material ==========
M1002 gcode_claim_action : 24 ; Displays "Filament loading" message.

M400 ; Ensures all buffered commands are completed before continuing.
;G392 S1 ; Enables PWM fans (commented out).
M211 X0 Y0 Z0 ;turn off soft endstop ; Disables soft endstops to allow unrestricted movement.
M975 S1 ; turn on ; Enables specific feature or mode (likely custom firmware functionality).

G90 ; Switches to absolute positioning.
G1 X-28.5 F30000 ; Moves to X = -28.5mm at high speed (30000 mm/min).
G1 X-48.2 F3000 ; Moves to X = -48.2mm at slower speed (3000 mm/min).

M620 M ;enable remap ; Enables material remapping, used for AMS (Automatic Material Switching).
M620 S[initial_no_support_extruder]A ; Selects the initial extruder (with no support material) in AMS if present.
    M1002 gcode_claim_action : 4 ; Displays "Changing filament" message.
    M400 ; Waits for all commands to complete.
    M1002 set_filament_type:UNKNOWN ; Temporarily sets the filament type to UNKNOWN.
    M109 S[nozzle_temperature_initial_layer] ; Sets and waits for the nozzle temperature to reach the initial layer temperature.
    M104 S250 ; Sets the nozzle temperature to 250°C without waiting.
    M400 ; Waits for commands to complete.
    T[initial_no_support_extruder] ; Selects the specified extruder dynamically replaced by slicer.
    G1 X-48.2 F3000 ; Moves to X = -48.2mm at 3000 mm/min.
    M400 ; Waits for all commands to complete.

    M620.1 E F{filament_max_volumetric_speed[initial_no_support_extruder]/2.4053*60} T{nozzle_temperature_range_high[initial_no_support_extruder]} ; Configures extruder for volumetric speed and temperature range.
    M109 S250 ;set nozzle to common flush temp ; Sets and waits for the nozzle temperature to stabilize at 250°C.
    M106 P1 S0 ; Turns off fan 1 (P1).
    G92 E0 ; Resets the extruder position to zero.
    G1 E50 F200 ; Extrudes 50mm of filament at 200 mm/min.
    M400 ; Waits for all commands to complete.
    M1002 set_filament_type:{filament_type[initial_no_support_extruder]} ; Sets the filament type dynamically for the initial extruder.
M621 S[initial_no_support_extruder]A ; Confirms the selected extruder and material setup in AMS.

M109 S{nozzle_temperature_range_high[initial_no_support_extruder]} H300 ; Sets and waits for the nozzle to reach the high temperature range, up to 300°C.
G92 E0 ; Resets the extruder position to zero.
G1 E50 F200 ; Extrudes 50mm of filament at 200 mm/min.
M400 ; Waits for all commands to complete.
M106 P1 S178 ; Sets fan 1 (P1) speed to 178 (a moderate cooling level).
G92 E0 ; Resets the extruder position to zero.
G1 E5 F200 ; Extrudes 5mm of filament at 200 mm/min.
M104 S{nozzle_temperature_initial_layer[initial_no_support_extruder]} ; Sets the nozzle temperature dynamically for the initial layer.
G92 E0 ; Resets the extruder position to zero.
G1 E-0.5 F300 ; Retracts 0.5mm of filament at 300 mm/min.

G1 X-28.5 F30000 ; Moves to X = -28.5mm at high speed (30000 mm/min).
G1 X-48.2 F3000 ; Moves to X = -48.2mm at slower speed (3000 mm/min).
G1 X-28.5 F30000 ;wipe and shake ; Moves to X = -28.5mm to perform a "wipe and shake" action to clean the nozzle.
G1 X-48.2 F3000 ; Moves to X = -48.2mm at slower speed for the shake.
G1 X-28.5 F30000 ;wipe and shake ; Repeats the wipe and shake action.
G1 X-48.2 F3000 ; Moves to X = -48.2mm at slower speed for the shake.

;G392 S0 ; Disables PWM fans (commented out).

M400 ; Waits for all commands to complete.
M106 P1 S0 ; Turns off fan 1 (P1).

;===== prepare print temperature and material end =====

;M400 ; Ensures all movements are complete (commented out).
;M73 P1.717 ; Sets print progress to 1.717% (commented out).

;===== auto extrude cali start =========================
; This section performs an automatic extrusion calibration to ensure optimal extrusion settings.
M975 S1 ; Enables specific printer features or settings.
;G392 S1 ; Enables PWM fans (commented out).

G90 ; Switches to absolute positioning.
M83 ; Switches the extruder to relative mode for movement commands.
T1000 ; Sets extruder/tool to a high identifier (possibly for debugging or internal tracking).
G1 X-48.2 Y0 Z10 F10000 ; Moves the toolhead to X = -48.2, Y = 0, Z = 10mm at 10000 mm/min.
M400 ; Ensures all movements are completed before proceeding.
M1002 set_filament_type:UNKNOWN ; Temporarily sets the filament type to UNKNOWN.

M412 S1 ;  === turn on filament runout detection === ; Enables filament runout detection.
M400 P10 ; Pauses for 10ms to ensure detection systems are stable.
M620.3 W1; === turn on filament tangle detection === ; Activates filament tangle detection.
M400 S2 ; Waits for 2 seconds to stabilize detection systems.

M1002 set_filament_type:{filament_type[initial_no_support_extruder]} ; Restores the filament type dynamically for the current extruder.

;M1002 set_flag extrude_cali_flag=1 ; Sets a flag for extrusion calibration (commented out).
M1002 judge_flag extrude_cali_flag ; Evaluates the extrusion calibration flag.

M622 J1 ; Begins a calibration sequence for extrusion parameters.
    M1002 gcode_claim_action : 8 ; Displays "Calibrating extrusion" message.
    
    M109 S{nozzle_temperature[initial_extruder]} ; Sets and waits for the nozzle temperature dynamically based on the extruder settings.
    G1 E10 F{outer_wall_volumetric_speed/2.4*60} ; Extrudes 10mm of filament at a speed based on wall volumetric speed.
    M983 F{outer_wall_volumetric_speed/2.4} A0.3 H[nozzle_diameter]; cali dynamic extrusion compensation ; Performs dynamic extrusion compensation.
    
    M106 P1 S255 ; Turns on fan 1 (P1) at full speed (255).
    M400 S5 ; Waits for 5 seconds.
    G1 X-28.5 F18000 ; Moves to X = -28.5mm at 18000 mm/min.
    G1 X-48.2 F3000 ; Moves to X = -48.2mm at 3000 mm/min.
    G1 X-28.5 F18000 ;wipe and shake ; Wipes and shakes the nozzle by moving to X = -28.5mm at high speed.
    G1 X-48.2 F3000 ; Moves to X = -48.2mm at slower speed for the shake.
    G1 X-28.5 F12000 ;wipe and shake ; Repeats the wipe and shake action at a slightly slower speed.
    G1 X-48.2 F3000 ; Moves to X = -48.2mm at slower speed.
    M400 ; Ensures all movements are complete.
    M106 P1 S0 ; Turns off fan 1 (P1).
    
    M1002 judge_last_extrude_cali_success ; Checks if the last extrusion calibration was successful.
    M622 J0 ; Exits the calibration sequence if successful.
        M983 F{outer_wall_volumetric_speed/2.4} A0.3 H[nozzle_diameter]; cali dynamic extrusion compensation ; Repeats the dynamic extrusion compensation process.
        M106 P1 S255 ; Turns on fan 1 (P1) at full speed.
        M400 S5 ; Waits for 5 seconds.
        G1 X-28.5 F18000 ; Moves to X = -28.5mm at 18000 mm/min.
        G1 X-48.2 F3000 ; Moves to X = -48.2mm at 3000 mm/min.
        G1 X-28.5 F18000 ;wipe and shake ; Repeats the wipe and shake action at high speed.
        G1 X-48.2 F3000 ; Moves to X = -48.2mm at slower speed.
        G1 X-28.5 F12000 ;wipe and shake ; Performs the wipe and shake action at moderate speed.
        M400 ; Ensures all movements are complete.
        M106 P1 S0 ; Turns off fan 1 (P1).
    M623 ; Ends the extrusion calibration sequence.

    G1 X-48.2 F3000 ; Moves to X = -48.2mm at slower speed.
    M400 ; Ensures all commands are complete.
    M984 A0.1 E1 S1 F{outer_wall_volumetric_speed/2.4} H[nozzle_diameter] ; Applies fine adjustments to extrusion parameters.
    M106 P1 S178 ; Sets fan 1 (P1) to a moderate speed (178).
    M400 S7 ; Waits for 7 seconds.
    G1 X-28.5 F18000 ; Moves to X = -28.5mm at high speed (18000 mm/min).
    G1 X-48.2 F3000 ; Moves to X = -48.2mm at slower speed.
    G1 X-28.5 F18000 ;wipe and shake ; Repeats the wipe and shake process.
    G1 X-48.2 F3000 ; Moves to X = -48.2mm at slower speed.
    G1 X-28.5 F12000 ;wipe and shake ; Performs the wipe and shake action at a slightly slower speed.
    G1 X-48.2 F3000 ; Moves to X = -48.2mm at slower speed.
    M400 ; Ensures all commands are complete.
    M106 P1 S0 ; Turns off fan 1 (P1).
M623 ; end of "draw extrinsic para cali paint" ; Ends the parameter calibration sequence.

;G392 S0 ; Disables PWM fans (commented out).

;===== auto extrude cali end ========================
; End of the automatic extrusion calibration sequence.

;M400 ; Ensures all movements are complete (commented out).
;M73 P1.717 ; Sets print progress to 1.717% (commented out).

M104 S170 ; prepare to wipe nozzle ; Sets nozzle temperature to 170°C for wiping.
M106 S255 ; turn on fan ; Turns on the main fan at full speed.

;===== mech mode fast check start =====================
; This section performs a fast mechanical check.
M1002 gcode_claim_action : 3 ; Displays "Sweeping XY mech mode" message.

G1 X128 Y128 F20000 ; Moves the toolhead to X = 128, Y = 128 at high speed (20000 mm/min).
G1 Z5 F1200 ; Moves Z-axis to 5mm at 1200 mm/min.
M400 P200 ; Waits for 200ms to stabilize movements.
M970.3 Q1 A5 K0 O3 ; Executes a specific test command with parameters for mechanical analysis.
M974 Q1 S2 P0 ; Executes a secondary mechanical test with specific settings.

M970.2 Q1 K1 W58 Z0.1 ; Runs another test with different parameters, likely Z-axis focus.
M974 S2 ; Completes the previous test.

G1 X128 Y128 F20000 ; Moves the toolhead to X = 128, Y = 128 again at high speed.
G1 Z5 F1200 ; Moves Z-axis to 5mm at a moderate speed.
M400 P200 ; Waits for 200ms to stabilize.
M970.3 Q0 A10 K0 O1 ; Runs another test with adjusted parameters.
M974 Q0 S2 P0 ; Completes the secondary test with different parameters.

M970.2 Q0 K1 W78 Z0.1 ; Runs a third test focused on the Z-axis with additional adjustments.
M974 S2 ; Completes the third test.

M975 S1 ; Re-enables specific settings.
G1 F30000 ; Sets a high feedrate (30000 mm/min) for subsequent movements.
G1 X0 Y5 ; Moves the toolhead to X = 0, Y = 5.
G28 X ; re-home XY ; Re-homes the X and Y axes.

G1 Z4 F1200 ; Moves Z-axis to 4mm at 1200 mm/min.

;===== mech mode fast check end =======================
; End of the fast mechanical check.

;M400 ; Ensures all movements are complete (commented out).
;M73 P1.717 ; Sets print progress to 1.717% (commented out).

;===== wipe nozzle ===============================
M1002 gcode_claim_action : 14 ; Displays "Cleaning nozzle tip" message.

M975 S1 ; Enables specific settings for this action.
M106 S255 ; turn on fan (G28 has turn off fan) ; Turns the fan on at full speed.
M211 S; push soft endstop status ; Pushes the current soft endstop status.
M211 X0 Y0 Z0 ;turn off Z axis endstop ; Temporarily disables Z-axis endstop for precise control.

;===== remove waste by touching start =====

M104 S170 ; set temp down to heatbed acceptable ; Lowers the nozzle temperature to 170°C for safe contact with the bed.

M83 ; Switches extruder to relative mode.
G1 E-1 F500 ; Retracts 1mm of filament at 500 mm/min.
G90 ; Switches to absolute positioning.
M83 ; Ensures extruder stays in relative mode.

M109 S170 ; Sets and waits for nozzle temperature to reach 170°C.
G0 X108 Y-0.5 F30000 ; Moves nozzle to start position at high speed.
G380 S3 Z-5 F1200 ; Probes bed to Z = -5mm with specific settings.
G1 Z2 F1200 ; Raises nozzle to Z = 2mm.
G1 X110 F10000 ; Moves to X = 110mm at moderate speed.
G380 S3 Z-5 F1200 ; Probes bed to Z = -5mm again.
G1 Z2 F1200 ; Raises nozzle to Z = 2mm.
; Repeats probing and cleaning sequence across multiple X positions:
G1 X112 F10000 ; Moves to X = 112mm at moderate speed.
G380 S3 Z-5 F1200 ; Probes bed to Z = -5mm.
G1 Z2 F1200 ; Raises nozzle to Z = 2mm.
G1 X114 F10000 ; Moves to X = 114mm at moderate speed.
G380 S3 Z-5 F1200 ; Probes bed to Z = -5mm.
G1 Z2 F1200 ; Raises nozzle to Z = 2mm.
G1 X116 F10000 ; Moves to X = 116mm at moderate speed.
G380 S3 Z-5 F1200 ; Probes bed to Z = -5mm.
G1 Z2 F1200 ; Raises nozzle to Z = 2mm.
; (Pattern repeats through X = 148)
G1 X118 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X120 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X122 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X124 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X126 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X128 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X130 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X132 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X134 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X136 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X138 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X140 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X142 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X144 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X146 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X148 F10000
G380 S3 Z-5 F1200

G1 Z5 F30000 ; Raises nozzle to Z = 5mm at high speed.

;===== remove waste by touching end =====

G1 Z10 F1200 ; Lifts nozzle to Z = 10mm.
G0 X118 Y261 F30000 ; Moves to cleaning position at high speed.
G1 Z5 F1200 ; Lowers nozzle to Z = 5mm.
M109 S{nozzle_temperature_initial_layer[initial_extruder]-50} ; Sets nozzle temperature dynamically based on initial layer minus 50°C.

G28 Z P0 T300 ; home z with low precision, permit 300 deg temperature ; Homes Z with reduced precision, considering high temperature.
G29.2 S0 ; turn off ABL ; Disables auto bed leveling.
M104 S140 ; prepare to ABL ; Sets nozzle temperature to 140°C for bed leveling.
G0 Z5 F20000 ; Raises nozzle to Z = 5mm at high speed.

G0 X128 Y261 F20000 ; move to exposed steel surface ; Moves to a specific cleaning surface.
G0 Z-1.01 F1200 ; stop the nozzle ; Stops nozzle at Z = -1.01mm.

G91 ; Switches to relative positioning.
; Performs circular cleaning motions with specific parameters:
G2 I1 J0 X2 Y0 F2000.1 ; Makes a small clockwise arc.
G2 I-0.75 J0 X-1.5 ; Makes a small counterclockwise arc.
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5

G90 ; Switches back to absolute positioning.
G1 Z10 F1200 ; Lifts nozzle to Z = 10mm.

;===== brush material wipe nozzle =====

G90 ; Ensures absolute positioning.
G1 Y250 F30000 ; Moves to Y = 250mm at high speed.
G1 X55 ; Moves to X = 55mm.
G1 Z1.300 F1200 ; Lowers nozzle to Z = 1.3mm.
G1 Y262.5 F6000 ; Moves along Y to 262.5mm at moderate speed.
G91 ; Switches to relative positioning.
; Performs alternating X and Y cleaning motions for brushing material off the nozzle:
G1 X-35 F30000 ; Moves X backward by 35mm.
G1 Y-0.5 ; Moves Y backward by 0.5mm.
G1 X45 ; Moves X forward by 45mm.
G1 Y-0.5 ; Moves Y backward by 0.5mm.
G1 X-45
G1 Y-0.5
G1 X45
G1 Y-0.5
G1 X-45
G1 Y-0.5
G1 X45
G1 Z5.000 F1200 ; Lifts nozzle to Z = 5mm.

G90 ; Returns to absolute positioning.
G1 X30 Y250.000 F30000 ; Moves to another brushing start position.
G1 Z1.300 F1200 ; Lowers nozzle to Z = 1.3mm.
G1 Y262.5 F6000 ; Moves along Y to 262.5mm.
G91 ; Switches to relative positioning.
; Repeats brushing motion with adjustments:
G1 X35 F30000 ; Moves X forward by 35mm.
G1 Y-0.5 ; Moves Y backward by 0.5mm.
G1 X-45
G1 Y-0.5
G1 X45
G1 Y-0.5
G1 X-45
G1 Y-0.5
G1 X45
G1 Y-0.5
G1 X-45
G1 Z10.000 F1200 ; Lifts nozzle to Z = 10mm.

;===== brush material wipe nozzle end =====

G90 ; Returns to absolute positioning.
;G0 X128 Y261 F20000  ; move to exposed steel surface
G1 Y250 F30000 ; Moves to final cleaning position along Y.
G1 X138 ; Moves to X = 138mm.
G1 Y261 ; Moves to Y = 261mm.
G0 Z-1.01 F1200 ; Stops nozzle at Z = -1.01mm.

G91 ; Switches to relative positioning.
; Repeats circular cleaning motion as before:
G2 I1 J0 X2 Y0 F2000.1 ; Makes a clockwise arc.
G2 I-0.75 J0 X-1.5 ; Makes a counterclockwise arc.
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5

M109 S140 ; Sets nozzle temperature to 140°C.
M106 S255 ; turn on fan (G28 has turn off fan) ; Ensures fan is on at full speed.

M211 R; pop softend status ; Restores previous soft endstop status.

;===== wipe nozzle end ================================

;M400 ; Ensures all commands are complete (commented out).
;M73 P1.717 ; Sets print progress to 1.717% (commented out).

;===== bed leveling ==================================
M1002 judge_flag g29_before_print_flag ; Flags the start of ABL (Auto Bed Leveling).

G90 ; Switches to absolute positioning.
G1 Z5 F1200 ; Lifts nozzle to Z = 5mm.
G1 X0 Y0 F30000 ; Moves to home position at high speed.
G29.2 S1 ; turn on ABL ; Enables auto bed leveling.

M190 S[bed_temperature_initial_layer_single]; ensure bed temp ; Waits for the bed to reach the initial layer temperature.
M109 S140 ; Sets and waits for the nozzle to reach 140°C.
M106 S0 ; turn off fan , too noisy ; Turns off the fan.

M622 J1 ; Starts a macro or process (possibly related to calibration).
    M1002 gcode_claim_action : 1 ; Displays "Auto bed levelling" message.
    G29 A1 X{first_layer_print_min[0]} Y{first_layer_print_min[1]} I{first_layer_print_size[0]} J{first_layer_print_size[1]} ; Performs a specific area-leveling process.
    M400 ; Ensures all movements are complete.
    M500 ; save cali data ; Saves the calibration data.
M623 ; Ends the macro/process.
;===== bed leveling end ================================

;===== home after wipe mouth============================
M1002 judge_flag g29_before_print_flag ; Flags the need for ABL before printing.
M622 J0 ; Starts a macro or process (possibly for homing).

    M1002 gcode_claim_action : 13 ; Displays "Homing toolhead" message.
    G28 ; Homes all axes.

M623 ; Ends the macro/process.

;===== home after wipe mouth end =======================

;M400 ; Commented out; would ensure all movements are complete.
;M73 P1.717 ; Commented out; would set print progress to 1.717%.

G1 X108.000 Y-0.500 F30000 ; Moves to a specific position at high speed.
G1 Z0.300 F1200 ; Lowers nozzle to Z = 0.3mm.
M400 ; Ensures all movements are complete.
G2814 Z0.32 ; Performs an action at Z = 0.32mm.

M104 S{nozzle_temperature_initial_layer[initial_extruder]} ; prepare to print ; Sets nozzle temperature for the initial layer.

;===== nozzle load line ===============================
;G90 ; Commented out; would ensure absolute positioning.
;M83 ; Commented out; would set extruder to relative mode.
;G1 Z5 F1200 ; Commented out; would raise nozzle to Z = 5mm.
;G1 X88 Y-0.5 F20000 ; Commented out; would move to load line start position.
;G1 Z0.3 F1200 ; Commented out; would lower nozzle to Z = 0.3mm.

;M109 S{nozzle_temperature_initial_layer[initial_extruder]} ; Commented out; would set and wait for nozzle temperature.

;G1 E2 F300 ; Commented out; would extrude 2mm of filament.
;G1 X168 E4.989 F6000 ; Commented out; would extrude filament along the load line.
;G1 Z1 F1200 ; Commented out; would raise nozzle to Z = 1mm.
;===== nozzle load line end ===========================

;===== extrude cali test ===============================

M400 ; Ensures all movements are complete.
    M900 S ; Specific command for calibration, possibly setting parameters.
    M900 C ; Specific command for calibration, possibly clearing parameters.
    G90 ; Ensures absolute positioning.
    M83 ; Ensures extruder is in relative mode.

    {if first_layer_print_min[0] > 10}
        G1 X{first_layer_print_min[0]-10} F30000 ; Moves to a specific position at high speed.
    {else}
        G1 X108.000 F30000 ; Moves to a specific position at high speed.
    {endif}
    
    {if first_layer_print_min[1] > 2}
        G1 Y{first_layer_print_min[1]-2} F30000 ; Moves to a specific position at high speed.
    {else}
        G1 Y-0.500 F30000 ; Moves to a specific position at high speed.
    {endif}
    
    M109 S{nozzle_temperature_initial_layer[initial_extruder]} ; Sets and waits for nozzle temperature for calibration.
    G91 ; Switches to relative positioning.
    G0 X20 E8  F{outer_wall_volumetric_speed/(24/20)    * 60} ; Moves and extrudes filament for calibration.
    ; Performs additional movements with extrusion:
    G0 X5 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)/4     * 60}
    G0 X5 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}
    G0 X5 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)/4     * 60}
    G0 X5 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}
    G0 X5 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)/4     * 60}
    ;G1 X1 Z-0.300 ; Makes fine adjustment in X and Z axes.
    G1 X4 ; Moves X by 4mm.
    G1 Z1 F1200 ; Raises nozzle to Z = 1mm.
    G90 ; Returns to absolute positioning.
    M400 ; Ensures all movements are complete.

M900 R ; Resets calibration parameters.

M1002 judge_flag extrude_cali_flag ; Flags the extrusion calibration.
M622 J1 ; Starts a macro or process for further calibration.
    G90 ; Ensures absolute positioning.

    {if first_layer_print_min[0] > 10}
        G1 X{first_layer_print_min[0]-10} F30000 ; Moves to a specific position at high speed.
    {else}
        G1 X108.000 F30000 ; Moves to a specific position at high speed.
    {endif}
    
    {if first_layer_print_min[1] > 2}
        G1 Y{first_layer_print_min[1]-0.5} F30000 ; Moves to a specific position at high speed.
    {else}
        G1 Y1.000 F30000 ; Moves to a specific position at high speed.
    {endif}
    
    G91 ; Switches to relative positioning.
    G1 Z-0.700 F1200 ; Lowers nozzle by 0.7mm.
    M83 ; Ensures extruder is in relative mode.
    ; Performs extrusion along specific paths:
    G0 X20 E10  F{outer_wall_volumetric_speed/(24/20)    * 60}
    G0 X5 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)/4     * 60}
    G0 X5 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}
    G0 X5 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)/4     * 60}
    G0 X5 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}
    G0 X5 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)/4     * 60}
    ;G1 X1 Z-0.300 ; Makes fine adjustment in X and Z axes.
    G1 X4 ; Moves X by 4mm.
    G1 Z1 F1200 ; Raises nozzle to Z = 1mm.
    G90 ; Returns to absolute positioning.
    M400 ; Ensures all movements are complete.
M623 ; Ends the macro/process.

G1 Z0.2 ; Lowers nozzle to Z = 0.2mm.

;M400 ; Commented out; would ensure all movements are complete.
;M73 P1.717 ; Commented out; would set print progress to 1.717%.

;========turn off light and wait extrude temperature =============
M1002 gcode_claim_action : 0 ; Unknown, possibly clear screen of messages?
M400 ; Ensures all movements are complete.

;===== for Textured PEI Plate , lower the nozzle as the nozzle was touching topmost of the texture when homing ==
;curr_bed_type={curr_bed_type} ; Checks current bed type.
{if curr_bed_type=="Textured PEI Plate"} ; Conditional adjustment for textured plate.
    G29.1 Z{-0.02} ; Adjusts for the plate texture.
{endif}

M960 S1 P0 ; turn off laser.
M960 S2 P0 ; turn off laser.
M106 S0 ; turn off fan.
M106 P2 S0 ; turn off big fan.
M106 P3 S0 ; turn off chamber fan.

M975 S1 ; turn on mech mode supression.
G90 ; Ensures absolute positioning.
M83 ; Ensures extruder is in relative mode.
T1000 ; Specific command, possibly tool selection.

M211 X0 Y0 Z0 ;turn off soft endstop.
;G392 S1 ; turn on clog detection ; Commented out; would enable clog detection.
M1007 S1 ; turn on mass estimation.
G29.4 ; Finishes process.
