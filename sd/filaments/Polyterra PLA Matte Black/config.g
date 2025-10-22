M92 E395.34                   ; Extruder steps
M572 D0 S0.20                 ; Pressure advance
M207 S3.5 R0.0 F900 T900 Z0.5 ; firmware retraction settings (normally around 3000+)
G31 Z4.11                     ; Z Probe trigger height

; Set temperatures
M568 P0 R140 S225 A0          ; set standby and active temperatures for tool 1 and turn off
M140 S55 R40                  ; set bed temperature to 55C and bed standby temperature to 40C
M140 S-273.1                  ; Set bed heater off
M141 S0 R0                    ; set chamber temperature to 0C and bed standby temperature to 0C
M141 S-273.1                  ; Set chamber heater off