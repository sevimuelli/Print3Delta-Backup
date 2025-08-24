echo "Starting Daemon"    
echo >"daemon_debug.txt" state.time, "Starting Daemon"
var chamberFanOn = false
var chamberFanStandby = false
var chamberHeaterWasOn = false
var chamberFanMinRPM = 1800
var chamberFanStandbyRPM = 1800
var chamberFanOnSpeed = 0.8
var debugOn = false


while true
  set var.chamberFanOnSpeed = 0.8
  set var.debugOn = true  ; Here to change while running
  if var.debugOn
    echo >>"daemon_debug.txt" state.time, ", chamberFanOn: ", var.chamberFanOn, ", chamberFanStandby: ", var.chamberFanStandby, ", chamberHeaterWasOn", var.chamberHeaterWasOn
  if heat.heaters[2].state == "active" || heat.heaters[2].state == "tuning"
	if var.chamberFanOn == false
	  if var.debugOn 
	    echo >>"daemon_debug.txt" "Chamber active, turn fan on"
	  set var.chamberHeaterWasOn = true
	  M106 P3 S{var.chamberFanOnSpeed}
	  G4 P2000
	  set var.chamberFanOn = true
	else
	  if heat.heaters[2].avgPwm <= 0.5
	    if var.debugOn
		  echo >>"daemon_debug.txt" "Chamber heating inactive"
	    set var.chamberFanStandby = true
	    if sensors.analog[2].lastReading <= 75.0
		  if var.debugOn
		    echo >>"daemon_debug.txt" "Fan standby"
		  M106 P3 S0
		else
		  if var.debugOn
		    echo >>"daemon_debug.txt" "Fan standby, low speed fan for cooldown"
		  M106 P3 S0.5   ; Cool down heater but not chamber
			
	  else                 ; If heater is heating
	    if var.chamberFanStandby == true  ; If fan not running, turn on
		  if var.debugOn
		    echo >>"daemon_debug.txt" "Turn fan back on"
		  M106 P3 S{var.chamberFanOnSpeed}
		  G4 P1000     ; Wait for 1s so there is no fan failure error
		  set var.chamberFanStandby = false
		
	  ; echo >>"daemon_debug.txt" "{fans[3].rpm < var.chamberFanMinRPM} && {var.chamberFanStandby == false}: ", {fans[3].rpm < var.chamberFanMinRPM} && {var.chamberFanStandby == false}
	  if {fans[3].rpm < var.chamberFanMinRPM} && {var.chamberFanStandby == false}
	    M141 R-273 S-273            ; Set chamber heater standby
		M140 R-273 S-273            ; Set bed heater stanby
        G10 P0 R-273 S-273			; Set Tool 0 temp, to turn off
		M400                        ; Wait for move to finish
		M0							; Stop, put motors to sleep
	    M106 P3 S0                  ; Turn fan off
	    set var.chamberFanOn = false
		set var.chamberHeaterWasOn = false
	    set var.chamberFanStandby = false
	    M291 P"Chamber heater fan RPM is too low. Turning off heater" R"Chamber heater fault" S1
	    
	  

  else
    if var.chamberHeaterWasOn == true
	  if var.debugOn
	    echo "Cooling down chamber heater"
	  if sensors.analog[2].lastReading >= 40.0   ; If heater is hot turn on fan if not running
	    M106 P3 S0.9     ; Turn of fan
	  while sensors.analog[2].lastReading >= 40.0
	    if heat.heaters[2].state == "active"
		  break
		G4 P1000     ; Wait for 1s
	  if heat.heaters[2].state == "off"  ; only turn off fan if heater was not reactivated again
	    M106 P3 S0     ; Turn of fan
	  set var.chamberFanOn = false
	  set var.chamberHeaterWasOn = false
	  set var.chamberFanStandby = false
  
  ; Set NeoPixel depending on state machine
  if state.status == "starting"
    M150 E0 R252 U107 B3 P255 S144
  elif state.status == "disconnected"
    M150 E0 R252 U107 B3 P255 S144
  elif state.status == "idle"
    M150 E0 R0 U255 B0 P255 S144
  elif state.status == "busy"
    M150 E0 R196 U12 B237 P255 S144
  elif state.status == "processing"
    M150 E0 R0 U255 B255 P255 S144
  elif state.status == "paused"
    M150 E0 R255 U255 B0 P255 S144
  else
    M150 E0 R252 U107 B3 P255 S144
  
  
  
  G4 P500  ; Give control back to main process (Pause for 2s)