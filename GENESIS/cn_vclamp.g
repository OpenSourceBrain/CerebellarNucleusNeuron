// genesis

function make_vclamp(path)
str  path

  create  diffamp /Vclamp
  setfield ^   saturation  999.0 \ 
	       gain        0.002   // 1/R  from the lowpass filter input

  create  RC  /Vclamp/lowpass
  setfield ^   R   500.0   \   // ohm
	       C   0.1e-6      // farad; for a tau of 50 us

  create  PID /Vclamp/PID
  setfield ^   gain    1e-6    \   // off
	       tau_i   {dt}   \   // seconds
	       tau_d   {{dt}/4}  \   // seconds
               saturation  0  // off 

  echo connecting voltage clamp circuitry
  addmsg /Vclamp/lowpass /Vclamp PLUS state
  addmsg /Vclamp /Vclamp/PID CMD output
  addmsg /Vclamp /Vclamp/lowpass INJECT x   
  addmsg {path} /Vclamp/PID SNS Vm  
  addmsg /Vclamp/PID {path} INJECT output 

end

function set_vclamp_on

  setfield /Vclamp/PID saturation 50e-9 // amps

end


function set_vclamp_off

  setfield /Vclamp/PID saturation 0

end
