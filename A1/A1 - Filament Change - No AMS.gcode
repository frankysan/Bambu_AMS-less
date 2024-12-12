;=== Bambu Lab A1 Filament change G-code without AMS ===
;=== Based on Orca Slicer default G-code ===============
;=== Original date: 20240830 ===========================
;=== Modified date: 20241212 ===========================
;=== https://github.com/frankysan/Bambu_AMS-less =======

; NOTE: "Manual Filament Change" in Orca Slicer should be enabled if you use this G-code.

M1007 S0 ; Turn off mass estimation for this operation.
G392 S0 ; Disable nozzle clog detection temporarily.

; M620 activates the AMS (Automatic Material System) if available.
; When AMS is not present, any code between M620 and M621 is ignored.
; All M620, M620.x and M621 commands are disabled or removed to enable manual filament change.
;M620 S[next_extruder]A ; Commented out, since we are not using an AMS.

    M204 S9000 ; Set acceleration for this operation to 9000 mm/s².

    {if toolchange_count > 1}
        G17 ; Ensure the XY plane is active for arc movements.
        G2 Z{max_layer_z + 0.4} I0.86 J0.86 P1 F10000 ; Perform a spiral lift (a small Z-axis upward movement) if this is not the first filament change.
    {endif}

    G1 Z{max_layer_z + 3.0} F1200 ; Move the nozzle to a safe height for filament change.

    M400 ; Wait for all movements to finish.
    M106 P1 S0 ; Turn off part cooling fan.
    M106 P2 S0 ; Turn off remote part cooling fan.

    ; Heat the nozzle for old filament removal.
    {if old_filament_temp > 142 && next_extruder < 255}
        M104 S[old_filament_temp] ; Set the hotend temperature to the required value for removing the old filament.
    {endif}

    G1 X-48.2 F18000 ; Move the nozzle to the left, near the nozzle wiper.

    ;M620.1 removed to avoid slicer error message.
    ;M620.10 A0 F[old_filament_e_feedrate] ; Confirm old filament is removed.
    
    G1 E10 F200 ; Push a little filament out and then retract out.
    G1 E-10 F200
    G1 E-20 F500
    M400 U1 ; Pause the print, and wait for the user to change filament manually.
    
    ;T[next_extruder] ; Switch to the next extruder.
    ;M620.1 E F[new_filament_e_feedrate] T{nozzle_temperature_range_high[next_extruder]} ; Command AMS to load the new filament.
    ;M620.10 A1 F[new_filament_e_feedrate] L[flush_length] H[nozzle_diameter] T[nozzle_temperature_range_high] ; Confirm new filament is loaded.

    G1 Y128 F9000 ; Move to a safe Y position.

    {if next_extruder < 255}
        M400 ; Wait for all operations to finish.

        G92 E0 ; Reset the extruder position to zero.
        M628 S0 ; Disable extruder advance to prepare for flushing.

        {if flush_length_1 > 1}
            ; FLUSH_START ; Begin flushing old material.
            M400 ; Wait for operations to complete.
            M1002 set_filament_type:UNKNOWN ; Temporarily set filament type as unknown.
            M109 S[nozzle_temperature_range_high] ; Wait for the nozzle to reach the maximum operating temperature.
            M106 P1 S60 ; Turn on part cooling fan to 60% for flushing.

            {if flush_length_1 > 23.7}
                G1 E23.7 F{old_filament_e_feedrate} ; Perform initial flushing without pulsation.
                ; Perform pulsatile flushing to clear remaining old filament.
                G1 E{(flush_length_1 - 23.7) * 0.02} F50
                G1 E{(flush_length_1 - 23.7) * 0.23} F{old_filament_e_feedrate}
                G1 E{(flush_length_1 - 23.7) * 0.02} F50
                G1 E{(flush_length_1 - 23.7) * 0.23} F{new_filament_e_feedrate}
                G1 E{(flush_length_1 - 23.7) * 0.02} F50
                G1 E{(flush_length_1 - 23.7) * 0.23} F{new_filament_e_feedrate}
                G1 E{(flush_length_1 - 23.7) * 0.02} F50
                G1 E{(flush_length_1 - 23.7) * 0.23} F{new_filament_e_feedrate}
            {else}
                G1 E{flush_length_1} F{old_filament_e_feedrate} ; Simple flush if length is small.
            {endif}

            ; FLUSH_END
            G1 E-[old_retract_length_toolchange] F1800 ; Retract the filament slightly to prevent oozing.
            G1 E[old_retract_length_toolchange] F300 ; Reprime the extruder.
            M400 ; Wait for operations to finish.
            M1002 set_filament_type:{filament_type[next_extruder]} ; Restore filament type.
        {endif}

        {if flush_length_1 > 45 && flush_length_2 > 1}
            ; WIPE ; Wipe the nozzle to remove debris.
            M400 ; Wait for operations to finish.
            M106 P1 S178 ; Turn on part cooling fan to 70% for wiping.
            M400 S3 ; Wait for 3 seconds for stabilization.
            G1 X-38.2 F18000 ; Move to wiping position.
            G1 X-48.2 F3000 ; Alternate movements for effective wiping.
            G1 X-38.2 F18000
            G1 X-48.2 F3000
            G1 X-38.2 F18000
            G1 X-48.2 F3000
            M400 ; Wait for movements to finish.
            M106 P1 S0 ; Turn off fan after wiping.
        {endif}

        {if flush_length_2 > 1}
            M106 P1 S60 ; Turn on part cooling fan for second flush.
            ; FLUSH_START ; Begin second flushing phase.
            G1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}
            G1 E{flush_length_2 * 0.02} F50
            G1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}
            G1 E{flush_length_2 * 0.02} F50
            G1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}
            G1 E{flush_length_2 * 0.02} F50
            G1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}
            G1 E{flush_length_2 * 0.02} F50
            G1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}
            G1 E{flush_length_2 * 0.02} F50
            ; FLUSH_END
            G1 E-[new_retract_length_toolchange] F1800 ; Retract filament.
            G1 E[new_retract_length_toolchange] F300 ; Reprime extruder.
        {endif}

        ; (Similar logic applies for flush_length_3 and flush_length_4 sequences)

        {if flush_length_2 > 45 && flush_length_3 > 1}
            ; WIPE
            M400
            M106 P1 S178
            M400 S3
            G1 X-38.2 F18000
            G1 X-48.2 F3000
            G1 X-38.2 F18000
            G1 X-48.2 F3000
            G1 X-38.2 F18000
            G1 X-48.2 F3000
            M400
            M106 P1 S0
        {endif}

        {if flush_length_3 > 1}
            M106 P1 S60
            ; FLUSH_START
            G1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}
            G1 E{flush_length_3 * 0.02} F50
            G1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}
            G1 E{flush_length_3 * 0.02} F50
            G1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}
            G1 E{flush_length_3 * 0.02} F50
            G1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}
            G1 E{flush_length_3 * 0.02} F50
            G1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}
            G1 E{flush_length_3 * 0.02} F50
            ; FLUSH_END
            G1 E-[new_retract_length_toolchange] F1800
            G1 E[new_retract_length_toolchange] F300
        {endif}

        {if flush_length_3 > 45 && flush_length_4 > 1}
            ; WIPE
            M400
            M106 P1 S178
            M400 S3
            G1 X-38.2 F18000
            G1 X-48.2 F3000
            G1 X-38.2 F18000
            G1 X-48.2 F3000
            G1 X-38.2 F18000
            G1 X-48.2 F3000
            M400
            M106 P1 S0
        {endif}

        {if flush_length_4 > 1}
            M106 P1 S60
            ; FLUSH_START
            G1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}
            G1 E{flush_length_4 * 0.02} F50
            G1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}
            G1 E{flush_length_4 * 0.02} F50
            G1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}
            G1 E{flush_length_4 * 0.02} F50
            G1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}
            G1 E{flush_length_4 * 0.02} F50
            G1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}
            G1 E{flush_length_4 * 0.02} F50
            ; FLUSH_END
        {endif}

        M629 ; Reset AMS state.

        M400 ; Wait for operations to complete.
        M106 P1 S60 ; Turn on part cooling fan.
        M109 S[new_filament_temp] ; Set nozzle temperature for the new filament.
        G1 E6 F{new_filament_e_feedrate} ; Extrude extra material to ensure flow.
        M400 ; Wait for completion.
        G92 E0 ; Reset extruder position.
        G1 E-[new_retract_length_toolchange] F1800 ; Retract filament to prepare for wiping.
        M400 ; Wait for retraction.
        M106 P1 S178
        M400 S3
        G1 X-38.2 F18000
        G1 X-48.2 F3000
        G1 X-38.2 F18000
        G1 X-48.2 F3000
        G1 X-38.2 F18000
        G1 X-48.2 F3000
        G1 X-38.2 F18000
        G1 X-48.2 F3000
        M400
        G1 Z{max_layer_z + 3.0} F3000 ; Raise nozzle to safe height.
        M106 P1 S0 ; Turn off part cooling fan.

        {if layer_z <= (initial_layer_print_height + 0.001)}
            M204 S[initial_layer_acceleration] ; Restore initial layer acceleration.
        {else}
            M204 S[default_acceleration] ; Restore default acceleration.
        {endif}
    {else}
        G1 X[x_after_toolchange] Y[y_after_toolchange] Z[z_after_toolchange] F12000 ; Move to the next print location.
    {endif}

    M622.1 S0 ; Finish extruder state change.
    M9833 F{outer_wall_volumetric_speed/2.4} A0.3 ; Dynamic extrusion compensation.
    M1002 judge_flag filament_need_cali_flag ; Calibration flag for new filament.
    M622 J1 ; If Timelapse is enabled, run following code.
        G92 E0 ; Reset extruder position.
        G1 E-[new_retract_length_toolchange] F1800 ; Final retraction.

        ; Perform nozzle cleaning and wiping.
        M400
        M106 P1 S178 ; Activate fan for cleaning.
        M400 S4
        G1 X-38.2 F18000
        G1 X-48.2 F3000
        G1 X-38.2 F18000 ;wipe and shake
        G1 X-48.2 F3000
        G1 X-38.2 F12000 ;wipe and shake
        G1 X-48.2 F3000
        M400
        M106 P1 S0 ; Turn off fan after cleaning.  

    M623 ; End of Timelapse sequence.

;M621 S[next_extruder]A ; Reactivate AMS if used, commented out.

;===== AMS commands skip ====================
; Since there is no AMS, the following three lines are used solely to suppress
; the T[next_extruder] command.
; If these lines were omitted, the T[next_extruder] command would be executed
; after this code, leading to system hang as the toolchange command wait for the AMS.

M620 S[next_extruder]A
    T[next_extruder]
M621 S[next_extruder]A

G392 S0 ; Disable nozzle clog detection.
M1007 S1 ; Re-enable mass estimation.
