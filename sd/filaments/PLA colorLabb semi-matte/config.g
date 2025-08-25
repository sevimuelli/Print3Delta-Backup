M207 S2 R0.0 F3000 T3000 Z2.0           ; firmware retraction settings

; Set temperatures
M568 P0 R140 S210 A0                    ; set standby and active temperatures for tool 1 and turn off
M140 S55 R40                            ; set bed temperature to 55C and bed standby temperature to 40C
M140 S-273.1                            ; Set bed heater off
M141 S0 R0                              ; set chamber temperature to 0C and bed standby temperature to 0C
M141 S-273.1                            ; Set chamber heater off

