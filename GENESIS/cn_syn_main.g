// genesis
// simulate response of DCN model to synaptic input

include cn_const
include cn_chan
include cn_syn
include cn_comp
include cn_fileout

outfilev = "data/cn_v_" @ {simnum} @ "_"
outfilei = "data/cn_i_" @ {simnum} @ "_"
outfilechan = "data/cn_chan_" @ {simnum} @ "_"
outfilesyn = "data/cn_syn_" @ {simnum} @ "_"
outfileitotal = "data/cn_itotal_" @ {simnum}
outfilesyntotal = "data/cn_syntotal_" @ {simnum}

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

// need to add synapses after readcell -hsolve (GENESIS limitation)
ce {cellpath}
add_soma_syns
add_dend_syns

// update timetables for synaptic input burst
add_synburst

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
write_syncurrents_itotal

// reset the simulation
echo reset now
reset
echo done

// run the simulation and apply synaptic input
echo applying synaptic input
step {tstop} -time
echo done

echo exiting simulation
quit
