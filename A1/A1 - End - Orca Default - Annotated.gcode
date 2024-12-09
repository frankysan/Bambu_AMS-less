;=== Bambu Lab A1 End of print Annotated G-code ====
;=== Based on Orca Slicer default G-code ===========
;=== Original date: 20231229 =======================
;=== Modified date: 20241209 =======================
;=== https://github.com/frankysan/Bambu_AMS-less ===

G392 S0 ; turn off nozzle clog detection

M400 ; wait for the movement buffer to clear
G92 E0 ; reset the extruder position to zero
G1 E-0.8 F1800 ; retract the filament slightly to prevent stringing
G1 Z{max_layer_z + 0.5} F900 ; raise the nozzle slightly above the maximum print height
G1 X0 Y{first_layer_center_no_wipe_tower[1]} F18000 ; move to a safe position in X and Y
G1 X-13.0 F3000 ; adjust the safe position further

{if !spiral_mode && print_sequence != "by object"}
    ; Conditional block for timelapse or specific print sequence

    M1002 judge_flag timelapse_record_flag ; set flag for timelapse recording
    M622 J1 ; timelapse preparation command
        M400 P100 ; pause briefly
        ; The following lines set up timelapse triggers multiple times for consistent setup
        M971 S11 C11 O0
        M400 P100
        M971 S11 C11 O0
        M400 P100
        M971 S11 C11 O0
        M400 P100
        M971 S11 C11 O0
        M400 P100
        M971 S11 C11 O0
        M400 P100
        M971 S11 C11 O0
        M400 P100
        M971 S11 C11 O0
        M400 P100
        M971 S11 C11 O0
        M400 P100
        M971 S11 C11 O0
        M400 P100
        M971 S11 C11 O0
        M400 P100
        M971 S11 C11 O0
        M400 P100
        M971 S11 C11 O0
        M400 P100
        M971 S11 C11 O0
        M400 P100
        M971 S11 C11 O0
        M400 P100
        M971 S11 C11 O0
        M400 P100
        M971 S11 C11 O0
        M400 P100
        M971 S11 C11 O0
        M400 P100
        M971 S11 C11 O0
        M400 P100
        M971 S11 C11 O0
        M400 P100
        M971 S11 C11 O0
        M400 P100
        M971 S11 C11 O0
        M400 P100
        M971 S11 C11 O0
        M400 P100
        M971 S11 C11 O0
        M400 P100
        M971 S11 C11 O0
        M400 P100
        M971 S11 C11 O0
        M400 P100
        M971 S11 C11 O0
        M400 P100
        M971 S11 C11 O0
        M400 P100
        M971 S11 C11 O0
        M400 P100
        M971 S11 C11 O0
        M400 P100
        M971 S11 C11 O0
        M991 S0 P-1 ; end the timelapse recording
    M623 ; conclude the timelapse-related commands
{endif}

M140 S0 ; turn off the heated bed
M106 S0 ; turn off the main cooling fan
M106 P2 S0 ; turn off the remote part cooling fan
M106 P3 S0 ; turn off the chamber cooling fan

;G1 X27 F15000 ; wipe (disabled command for nozzle wiping)

; Pull back filament to AMS (Automatic Material System)
; M620 activates the AMS (Automatic Material System) if available.
; When AMS is not present, any code between M620 and M621 is ignored.
M620 S255 ; prepare for filament retraction
    G1 X267 F15000 ; move to filament ejection position
    T255 ; select a tool (likely filament slot)
    G1 X-28.5 F18000 ; retract filament
    G1 X-48.2 F3000 ; additional retraction movement
    G1 X-28.5 F18000 ; repeat to ensure filament is cleared
    G1 X-48.2 F3000
M621 S255 ; complete the filament retraction process

M104 S0 ; turn off the hotend heater

M400 ; wait for all movements to complete
M17 S ; enable stepper motors
M17 Z0.4 ; reduce current to the Z-axis motor to minimize impact if obstructions exist

{if (max_layer_z + 100.0) < 256}
    G1 Z{max_layer_z + 100.0} F600 ; move Z-axis up to a safe height
    G1 Z{max_layer_z + 98.0} ; slight adjustment
{else}
    G1 Z256 F600 ; limit Z-axis movement to a maximum height of 256mm
    G1 Z256
{endif}

M400 P100 ; brief pause
M17 R ; restore Z-axis motor current

G90 ; switch to absolute positioning
G1 X-48 Y180 F3600 ; move to a final resting position

M220 S100 ; reset feedrate multiplier
M201.2 K1.0 ; reset acceleration multiplier
M73.2 R1.0 ; reset estimated print time multiplier
M1002 set_gcode_claim_speed_level : 0 ; reset internal speed level setting

;=====printer finish  sound=========
; Commands to play a series of tones indicating print completion
M17
M400 S1
M1006 S1
M1006 A0 B20 L100 C37 D20 M40 E42 F20 N60
M1006 A0 B10 L100 C44 D10 M60 E44 F10 N60
M1006 A0 B10 L100 C46 D10 M80 E46 F10 N80
M1006 A44 B20 L100 C39 D20 M60 E48 F20 N60
M1006 A0 B10 L100 C44 D10 M60 E44 F10 N60
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N60
M1006 A0 B10 L100 C39 D10 M60 E39 F10 N60
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N60
M1006 A0 B10 L100 C44 D10 M60 E44 F10 N60
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N60
M1006 A0 B10 L100 C39 D10 M60 E39 F10 N60
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N60
M1006 A0 B10 L100 C48 D10 M60 E44 F10 N80
M1006 A0 B10 L100 C0 D10 M60 E0 F10  N80
M1006 A44 B20 L100 C49 D20 M80 E41 F20 N80
M1006 A0 B20 L100 C0 D20 M60 E0 F20 N80
M1006 A0 B20 L100 C37 D20 M30 E37 F20 N60
M1006 W ; conclude the sound sequence
;=====printer finish  sound=========

;M17 X0.8 Y0.8 Z0.5 ; (disabled command to lower motor current)
M400 ; wait for any remaining movements to finish
M18 X Y Z ; disable motors for X, Y, and Z axes
