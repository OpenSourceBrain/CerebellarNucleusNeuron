// genesis
// simulate response of DCN model to current injection

include cn_const
include cn_chan
include cn_syn
include cn_comp
include cn_fileout

outfilev = "data/cn_v_cip_" @ {cipamp*1e12} @ "pA_" @ {simnum} @ "_"
outfilei = "data/cn_i_cip_" @ {cipamp*1e12} @ "pA_" @ {simnum} @ "_"
outfilechan = "data/cn_chan_cip_" @ {cipamp*1e12} @ "pA_" @ {simnum} @ "_"
outfileitotal = "data/cn_itotal_cip_" @ {cipamp*1e12} @ "pA_" @ {simnum}

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

// set the simulation and output clocks
for (i = 0; {i <= 7}; i = i + 1)
    setclock {i} {dt}
end
setclock 8 {dtout}
setclock 9 1000

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
//write_chancurrents_ca soma 0
//write_chan_activations soma 0
//write_chancurrents_itotal

// reset the simulation
echo reset now
reset
echo done

echo starting pre-pulse period
hstr={findsolvefield {cellpath} {cellpath}/soma inject}
setfield {cellpath} {hstr} 0.0
step {ciponset} -time
echo finished pre-pulse period

// current injection
echo
echo applying current injection pulse I = {{cipamp}*1e12} pA
setfield {cellpath} {hstr} {cipamp}
step {cipdur} -time
echo finished current injection

echo
echo starting post-pulse period
setfield {cellpath} {hstr} 0.0
step {{tstop} - ({ciponset} + {cipdur})} -time
echo finished post-pulse period

echo exiting simulation
quit
