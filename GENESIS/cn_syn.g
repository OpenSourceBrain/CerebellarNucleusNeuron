// genesis

// create synapses (based on Gauck and Jaeger 2003)
function make_cn_syns

	if (!({exists AMPA}))
		create synchan AMPA
	end
	setfield AMPA Ek {E_AMPA} tau1 {tauRise_AMPA} tau2 {tauFall_AMPA} \
		gmax 0 frequency 0 

	if (!({exists fNMDA}))
                create synchan fNMDA
        end
	setfield fNMDA Ek {E_NMDA} tau1 {tauRise_fNMDA} tau2 {tauFall_fNMDA} \
		gmax 0 frequency 0
	
	if (!({exists Mg_fblock}))
                create Mg_block Mg_fblock 
        end
	setfield Mg_fblock		\
		CMg    0.002		\
		KMg_A  1		\
		KMg_B  {1.0/{0.109*1000}}

	if (!({exists sNMDA}))
                create synchan sNMDA
        end
	setfield sNMDA Ek {E_NMDA} tau1 {tauRise_sNMDA} tau2 {tauFall_sNMDA} \
		gmax 0 frequency 0
	
	if (!({exists Mg_sblock}))
                create Mg_block Mg_sblock 
        end
	setfield Mg_sblock		\
		CMg    0.25		\
		KMg_A  1		\
		KMg_B  {1/{0.057*1000}}

	if (!({exists GABA}))
	       	create synchan GABA
	end
	setfield GABA Ek {E_GABA} tau1 {tauRise_GABA} tau2 {tauFall_GABA}  \
		gmax 0 frequency 0

end


// add synapses to soma
function add_soma_syns

  	copy /library/GABA soma/GABAs
  	setfield soma/GABAs gmax {G_GABAs}
  	addmsg soma/GABAs soma CHANNEL Gk Ek
  	addmsg soma soma/GABAs VOLTAGE Vm
	
  	copy /library/AMPA soma/AMPAs
  	setfield soma/AMPAs gmax {G_AMPAs}
  	addmsg soma/AMPAs soma CHANNEL Gk Ek
 	addmsg soma soma/AMPAs VOLTAGE Vm
	
  	copy /library/fNMDA soma/fNMDAs
  	setfield soma/fNMDAs gmax {G_fNMDAs}
  	copy /library/Mg_fblock soma/Mg_fblocks
  	addmsg soma/fNMDAs soma/Mg_fblocks CHANNEL Gk Ek
  	addmsg soma/Mg_fblocks soma CHANNEL Gk Ek
  	addmsg soma soma/Mg_fblocks VOLTAGE Vm	
  	addmsg soma soma/fNMDAs VOLTAGE Vm
	
  	copy /library/sNMDA soma/sNMDAs
  	setfield soma/sNMDAs gmax {G_sNMDAs}
  	copy /library/Mg_sblock soma/Mg_sblocks
  	addmsg soma/sNMDAs soma/Mg_sblocks CHANNEL Gk Ek
  	addmsg soma/Mg_sblocks soma CHANNEL Gk Ek
  	addmsg soma soma/Mg_sblocks VOLTAGE Vm	
  	addmsg soma soma/sNMDAs VOLTAGE Vm	

  	//set up timetables and input to soma
  	if (!{exists /inputs})
    		create neutral /inputs
  	end
  	create neutral /inputs/soma

  	if ({ex_rate_s} > 0)
    		create timetable /inputs/soma/ex_tt
    		setfield /inputs/soma/ex_tt \
      			maxtime {synmaxtime} act_val 1.0 method 2 \
      			meth_desc1 {1/{ex_rate_s}} \
      			meth_desc2 0 meth_desc3 3
      		call /inputs/soma/ex_tt TABFILL

      		create spikegen /inputs/soma/ex_spikegen
      		setfield /inputs/soma/ex_spikegen output_amp 1 thresh 0.5
      		addmsg /inputs/soma/ex_tt /inputs/soma/ex_spikegen INPUT activation
      		addmsg /inputs/soma/ex_spikegen soma/AMPAs SPIKE
      		addmsg /inputs/soma/ex_spikegen soma/fNMDAs SPIKE
      		addmsg /inputs/soma/ex_spikegen soma/sNMDAs SPIKE
  	end

  	if ({inhib_rate_s} > 0)
    		create timetable /inputs/soma/inhib_tt
    		setfield /inputs/soma/inhib_tt \
      			maxtime {synmaxtime} act_val 1.0 method 2 \
      			meth_desc1 {1/{inhib_rate_s}} \
      			meth_desc2 0 meth_desc3 3
      		call /inputs/soma/inhib_tt TABFILL
      
		create spikegen /inputs/soma/inhib_spikegen
      		setfield /inputs/soma/inhib_spikegen output_amp 1 thresh 0.5
      		addmsg /inputs/soma/inhib_tt /inputs/soma/inhib_spikegen INPUT activation
      		addmsg /inputs/soma/inhib_spikegen soma/GABAs SPIKE
  	end
end


// add synapses to dendritic compartments
function add_dend_syns

	int i
	str mfincomp, pcincomp

	if (!{exists /inputs})
 	 create neutral /inputs
	end 
	
	// add excitory synapses to set of compartments (read in from file)
	openfile {MF_infile} r
	randseed {MF_seed}

	for (i = 1; i <= {no_MF}; i = i + 1)
		mfincomp = {readfile {MF_infile}}

		copy /library/AMPA {mfincomp}/AMPAd
  		setfield {mfincomp}/AMPAd gmax {G_AMPAd}
        	addmsg  {mfincomp}/AMPAd {mfincomp}  CHANNEL Gk Ek
        	addmsg  {mfincomp} {mfincomp}/AMPAd VOLTAGE Vm

		copy /library/fNMDA {mfincomp}/fNMDAd
		setfield {mfincomp}/fNMDAd gmax {G_fNMDAd}
		copy /library/Mg_fblock {mfincomp}/Mg_fblockd
  		addmsg {mfincomp}/fNMDAd {mfincomp}/Mg_fblockd CHANNEL Gk Ek
		addmsg {mfincomp}/Mg_fblockd {mfincomp} CHANNEL Gk Ek
  		addmsg {mfincomp} {mfincomp}/Mg_fblockd VOLTAGE Vm	
  		addmsg {mfincomp} {mfincomp}/fNMDAd VOLTAGE Vm
	
		copy /library/sNMDA {mfincomp}/sNMDAd
		setfield {mfincomp}/sNMDAd gmax {G_sNMDAd}
		copy /library/Mg_sblock {mfincomp}/Mg_sblockd
  		addmsg {mfincomp}/sNMDAd {mfincomp}/Mg_sblockd CHANNEL Gk Ek
		addmsg {mfincomp}/Mg_sblockd {mfincomp} CHANNEL Gk Ek
  		addmsg {mfincomp} {mfincomp}/Mg_sblockd VOLTAGE Vm	
  		addmsg {mfincomp} {mfincomp}/sNMDAd VOLTAGE Vm	
		
		create neutral /inputs/{mfincomp}

  		if ({ex_rate_d} > 0)
		    	create timetable /inputs/{mfincomp}/ex_tt
    			setfield /inputs/{mfincomp}/ex_tt \
      				maxtime {synmaxtime} act_val 1.0 method 2              \
      				meth_desc1 {1/{ex_rate_d}} meth_desc2 0 meth_desc3 3
      			call /inputs/{mfincomp}/ex_tt TABFILL

	      		create spikegen /inputs/{mfincomp}/ex_spikegen
      			setfield /inputs/{mfincomp}/ex_spikegen output_amp 1 thresh 0.5
      			addmsg /inputs/{mfincomp}/ex_tt /inputs/{mfincomp}/ex_spikegen INPUT activation
      			addmsg /inputs/{mfincomp}/ex_spikegen {mfincomp}/AMPAd SPIKE
      			addmsg /inputs/{mfincomp}/ex_spikegen {mfincomp}/fNMDAd SPIKE
      			addmsg /inputs/{mfincomp}/ex_spikegen {mfincomp}/sNMDAd SPIKE
  		end

	end
	closefile {MF_infile}

	// add inhibitory synapses to another set of compartments (read in from file)
	openfile {PC_infile} r
	randseed {PC_seed}

	for (i = 1; i <= {no_PC}; i = i + 1)
		pcincomp = {readfile {PC_infile}}

		copy /library/GABA {pcincomp}/GABAd
  		setfield {pcincomp}/GABAd gmax {G_GABAd}
        	addmsg  {pcincomp}/GABAd {pcincomp}  CHANNEL Gk Ek
        	addmsg  {pcincomp} {pcincomp}/GABAd VOLTAGE Vm
		
		if(!{exists /inputs/{pcincomp}}) 
			create neutral /inputs/{pcincomp}
		end

  		if ({inhib_rate_d} > 0)
		    	create timetable /inputs/{pcincomp}/inhib_tt
    			setfield /inputs/{pcincomp}/inhib_tt \
      				maxtime {synmaxtime} act_val 1.0 method 2              \
      				meth_desc1 {1/{inhib_rate_d}} meth_desc2 0 meth_desc3 3
      			call /inputs/{pcincomp}/inhib_tt TABFILL

      			create spikegen /inputs/{pcincomp}/inhib_spikegen
      			setfield /inputs/{pcincomp}/inhib_spikegen output_amp 1 thresh 0.5
      			addmsg /inputs/{pcincomp}/inhib_tt /inputs/{pcincomp}/inhib_spikegen INPUT activation
      			addmsg /inputs/{pcincomp}/inhib_spikegen {pcincomp}/GABAd SPIKE
  		end
	end
	closefile {PC_infile}
end


// update timetables for synaptic input bursts
function add_synburst

	int i
	str pcincomp
	str mfincomp
	int nextseed

	silent 1

	if (exbdur > 0 && exbrate > 0)
		randseed {MF_seed}
		nextseed = {rand 100000 999999}

		if (ex_rate_s > 0)
			call /inputs/soma/ex_tt TUPDATE 2 {exbonset} {{exbonset} + {exbdur}} {1.0 / {{exbrate}*50}}
			randseed {nextseed}
			nextseed = {rand 100000 999999}
		else
  			create timetable /inputs/soma/ex_tt
  			setfield /inputs/soma/ex_tt \
  				maxtime {{exbonset} + {exbdur}} act_val 1.0 method 2 \
  				meth_desc1 {1/{{exbrate}*50}} \
  				meth_desc2 0 meth_desc3 3
  			call /inputs/soma/ex_tt TABFILL
			// Next line takes baseline_rate back to near-zero. 
  			call /inputs/soma/ex_tt TUPDATE 2 0 {exbonset} {10000}
 			create spikegen /inputs/soma/ex_spikegen
  			setfield /inputs/soma/ex_spikegen output_amp 1 thresh 0.5
  			addmsg /inputs/soma/ex_tt /inputs/soma/ex_spikegen INPUT activation
  			addmsg /inputs/soma/ex_spikegen soma/AMPAs SPIKE
		end
	end

	if(inb1dur > 0)
		randseed {PC_seed}
		nextseed = {rand 100000 999999}

		if (inhib_rate_s > 0)
			// Two inhibitory bursts follow each other, inb1 is first and determines onset
			if(inb1rate > 0)
				call /inputs/soma/inhib_tt TUPDATE 2 {inb1onset} {{inb1onset} + {inb1dur}} {1.0 / {{inb1rate}*50}}
			end
			randseed {nextseed}
			nextseed = {rand 100000 999999}
			if(inb2dur > 0)
				call /inputs/soma/inhib_tt TUPDATE 2 {{inb1onset} + {inb1dur}} {{inb1onset} + {inb1dur} + {inb2dur}} {1.0 / {{inb2fac}*{inhib_rate_s}}}
			end
			randseed {nextseed}
			nextseed = {rand 100000 999999}
		else
			if(inb1rate > 0)
  				create timetable /inputs/soma/inhib_tt
  				setfield /inputs/soma/inhib_tt \
  					maxtime {{inb1onset} + {inb1dur} + {inb2dur}} act_val 1.0 method 2 \
  					meth_desc1 {1/{{inb1rate}*50}} \
  					meth_desc2 0 meth_desc3 3
  				call /inputs/soma/inhib_tt TABFILL
				if(inb2dur > 0)
  					call /inputs/soma/inhib_tt TUPDATE 2 {{inb1onset} + {inb1dur}} {{inb1onset} + {inb1dur} + {inb2dur}} {1.0 / {{inb2fac}*{inhib_rate_s}}}
				end
				// Next line takes baseline_rate back to near-zero. 
  				call /inputs/soma/inhib_tt TUPDATE 2 0 {inb1onset} {10000}
  				create spikegen /inputs/soma/inhib_spikegen
  				setfield /inputs/soma/inhib_spikegen output_amp 1 thresh 0.5
  				addmsg /inputs/soma/inhib_tt /inputs/soma/inhib_spikegen INPUT activation
  				addmsg /inputs/soma/inhib_spikegen soma/GABAs SPIKE
			end
		end
	end

	randseed {nextseed}
	nextseed = {rand 100000 999999}
	if (exbdur > 0 && exbrate > 0)
		openfile {MF_infile} r
		for (i = 1; i <= {no_MF}; i = i + 1)
			mfincomp = {readfile {MF_infile}}
			if (ex_rate_d > 0)
				call /inputs/{mfincomp}/ex_tt TUPDATE 2 {exbonset} {{exbonset} + {exbdur}} {1.0 / {exbrate}}
			else
				if(!{exists /inputs/{mfincomp}})
					create neutral /inputs/{mfincomp}
				end
				create timetable /inputs/{mfincomp}/ex_tt
				setfield /inputs/{mfincomp}/ex_tt \
					maxtime {{exbonset} + {exbdur}} act_val 1.0 method 2 \
					meth_desc1 {1/{exbrate}} meth_desc2 0 meth_desc3 3
				call /inputs/{mfincomp}/ex_tt TABFILL
				// Next line takes baseline_rate back to near-zero. 
 				call /inputs/{mfincomp}/ex_tt TUPDATE 2 0 {exbonset} {10000}
	 			create spikegen /inputs/{mfincomp}/ex_spikegen
 				setfield /inputs/{mfincomp}/ex_spikegen output_amp 1 thresh 0.5
 				addmsg /inputs/{mfincomp}/ex_tt /inputs/{mfincomp}/ex_spikegen INPUT activation
 				addmsg /inputs/{mfincomp}/ex_spikegen {mfincomp}/AMPAd SPIKE
			end
		end
		closefile {MF_infile}
	end

	randseed {nextseed}
	nextseed = {rand 100000 999999}
	if (inb1dur > 0)
		openfile {PC_infile} r

		for (i = 1; i <= {no_PC}; i = i + 1)
    			pcincomp = {readfile {PC_infile}}
			if (inhib_rate_d > 0)
				if(inb1rate > 0)
     					call /inputs/{pcincomp}/inhib_tt TUPDATE 2 {inb1onset} {{inb1onset} + {inb1dur}} {1.0 / {inb1rate}}
				end
	 			randseed {nextseed}
	 			nextseed = {rand 100000 999999}
				if(inb2dur > 0)
     					call /inputs/{pcincomp}/inhib_tt TUPDATE 2 {{inb1onset}+{inb1dur}} {{inb1onset}+{inb1dur}+{inb2dur}} {1.0 / {{inb2fac} * {inhib_rate_d}}}
				end
	 			randseed {nextseed}
	 			nextseed = {rand 100000 999999}
			else
				if(inb1rate > 0)
					if(!{exists /inputs/{pcincomp}})
 						create neutral /inputs/{pcincomp}
					end
 					create timetable /inputs/{pcincomp}/inhib_tt
 					setfield /inputs/{pcincomp}/inhib_tt \
 						maxtime {{inb1onset} + {inb1dur}} act_val 1.0 method 2  \
 						meth_desc1 {1/{inb1rate}} meth_desc2 0 meth_desc3 3
 					call /inputs/{pcincomp}/inhib_tt TABFILL
					if(inb2dur > 0)
						call /inputs/{pcincomp}/inhib_tt TUPDATE 2 {{inb1onset} + {inb1dur}} {{inb1onset} + {inb1dur} + {inb2dur}} {1.0 / {{inb2fac} * {inhib_rate_d}}}
					end
	 				randseed {nextseed}
	 				nextseed = {rand 100000 999999}
					// Next line takes baseline_rate back to near-zero. 
 					call /inputs/{pcincomp}/inhib_tt TUPDATE 2 0 {inb1onset} {10000}
 					create spikegen /inputs/{pcincomp}/inhib_spikegen
 					setfield /inputs/{pcincomp}/inhib_spikegen output_amp 1 thresh 0.5
 					addmsg /inputs/{pcincomp}/inhib_tt /inputs/{pcincomp}/inhib_spikegen INPUT activation
 					addmsg /inputs/{pcincomp}/inhib_spikegen {pcincomp}/GABAd SPIKE
				end
			end
		end
		closefile {PC_infile}
	end

	silent -1
end

