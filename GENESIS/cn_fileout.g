// genesis
// functions to write simulation results to files

function write_voltage(compt, comptnum)
str compt, comptnum
str hinesloc, outfile, outelement

     outfile = {outfilev @ compt @ comptnum @ ".dat"} 
     outelement = "/output/v_" @ {compt} @ {comptnum}

     if (comptnum)
          compt = {compt} @ "[" @ {comptnum} @ "]"
     end

     if (!{exists {outelement}})
          create asc_file {outelement}
          echo
          echo creating output element {outelement}
          useclock {outelement} 8
	  hinesloc = {findsolvefield {cellpath} {cellpath}/{compt} Vm}
	  addmsg {cellpath} {outelement} SAVE {hinesloc}
     end

     setfield {outelement}      filename {outfile} \
                                initialize 1 \
                                leave_open 1 \
                                append 1

     echo
     echo sending {cellpath}/{compt} Vm to {outfile}. 

end


function write_chancurrents(compt, comptnum)
str compt, comptnum
str hinesloc, channame, outfile, outelement

     outfile = {outfilei @ compt @ comptnum @ ".dat"} 
     outelement = "/output/i_" @ {compt} @ {comptnum}
    
     if (comptnum)
          compt = {compt} @ "[" @ {comptnum} @ "]"
     end

     if (!{exists {outelement}})
          create asc_file {outelement}
          echo
          echo creating output element {outelement}
          useclock {outelement} 8

          foreach channame ({el {cellpath}/{compt}/##[][TYPE=tabchannel]})
	         hinesloc={findsolvefield {cellpath} {channame} Ik}
                 addmsg {cellpath} {outelement} SAVE {hinesloc}
          end
		
          foreach channame ({el {cellpath}/{compt}/##[][TYPE=tab2Dchannel]})
	         hinesloc={findsolvefield {cellpath} {channame} Ik}
	         addmsg {cellpath} {outelement} SAVE {hinesloc}
          end
     end

     setfield {outelement}      filename {outfile} \
                                initialize 1 \
                                leave_open 1 \
                                append 1

     echo
     foreach channame ({el {cellpath}/{compt}/##[][TYPE=tabchannel]})
          echo sending {channame} Ik to {outfile}. 
     end
		
     foreach channame ({el {cellpath}/{compt}/##[][TYPE=tab2Dchannel]})
          echo sending {channame} Ik to {outfile}.
     end

end
 

function write_chancurrents_ca(compt, comptnum)
str compt, comptnum
str hinesloc, channame, outfile, outelement

     outfile = {outfilei @ compt @ comptnum @ ".dat"} 
     outelement = "/output/i_" @ {compt} @ {comptnum}
    
     if (comptnum)
          compt = {compt} @ "[" @ {comptnum} @ "]"
     end

     if (!{exists {outelement}})
          create asc_file {outelement}
          echo
          echo creating output element {outelement}
          useclock {outelement} 8

          foreach channame ({el {cellpath}/{compt}/##[][TYPE=tabchannel]})
	         hinesloc={findsolvefield {cellpath} {channame} Ik}
                 addmsg {cellpath} {outelement} SAVE {hinesloc}
          end
		
          foreach channame ({el {cellpath}/{compt}/##[][TYPE=tab2Dchannel]})
	         hinesloc={findsolvefield {cellpath} {channame} Ik}
	         addmsg {cellpath} {outelement} SAVE {hinesloc}
          end

	  foreach channame ({el {cellpath}/{compt}/##[][TYPE=Ca_concen]})
	         hinesloc={findsolvefield {cellpath} {channame} Ca}
	         addmsg {cellpath} {outelement} SAVE {hinesloc}
          end

     end

     setfield {outelement}      filename {outfile} \
                                initialize 1 \
                                leave_open 1 \
                                append 1

     echo
     foreach channame ({el {cellpath}/{compt}/##[][TYPE=tabchannel]})
          echo sending {channame} Ik to {outfile}. 
     end
		
     foreach channame ({el {cellpath}/{compt}/##[][TYPE=tab2Dchannel]})
          echo sending {channame} Ik to {outfile}.
     end

     foreach channame ({el {cellpath}/{compt}/##[][TYPE=Ca_concen]})
      	  echo sending {channame} Ca to {outfile}.
     end

end
 

function write_chan_activations(compt, comptnum)
str compt, comptnum
str hinesloc, channame, outfile, outelement

     outfile = {outfilechan @ compt @ comptnum @ ".dat"} 
     outelement = "/output/chan_" @ {compt} @ {comptnum}
    
     if (comptnum)
          compt = {compt} @ "[" @ {comptnum} @ "]"
     end

     if (!{exists {outelement}})
          create asc_file {outelement}
          echo
          echo creating output element {outelement}
          useclock {outelement} 8

          foreach channame ({el {cellpath}/{compt}/##[][TYPE=tabchannel]})
	         hinesloc={findsolvefield {cellpath} {channame} X}
                 addmsg {cellpath} {outelement} SAVE {hinesloc}
	         hinesloc={findsolvefield {cellpath} {channame} Y}
                 addmsg {cellpath} {outelement} SAVE {hinesloc}
	         hinesloc={findsolvefield {cellpath} {channame} Z}
                 addmsg {cellpath} {outelement} SAVE {hinesloc}
          end
		
          foreach channame ({el {cellpath}/{compt}/##[][TYPE=tab2Dchannel]})
	         hinesloc={findsolvefield {cellpath} {channame} X}
                 addmsg {cellpath} {outelement} SAVE {hinesloc}
          end
	  
     end

     setfield {outelement}      filename {outfile} \
                                initialize 1 \
                                leave_open 1 \
                                append 1

     echo
     foreach channame ({el {cellpath}/{compt}/##[][TYPE=tabchannel]})
          echo sending {channame} X to {outfile}. 
          echo sending {channame} Y to {outfile}. 
          echo sending {channame} Z to {outfile}. 
     end
		
     foreach channame ({el {cellpath}/{compt}/##[][TYPE=tab2Dchannel]})
          echo sending {channame} X to {outfile}.
     end

end
 

function write_syncurrents(compt, comptnum)
str compt, comptnum
str hinesloc, channame, outfile, outelement

     outfile = {outfilesyn @ compt @ comptnum @ ".dat"} 
     outelement = "/output/syn_" @ {compt} @ {comptnum}

     if (comptnum)
        compt = {compt} @ "[" @ {comptnum} @ "]"
     end

     if (!{exists {outelement}})
        create asc_file {outelement}
        echo
        echo creating output element {outelement}
        useclock {outelement} 8

	foreach channame ({el {cellpath}/{compt}/##[][TYPE=synchan]})
        	hinesloc={findsolvefield {cellpath} {channame} Ik}
          	addmsg {cellpath} {outelement} SAVE {hinesloc}
    	end

    	foreach channame ({el {cellpath}/{compt}/##[][TYPE=Mg_block]})
         	hinesloc={findsolvefield {cellpath} {channame} Ik}
         	addmsg {cellpath} {outelement} SAVE {hinesloc}
    	end
	  
     end

     setfield {outelement}      filename {outfile} \
                                initialize 1 \
                                leave_open 1 \
                                append 1
    
     foreach channame ({el {cellpath}/{compt}/##[][TYPE=synchan]})
 	 	echo sending {channame} Ik to {outfile}.
     end

     foreach channame ({el {cellpath}/{compt}/##[][TYPE=Mg_block]})
 	 	echo sending {channame} Ik to {outfile}.
     end

end


function write_syncurrents_itotal
str outfile, outelement

     outfile = {outfilesyntotal} @ ".dat"
     outelement = "/output/syntotal"

     if (!{exists {outelement}})
        create asc_file {outelement}
        echo
        echo creating output element {outelement}
        useclock {outelement} 8

     	addmsg {cellpath} {outelement} SAVE itotal[12] // 1 AMPAd
     	addmsg {cellpath} {outelement} SAVE itotal[14] // 2 fNMDAd
     	addmsg {cellpath} {outelement} SAVE itotal[16] // 3 sNMDAd
     	addmsg {cellpath} {outelement} SAVE itotal[17] // 4 GABAd
     	addmsg {cellpath} {outelement} SAVE itotal[45] // 5 AMPAs
     	addmsg {cellpath} {outelement} SAVE itotal[47] // 6 fNMDAs
     	addmsg {cellpath} {outelement} SAVE itotal[49] // 7 sNMDAs
     	addmsg {cellpath} {outelement} SAVE itotal[44] // 8 GABAs

     end

     setfield {outelement}      filename {outfile} \
                                initialize 1 \
                                leave_open 1 \
                                append 1
   
     echo sending total synaptic currents to {outfile}.

end


function write_chancurrents_itotal
str outfile, outelement

     outfile = {outfileitotal} @ ".dat"
     outelement = "/output/itotal"

     if (!{exists {outelement}})
        create asc_file {outelement}
        echo
        echo creating output element {outelement}
        useclock {outelement} 8

     	addmsg {cellpath} {outelement} SAVE itotal[3] // 1 TNCdd
     	addmsg {cellpath} {outelement} SAVE itotal[6] // 2 skdd
     	addmsg {cellpath} {outelement} SAVE itotal[8] // 3 hslowdd
     	addmsg {cellpath} {outelement} SAVE itotal[9] // 4 LVAdd
     	addmsg {cellpath} {outelement} SAVE itotal[10] // 5 HVAdd
     	addmsg {cellpath} {outelement} SAVE itotal[20] // 6 TNCpd
     	addmsg {cellpath} {outelement} SAVE itotal[22] // 7 fKdrpd
     	addmsg {cellpath} {outelement} SAVE itotal[23] // 8 sKdrpd
     	addmsg {cellpath} {outelement} SAVE itotal[24] // 9 skpd
     	addmsg {cellpath} {outelement} SAVE itotal[26] // 10 hslowpd
     	addmsg {cellpath} {outelement} SAVE itotal[27] // 11 LVApd
     	addmsg {cellpath} {outelement} SAVE itotal[28] // 12 HVApd
     	addmsg {cellpath} {outelement} SAVE itotal[36] // 13 TNCs
     	addmsg {cellpath} {outelement} SAVE itotal[39] // 14 sks
     	addmsg {cellpath} {outelement} SAVE itotal[41] // 15 hslows
     	addmsg {cellpath} {outelement} SAVE itotal[42] // 16 LVAs
     	addmsg {cellpath} {outelement} SAVE itotal[43] // 17 HVAs
     	addmsg {cellpath} {outelement} SAVE itotal[34] // 18 NaFs
     	addmsg {cellpath} {outelement} SAVE itotal[35] // 19 NaPs
     	addmsg {cellpath} {outelement} SAVE itotal[37] // 20 fKdrs
     	addmsg {cellpath} {outelement} SAVE itotal[38] // 21 sKdrs
     	addmsg {cellpath} {outelement} SAVE itotal[29] // 22 NaFa
     	addmsg {cellpath} {outelement} SAVE itotal[31] // 23 fKdra

    end

    setfield {outelement}      filename {outfile} \
                               initialize 1 \
                               leave_open 1 \
                               append 1
 

    echo sending total voltage gated channel currents to {outfile}.    

end
