//genesis

// create fast Na channel
function make_NaF
  
  	echo creating fast Na channel

  	int i
  	float x, dx
  	float tau, act

  	if ({exists NaF})
    		return
  	end

  	create tabchannel NaF
  	setfield NaF Ek {ENa} Gbar {Ginit} Ik 0 Gk 0 Xpower 3 Ypower 1 Zpower 0

  	// activation
  	call NaF TABCREATE X {tab_xdivs} {tab_xmin} {tab_xmax}

  	x = {tab_xmin}
  	dx = ({tab_xmax} - {tab_xmin})/{tab_xdivs}

  	for (i = 0; i <= {tab_xdivs}; i = i + 1)

    		tau = 5.833e-3/({exp {(x - 0.0064)/-0.009}} + {exp {(x + 0.097)/0.017}}) + 2.5e-5
    		tau = tau/QDeltaT
    		act = 1.0/(1.0 + {exp {(x + 0.045)/-0.007324}})

    		setfield NaF X_A->table[{i}] {tau}
    		setfield NaF X_B->table[{i}] {act}

    		x = x + dx
	
	end

  	tweaktau NaF X
  	setfield NaF X_A->calc_mode {tab_calcmode}
  	setfield NaF X_B->calc_mode {tab_calcmode}
  	call NaF TABFILL X {tab_xfills} 0

  	// inactivation
  	call NaF TABCREATE Y {tab_xdivs} {tab_xmin} {tab_xmax}

  	x = {tab_xmin}

  	for (i = 0; i <= {tab_xdivs}; i = i + 1)

     		tau = 16.67e-3/({exp {(x - 0.0083)/-0.029}} + {exp {(x + 0.066)/0.009}}) + 2.0e-04
   	 	tau = tau/QDeltaT 
      		act = 1.0/(1.0 + {exp {(x + 0.042)/0.0059}})
    
    		setfield NaF Y_A->table[{i}] {tau}
    		setfield NaF Y_B->table[{i}] {act}

    		x = x + dx

  	end

  	tweaktau NaF Y
  	setfield NaF Y_A->calc_mode {tab_calcmode}
  	setfield NaF Y_B->calc_mode {tab_calcmode}
  	call NaF TABFILL Y {tab_xfills} 0

end


// create persistent Na channel
function make_NaP
  
  	echo creating persistent Na channel

  	int i
  	float x, dx
  	float tau, act
  	float alpha, beta

  	if ({exists NaP})
    		return
  	end

  	create tabchannel NaP
  	setfield NaP Ek {ENa} Gbar {Ginit} Ik 0 Gk 0 Xpower 3 Ypower 1 Zpower 0

  	// activation
  	call NaP TABCREATE X {tab_xdivs} {tab_xmin} {tab_xmax}

  	x = {tab_xmin}
  	dx = ({tab_xmax} - {tab_xmin})/{tab_xdivs}

  	for (i = 0; i <= {tab_xdivs}; i = i + 1)
    
    		tau = 0.05/QDeltaT
		act = 1.0/(1.0 + {exp {(x + 0.070)/-0.0041}})
		    
    		setfield NaP X_A->table[{i}] {tau}
    		setfield NaP X_B->table[{i}] {act}

    		x = x + dx

  	end

  	tweaktau NaP X
  	setfield NaP X_A->calc_mode {tab_calcmode}
  	setfield NaP X_B->calc_mode {tab_calcmode}
  	call NaP TABFILL X {tab_xfills} 0

  	// inactivation
  	call NaP TABCREATE Y {tab_xdivs} {tab_xmin} {tab_xmax}

  	x = {tab_xmin}

  	for (i = 0; i <= {tab_xdivs}; i = i + 1)

    		tau = 0.25 + 1.75/(1.0 + {exp {(x + 0.065)/-0.008}})
		tau = tau/QDeltaT
    		act = 1.0/(1.0 + {exp {(x + 0.080)/0.004}})
    
    		setfield NaP Y_A->table[{i}] {tau}
    		setfield NaP Y_B->table[{i}] {act}

   	 	x = x + dx

  	end

  	tweaktau NaP Y
  	setfield NaP Y_A->calc_mode {tab_calcmode}
  	setfield NaP Y_B->calc_mode {tab_calcmode}
  	call NaP TABFILL Y {tab_xfills} 0

end


// create fast delayed rectifier Kv3 
function make_fKdr
  
  	echo creating fast delayed rectifier

  	int i
  	float x, dx
  	float tau, act

  	if ({exists fKdr})
    		return
  	end

 	create tabchannel fKdr
  	setfield fKdr Ek {EK} Gbar {Ginit} Ik 0 Gk 0 Xpower 4 Ypower 0 Zpower 0

  	// activation
  	call fKdr TABCREATE X {tab_xdivs} {tab_xmin} {tab_xmax}

  	x = {tab_xmin}
  	dx = ({tab_xmax} - {tab_xmin})/{tab_xdivs}

  	for (i = 0; i <= {tab_xdivs}; i = i + 1)

		tau = 0.0001 + (0.0139/({exp { (-0.040 - x)/-0.012 } } + {exp {-(-0.040 - x)/-0.013 }}))
		tau = tau/QDeltaT
		act = 1/(1 + {exp { (-0.040 - x)/0.0078 } } )
		
    		setfield fKdr X_A->table[{i}] {tau}
    		setfield fKdr X_B->table[{i}] {act}

    		x = x + dx

  	end

  	tweaktau fKdr X
  	setfield fKdr X_A->calc_mode {tab_calcmode}
  	setfield fKdr X_B->calc_mode {tab_calcmode}
  	call fKdr TABFILL X {tab_xfills} 0

end


// create slow delayed rectifier Kv2
function make_sKdr
  
  	echo creating slow delayed rectifier

  	int i
  	float x, dx
  	float tau, act

  	if ({exists sKdr})
    		return
  	end

  	create tabchannel sKdr
  	setfield sKdr Ek {EK} Gbar {Ginit} Ik 0 Gk 0 Xpower 4 Ypower 0 Zpower 0

  	// activation
  	call sKdr TABCREATE X {tab_xdivs} {tab_xmin} {tab_xmax}

  	x = {tab_xmin}
  	dx = ({tab_xmax} - {tab_xmin})/{tab_xdivs}

  	for (i = 0; i <= {tab_xdivs}; i = i + 1)

		tau = 5.0e-5 + (0.01495 / ({exp { (-0.050 - x) / -0.02174 } } + {exp {-(-0.050 - x) / -0.01391 }}))
		tau = tau/QDeltaT
		act = 1 / (1 + {exp { (-0.050 - x) / 0.0091 } } )
		
    		setfield sKdr X_A->table[{i}] {tau}
    		setfield sKdr X_B->table[{i}] {act}

    		x = x + dx

  	end

  	tweaktau sKdr X
  	setfield sKdr X_A->calc_mode {tab_calcmode}
  	setfield sKdr X_B->calc_mode {tab_calcmode}
  	call sKdr TABFILL X {tab_xfills} 0

end


// create small conductance KCa channel
function make_Sk

  	echo creating small conductance KCa channel

  	int i
  	float y, dy
  	float tau, act

  	if ({exists Sk})
    		return
  	end

  	create tabchannel Sk
  	setfield Sk Ek {EK} Gbar {Ginit} Ik 0 Gk 0 Xpower 0 Ypower 0 Zpower 1

  	call Sk TABCREATE Z {tab_ydivs} {tab_ymin} {tab_ymax}

  	y = {tab_ymin}
  	dy = ({tab_ymax} - {tab_ymin})/{tab_ydivs}

  	for (i = 0; i <= {tab_ydivs}; i = i + 1)
    
    		if ({y < 0.005}) 
      			tau = 0.001 - y*0.1867
    		else
      			tau = 6.667e-5
    		end
    		tau = tau/QDeltaT 
    		act = {pow {y} {4.0}}/({pow {y} {4.0}} + {pow {0.3e-3} {4.0}})

    		setfield Sk Z_A->table[{i}] {tau}
    		setfield Sk Z_B->table[{i}] {act}

    		y = y + dy

  	end

  	tweaktau Sk Z
  	setfield Sk Z_A->calc_mode {tab_calcmode}
  	setfield Sk Z_B->calc_mode {tab_calcmode}
  	call Sk TABFILL Z {tab_xfills} 0

end


// create slow h current
function make_h_slow

  	echo creating slow h current

  	int i
  	float x, dx
  	float tau, act

  	if ({exists h_slow})
    		return
  	end

  	create tabchannel h_slow
  	setfield h_slow Ek {Eh} Gbar {Ginit} Ik 0 Gk 0 Xpower 2 Ypower 0 Zpower 0

  	// activation
  	call h_slow TABCREATE X {tab_xdivs} {tab_xmin} {tab_xmax}

  	x = {tab_xmin}
  	dx = ({tab_xmax} - {tab_xmin})/{tab_xdivs}

  	for (i = 0; i <= {tab_xdivs}; i = i + 1)

    		tau = 0.4
		tau = tau/QDeltaT
        	act = 1.0/(1.0 + {exp {(x + 0.080)/0.005}})

    		setfield h_slow X_A->table[{i}] {tau}
    		setfield h_slow X_B->table[{i}] {act}

    		x = x + dx

  	end

  	tweaktau h_slow X
  	setfield h_slow X_A->calc_mode {tab_calcmode}
  	setfield h_slow X_B->calc_mode {tab_calcmode}
  	call h_slow TABFILL X {tab_xfills} 0

end


// create low voltage activated calcium channel
function make_CaLVA
 
  	echo creating low voltage activated Ca channel

  	int i
  	float x, dx
  	float tau, act

  	if ({exists CaLVA})
    		return
  	end

  	create tabchannel CaLVA
  	setfield CaLVA Ek {ECa} Gbar {Ginit} Ik 0 Gk 0 Xpower 2 Ypower 1 Zpower 0

  	// activation
  	call CaLVA TABCREATE X {tab_xdivs} {tab_xmin} {tab_xmax}

  	x = {tab_xmin}
  	dx = ({tab_xmax} - {tab_xmin})/{tab_xdivs}

  	for (i = 0; i <= {tab_xdivs}; i = i + 1)

		tau = 0.000204 + 0.333e-3/({exp {(x + 0.131)/-0.0167}} + {exp {(x + 0.0158)/0.0182}})
		tau = tau/QDeltaT
		act = 1.0/(1.0 + {exp {(x + 0.056)/-0.0062}})

    		setfield CaLVA X_A->table[{i}] {tau}
    		setfield CaLVA X_B->table[{i}] {act}

    		x = x + dx

  	end

  	tweaktau CaLVA X
  	setfield CaLVA X_A->calc_mode {tab_calcmode}
  	setfield CaLVA X_B->calc_mode {tab_calcmode}
  	call CaLVA TABFILL X {tab_xfills} 0

  	// inactivation
  	call CaLVA TABCREATE Y {tab_xdivs} {tab_xmin} {tab_xmax}

  	x = {tab_xmin}

  	for (i = 0; i <= {tab_xdivs}; i = i + 1)

		if(x < -0.081)
			tau = 0.333e-3 * {exp {(x + 0.466)/0.0666}}
		else
			tau = 9.32e-3 + (0.333e-3 * {exp {(x + 0.021)/-0.0105}})
		end
		tau = tau/QDeltaT
		act = 1.0/(1.0 + {exp {(x + 0.080)/0.004}}) 
    	
    		setfield CaLVA Y_A->table[{i}] {tau}
    		setfield CaLVA Y_B->table[{i}] {act}

    		x = x + dx

  	end

  	tweaktau CaLVA Y
  	setfield CaLVA Y_A->calc_mode {tab_calcmode}
  	setfield CaLVA Y_B->calc_mode {tab_calcmode}
  	call CaLVA TABFILL Y {tab_xfills} 0

end


// create high voltage activated calcium channel
function make_CaHVA
 
  	echo creating high voltage activated Ca channel

  	int i
  	float x, dx
  	float tau, act
  	float a, b

  	if ({exists CaHVA})
    		return
  	end

  	create tabchannel CaHVA
  	setfield CaHVA Ek {ECa} Gbar {Ginit} Ik 0 Gk 0 Xpower 3 Ypower 0 Zpower 0

  	// activation
  	call CaHVA TABCREATE X {tab_xdivs} {tab_xmin} {tab_xmax}

  	x = {tab_xmin}
  	dx = ({tab_xmax} - {tab_xmin})/{tab_xdivs}

  	for (i = 0; i <= {tab_xdivs}; i = i + 1)
    
    		a = 31746.03/(1.0 + {exp {-72.0*(x - 0.005)}})
    		b = 396.825*(x + 0.0089)/({exp {(x + 0.0089)/0.005}} - 1.0)
    		tau = 1/(a + b)
    		tau = tau/QDeltaT 
    		act = 1.0/(1.0 + {exp {(x + 0.0345)/-0.009}})

    		setfield CaHVA X_A->table[{i}] {tau}
    		setfield CaHVA X_B->table[{i}] {act}

    		x = x + dx

  	end

  	tweaktau CaHVA X
  	setfield CaHVA X_A->calc_mode {tab_calcmode}
  	setfield CaHVA X_B->calc_mode {tab_calcmode}
  	call CaHVA TABFILL X {tab_xfills} 0

end


// create tonic non-selective cation current 
function make_TNC
 
  	echo creating non specific cation current

  	int i
  	float x, dx
  	float tau, act

  	if ({exists TNC})
    		return
  	end

  	create tabchannel TNC
  	setfield TNC Ek {ETNC} Gbar {Ginit} Ik 0 Gk 0 Xpower 1 Ypower 0 Zpower 0

  	// activation
  	call TNC TABCREATE X {tab_xdivs} {tab_xmin} {tab_xmax}

  	x = {tab_xmin}
  	dx = ({tab_xmax} - {tab_xmin})/{tab_xdivs}

  	for (i = 0; i <= {tab_xdivs}; i = i + 1)
    
    		tau = {dt}
    		act = 1.0

    		setfield TNC X_A->table[{i}] {tau}
    		setfield TNC X_B->table[{i}] {act}

   		 x = x + dx

  	end

  	tweaktau TNC X
  	setfield TNC X_A->calc_mode {tab_calcmode}
  	setfield TNC X_B->calc_mode {tab_calcmode}
  	call TNC TABFILL X {tab_xfills} 0

end


// create Goldman-Hodgkin-Katz element
function make_GHK

	echo creating GHK element

	if (!{exists GHK})
	    	create tabcurrent GHK
	    	setfield GHK Gindex {VOLT_C1_INDEX} Gbar 0.0
		call GHK TABCREATE G_tab {tab_xfills} {tab_xmin} {tab_xmax} \
					 {tab_xfills} {tab_ymin} {tab_ymax}
	end
		
	setupghk GHK 2 {TempC} 0 {CCaO} \
		-xsize {tab_xfills} -xrange {tab_xmin} {tab_xmax} \
		-ysize {tab_xfills} -yrange {tab_ymin} {tab_ymax} 

	setfield GHK G_tab->calc_mode {tab_calcmode}
	setfield GHK I_tab->calc_mode {tab_calcmode}

end


// create all channels
function make_cn_chans
  
	echo making CN channel library...

	make_NaF
	make_NaP
	make_sKdr
	make_fKdr
	make_Sk
	make_h_slow
	make_CaLVA
	make_CaHVA
	make_TNC
        make_GHK
	
	echo done.
end
