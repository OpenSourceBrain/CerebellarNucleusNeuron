//genesis

function make_cn_comps

  float shell_vol

  echo making CN compartment library...
  
  // soma prototype
  if (!({exists CN_soma}))
    create compartment CN_soma
  end

  setfield CN_soma Cm {{CM}*soma_area} Ra {8.0*{RA}/(soma_d*{PI})} \
     		   Em {ELEAK} initVm {EREST_ACT} Rm {{RMs}/soma_area} inject 0.0 \
     		   dia {soma_d} len {soma_l}
  shell_vol = {PI}/3.0*(3.0*soma_d*soma_d*shell_thick - 6.0*soma_d*shell_thick*shell_thick + 4.0*shell_thick*shell_thick*shell_thick)

  // add currents to soma prototype
  copy GHK CN_soma/GHKs
  addmsg CN_soma CN_soma/GHKs VOLTAGE Vm
  addmsg CN_soma/GHKs CN_soma CHANNEL Gk Ek			

  copy NaF CN_soma/NaFs
  addmsg CN_soma CN_soma/NaFs VOLTAGE Vm
  addmsg CN_soma/NaFs CN_soma CHANNEL Gk Ek
  setfield CN_soma/NaFs Gbar {soma_area*{GNaFs}}	
  
  copy NaP CN_soma/NaPs
  addmsg CN_soma CN_soma/NaPs VOLTAGE Vm
  addmsg CN_soma/NaPs CN_soma CHANNEL Gk Ek
  setfield CN_soma/NaPs Gbar {soma_area*{GNaPs}}
  
  copy TNC CN_soma/TNCs
  addmsg CN_soma CN_soma/TNCs VOLTAGE Vm
  addmsg CN_soma/TNCs CN_soma CHANNEL Gk Ek
  setfield CN_soma/TNCs Gbar {soma_area*{GTNCs}}	

  copy fKdr CN_soma/fKdrs
  addmsg CN_soma CN_soma/fKdrs VOLTAGE Vm
  addmsg CN_soma/fKdrs CN_soma CHANNEL Gk Ek
  setfield CN_soma/fKdrs Gbar {soma_area*{GfKdrs}}	

  copy sKdr CN_soma/sKdrs
  addmsg CN_soma CN_soma/sKdrs VOLTAGE Vm
  addmsg CN_soma/sKdrs CN_soma CHANNEL Gk Ek
  setfield CN_soma/sKdrs Gbar {soma_area*{GsKdrs}}	

  copy Sk CN_soma/Sks
  addmsg CN_soma/Sks CN_soma CHANNEL Gk Ek
  setfield CN_soma/Sks Gbar {soma_area*{GSks}}	

  copy h_slow CN_soma/h_slows
  addmsg CN_soma CN_soma/h_slows VOLTAGE Vm
  addmsg CN_soma/h_slows CN_soma CHANNEL Gk Ek
  setfield CN_soma/h_slows Gbar {soma_area*{Ghs}}	

  copy CaLVA CN_soma/CaLVAs
  addmsg CN_soma CN_soma/CaLVAs VOLTAGE Vm
  setfield CN_soma/CaLVAs Gbar {soma_area*{GCaLVAs}}
  addmsg CN_soma/CaLVAs CN_soma CHANNEL Gk Ek 

  copy CaHVA CN_soma/CaHVAs
  addmsg CN_soma CN_soma/CaHVAs VOLTAGE Vm
  setfield CN_soma/CaHVAs Gbar {soma_area*{GCaHVAs}}	
  addmsg CN_soma/CaHVAs CN_soma/GHKs ADD_GBAR Gk 

  create Ca_concen CN_soma/Ca_pool
  setfield CN_soma/Ca_pool tau {catau} \
                           B {{kCas}/{shell_vol}} \
                           Ca_base {CCaI} \
                           thick {shell_thick}
  addmsg CN_soma/GHKs CN_soma/Ca_pool I_Ca Ik
  addmsg CN_soma/Ca_pool CN_soma/GHKs CONCEN1 Ca
  addmsg CN_soma/Ca_pool CN_soma/Sks CONCEN Ca
  

  // axon hillock prototype
  if (!({exists CN_axHill}))
        create compartment CN_axHill
  end
  setfield CN_axHill Cm {{CM}*axon_area} Ra {4.0*{RA}*axon_l/(axon_d*axon_d*{PI})} \
     Em {ELEAK} initVm {EREST_ACT} Rm {{RMs}/axon_area} inject 0.0 \
     dia {axon_d} len {axon_l}
  shell_vol = {PI}*axon_l*(axon_d*shell_thick - shell_thick*shell_thick)

  // add currents to axon hillock prototype - initially only NaF and fKdr
  copy NaF CN_axHill/NaFa
  addmsg CN_axHill CN_axHill/NaFa VOLTAGE Vm
  addmsg CN_axHill/NaFa CN_axHill CHANNEL Gk Ek
  setfield CN_axHill/NaFa Gbar {axon_area*{GNaFaxHill}}	

  copy TNC CN_axHill/TNCa
  addmsg CN_axHill CN_axHill/TNCa VOLTAGE Vm
  addmsg CN_axHill/TNCa CN_axHill CHANNEL Gk Ek
  setfield CN_axHill/TNCa Gbar {axon_area*{GTNCaxHill}}	

  copy fKdr CN_axHill/fKdra
  addmsg CN_axHill CN_axHill/fKdra VOLTAGE Vm
  addmsg CN_axHill/fKdra CN_axHill CHANNEL Gk Ek
  setfield CN_axHill/fKdra Gbar {axon_area*{GfKdraxHill}}	

  copy sKdr CN_axHill/sKdra
  addmsg CN_axHill CN_axHill/sKdra VOLTAGE Vm
  addmsg CN_axHill/sKdra CN_axHill CHANNEL Gk Ek
  setfield CN_axHill/sKdra Gbar {axon_area*{GsKdraxHill}}	

  // axon initial segment prototype
  if (!({exists CN_axIS}))
        create compartment CN_axIS
  end
  setfield CN_axIS Cm {{CM}*axon_area} Ra {4.0*{RA}*axon_l/(axon_d*axon_d*{PI})} \
     Em {ELEAKax} initVm {EREST_ACT} Rm {{RMax}/axon_area} inject 0.0 \
     dia {axon_d} len {axon_l}
  shell_vol = {PI}*axon_l*(axon_d*shell_thick - shell_thick*shell_thick)

  // add currents - initially only NaF and fKdr
  copy NaF CN_axIS/NaFa
  addmsg CN_axIS CN_axIS/NaFa VOLTAGE Vm
  addmsg CN_axIS/NaFa CN_axIS CHANNEL Gk Ek
  setfield CN_axIS/NaFa Gbar {axon_area*{GNaFaxIS}}	

  copy TNC CN_axIS/TNCa
  addmsg CN_axIS CN_axIS/TNCa VOLTAGE Vm
  addmsg CN_axIS/TNCa CN_axIS CHANNEL Gk Ek
  setfield CN_axIS/TNCa Gbar {axon_area*{GTNCaxIS}}	

  copy fKdr CN_axIS/fKdra
  addmsg CN_axIS CN_axIS/fKdra VOLTAGE Vm
  addmsg CN_axIS/fKdra CN_axIS CHANNEL Gk Ek
  setfield CN_axIS/fKdra Gbar {axon_area*{GfKdraxIS}}

  copy sKdr CN_axIS/sKdra
  addmsg CN_axIS CN_axIS/sKdra VOLTAGE Vm
  addmsg CN_axIS/sKdra CN_axIS CHANNEL Gk Ek
  setfield CN_axIS/sKdra Gbar {axon_area*{GsKdraxIS}}

  // axon internodal segment prototype - no channels
  if (!({exists CN_axIN}))
        create compartment CN_axIN
  end
  setfield CN_axIN Cm {{CMmy}*axon_area} Ra {4.0*{RA}*axon_l/(axon_d*axon_d*{PI})} \
     Em {ELEAKax} initVm {EREST_ACT} Rm {{RMmy}/axon_area} inject 0.0 \
     dia {axon_d} len {axon_l}
  shell_vol = {PI}*axon_l*(axon_d*shell_thick - shell_thick*shell_thick)

  
  // proximal dendrite prototype
  if (!({exists CN_pdend}))
        create compartment CN_pdend
  end
  setfield CN_pdend Cm {{CM}*dend_area} Ra {4.0*{RA}*dend_l/(dend_d*dend_d*{PI})} \
     Em {ELEAK} initVm {EREST_ACT} Rm {{RMd}/dend_area} inject 0.0 \
     dia {dend_d} len {dend_l}
  shell_vol = {PI}*dend_l*(dend_d*shell_thick - shell_thick*shell_thick)
  
  // first copy proximal to distal dendrite prototype
  if (!({exists CN_ddend}))
        copy CN_pdend CN_ddend 
  end

  // add currents to proximal dendrite prototype
  copy GHK CN_pdend/GHKpd
  addmsg CN_pdend CN_pdend/GHKpd VOLTAGE Vm
  addmsg CN_pdend/GHKpd CN_pdend CHANNEL Gk Ek			

  copy NaF CN_pdend/NaFpd
  addmsg CN_pdend CN_pdend/NaFpd VOLTAGE Vm
  addmsg CN_pdend/NaFpd CN_pdend CHANNEL Gk Ek
  setfield CN_pdend/NaFpd Gbar {dend_area*{GNaFpd}}	

  copy TNC CN_pdend/TNCpd
  addmsg CN_pdend CN_pdend/TNCpd VOLTAGE Vm
  addmsg CN_pdend/TNCpd CN_pdend CHANNEL Gk Ek
  setfield CN_pdend/TNCpd Gbar {dend_area*{GTNCpd}}	

  copy NaP CN_pdend/NaPpd
  addmsg CN_pdend CN_pdend/NaPpd VOLTAGE Vm
  addmsg CN_pdend/NaPpd CN_pdend CHANNEL Gk Ek
  setfield CN_pdend/NaPpd Gbar {dend_area*{GNaPpd}}	

  copy fKdr CN_pdend/fKdrpd
  addmsg CN_pdend CN_pdend/fKdrpd VOLTAGE Vm
  addmsg CN_pdend/fKdrpd CN_pdend CHANNEL Gk Ek
  setfield CN_pdend/fKdrpd Gbar {dend_area*{GfKdrpd}}	

  copy sKdr CN_pdend/sKdrpd
  addmsg CN_pdend CN_pdend/sKdrpd VOLTAGE Vm
  addmsg CN_pdend/sKdrpd CN_pdend CHANNEL Gk Ek
  setfield CN_pdend/sKdrpd Gbar {dend_area*{GsKdrpd}}	

  copy Sk CN_pdend/Skpd
  addmsg CN_pdend/Skpd CN_pdend CHANNEL Gk Ek
  setfield CN_pdend/Skpd Gbar {dend_area*{GSkpd}}	

  copy h_slow CN_pdend/h_slowpd
  addmsg CN_pdend CN_pdend/h_slowpd VOLTAGE Vm
  addmsg CN_pdend/h_slowpd CN_pdend CHANNEL Gk Ek
  setfield CN_pdend/h_slowpd Gbar {dend_area*{Ghpd}}	

  copy CaLVA CN_pdend/CaLVApd
  addmsg CN_pdend CN_pdend/CaLVApd VOLTAGE Vm
  setfield CN_pdend/CaLVApd Gbar {dend_area*{GCaLVApd}}	
  addmsg CN_pdend/CaLVApd CN_pdend CHANNEL Gk Ek 

  copy CaHVA CN_pdend/CaHVApd
  addmsg CN_pdend CN_pdend/CaHVApd VOLTAGE Vm
  setfield CN_pdend/CaHVApd Gbar {dend_area*{GCaHVApd}}	
  addmsg CN_pdend/CaHVApd CN_pdend/GHKpd ADD_GBAR Gk 

  create Ca_concen CN_pdend/Ca_pool
  setfield CN_pdend/Ca_pool tau {catau} \
                              B {{kCad}/{shell_vol}} \
                              Ca_base {CCaI} \
                              thick {shell_thick}
  addmsg CN_pdend/GHKpd CN_pdend/Ca_pool I_Ca Ik 
  addmsg CN_pdend/Ca_pool CN_pdend/GHKpd CONCEN1 Ca
  addmsg CN_pdend/Ca_pool CN_pdend/Skpd CONCEN Ca
 

  // add currents to distal dendrite prototype
  copy GHK CN_ddend/GHKdd
  addmsg CN_ddend CN_ddend/GHKdd VOLTAGE Vm
  addmsg CN_ddend/GHKdd CN_ddend CHANNEL Gk Ek			

  copy NaF CN_ddend/NaFdd
  addmsg CN_ddend CN_ddend/NaFdd VOLTAGE Vm
  addmsg CN_ddend/NaFdd CN_ddend CHANNEL Gk Ek
  setfield CN_ddend/NaFdd Gbar {dend_area*{GNaFdd}}	

  copy TNC CN_ddend/TNCdd
  addmsg CN_ddend CN_ddend/TNCdd VOLTAGE Vm
  addmsg CN_ddend/TNCdd CN_ddend CHANNEL Gk Ek
  setfield CN_ddend/TNCdd Gbar {dend_area*{GTNCdd}}	

  copy NaP CN_ddend/NaPdd
  addmsg CN_ddend CN_ddend/NaPdd VOLTAGE Vm
  addmsg CN_ddend/NaPdd CN_ddend CHANNEL Gk Ek
  setfield CN_ddend/NaPdd Gbar {dend_area*{GNaPdd}}	

  copy fKdr CN_ddend/fKdrdd
  addmsg CN_ddend CN_ddend/fKdrdd VOLTAGE Vm
  addmsg CN_ddend/fKdrdd CN_ddend CHANNEL Gk Ek
  setfield CN_ddend/fKdrdd Gbar {dend_area*{GfKdrdd}}	

  copy Sk CN_ddend/Skdd
  addmsg CN_ddend/Skdd CN_ddend CHANNEL Gk Ek
  setfield CN_ddend/Skdd Gbar {dend_area*{GSkdd}}	

  copy h_slow CN_ddend/h_slowdd
  addmsg CN_ddend CN_ddend/h_slowdd VOLTAGE Vm
  addmsg CN_ddend/h_slowdd CN_ddend CHANNEL Gk Ek
  setfield CN_ddend/h_slowdd Gbar {dend_area*{Ghdd}}	

  copy CaLVA CN_ddend/CaLVAdd
  addmsg CN_ddend CN_ddend/CaLVAdd VOLTAGE Vm
  setfield CN_ddend/CaLVAdd Gbar {dend_area*{GCaLVAdd}}	
  addmsg CN_ddend/CaLVAdd CN_ddend CHANNEL Gk Ek  

  copy CaHVA CN_ddend/CaHVAdd
  addmsg CN_ddend CN_ddend/CaHVAdd VOLTAGE Vm
  setfield CN_ddend/CaHVAdd Gbar {dend_area*{GCaHVAdd}}	
  addmsg CN_ddend/CaHVAdd CN_ddend/GHKdd ADD_GBAR Gk 

  create Ca_concen CN_ddend/Ca_pool
  setfield CN_ddend/Ca_pool tau {catau} \
                              B {{kCad}/{shell_vol}} \
                              Ca_base {CCaI} \
                              thick {shell_thick}
  addmsg CN_ddend/GHKdd CN_ddend/Ca_pool I_Ca Ik
  addmsg CN_ddend/Ca_pool CN_ddend/GHKdd CONCEN1 Ca
  addmsg CN_ddend/Ca_pool CN_ddend/Skdd CONCEN Ca

  echo done.

end
