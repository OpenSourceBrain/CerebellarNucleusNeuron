// genesis
// simulate response of DCN model to temporary voltage clamp

include cn_const
include cn_chan
include cn_syn
include cn_comp
include cn_fileout
include cn_vclamp

outfilev = "data/cn_v_vc_" @ {vcstep*1e3} @ "mV_" @ {simnum} @ "_"
outfilei = "data/cn_i_vc_" @ {vcstep*1e3} @ "mV_" @ {simnum} @ "_"
outfilechan = "data/cn_chan_vc_" @ {vcstep*1e3} @ "mV_" @ {simnum} @ "_"
outfileitotal = "data/cn_itotal_vc_" @ {vcstep*1e3} @ "mV_" @ {simnum}

if (!{exists /library})
        create neutral /library
        disable /library
end

// make the prototypes in the library
ce /library

make_cn_chans
make_cn_syns
make_cn_comps

// read cell morphology from .p file
readcell cn0106c_z15_l01_ax.p {cellpath} -hsolve

// add voltage clamp circuit to soma
make_vclamp {cellpath}/soma
setfield /Vclamp x {vcstep}

// set the simulation and output clocks
for (i = 0; {i <= 7}; i = i + 1)
    setclock {i} {dt}
end
setclock 8 {dtout}
setclock 9 1

// set up Hines solver
silent -1
echo preparing Hines solver
ce {cellpath}
setfield . comptmode 1 chanmode 4 storemode 1 
call . SETUP
echo SOLVE setup done
setmethod 11

// write simulation results to files
write_voltage soma 0
write_chancurrents_itotal

// reset the simulation
echo reset now
reset
echo done

echo starting pre voltage clamp period
step {vconset} -time
echo finished pre voltage clamp period

// voltage clamp step
echo
echo starting voltage clamp at V = {{vcstep}*1e3} mV
set_vclamp_on
step {vcdur} -time
set_vclamp_off
echo finished voltage clamp

echo
echo starting post voltage clamp period
step {{tstop} - ({vconset} + {vcdur})} -time
echo finished post voltage clamp period

echo exiting simulation
quit
