M291 P"Please wait while the nozzle is being heated up" R"Unloading PLA colorLabb semi-matte" T5 ; Display message
G10 S160 ; Heat up the current tool to 160C
M116 ; Wait for the temperatures to be reached
M291 P"Retracting filament..." R"Unloading PLA colorLabb semi-matte" T5 ; Display another message
G1 E-20 F300 ; Retract 20mm of filament at 300mm/min
G1 E-350 F3000 ; Retract 3500mm of filament at 3000mm/min
M400 ; Wait for the moves to finish
M292 ; Hide the message again
M568 P0 A0 ; Turn of extruder heater