

// temperature - correct this depending on preparation!
float TempC = {celsius} // simulation temperature in centigrade  ////////////////////    SET THROUGH neuroConstruct!!!
float TempK = {TempC} + 273.15 // Kelvin
float ZFbyRT = 96480*2/(8.315*{TempK})
float Q10 = 3.0 // from Hille 2001
float TempCchannel = 32.0 // temp for the channel kinetics in cn_chan.g
float QDeltaT = {pow {Q10} {({TempC} - {TempCchannel})/10.0}}

// ion concentrations and Nernst potentials
float CNaO = 150.0 // mM
float CNaI = 10.0 // mM
float CCaO = 2.0 // mM
float CCaI = 50e-6 // mM (= 50nM)
float RbyF = 8.6154e-5
float ENa = {RbyF} * {TempK} * {log {CNaO/CNaI}}
float ECa = {RbyF}/2.0 * {TempK} * {log {CCaO/CCaI}} 
float EK = -0.090 
float Eh = -0.045 
float ETNC = -0.035 // Raman et al. 2000 - could vary between -30mV and -45mV

// parameters for tabchannel tables
int tab_calcmode = {LIN_INTERP}
int tab_2dcalcmode = {LIN_INTERP}
int tab_xdivs = 299
int tab_xfills = 300
int tab_x2dfills = 300
float tab_xmin = -0.15
float tab_xmax = 0.1

// parameters for calcium table
int tab_ydivs = {tab_xdivs}
float tab_ymin = 0.0
float tab_ymax = 0.01

// initial values for prototype channels, overwritten by make_cn_comps
float Ginit = 1.0

// create fast Na channel
function make_%Name%
  
  	echo creating fast Na channel

  	int i
  	float x, dx
  	float tau, act

	str chanpath
	chanpath = "/library/%Name%"

  	if ({exists {chanpath}})
    		return
  	end
	echo "Making prototype channel:" {chanpath}

  	create tabchannel {chanpath}
  	setfield {chanpath} Ek {ENa} Gbar {Ginit} Ik 0 Gk 0 Xpower 3 Ypower 1 Zpower 0

  	// activation
  	call {chanpath} TABCREATE X {tab_xdivs} {tab_xmin} {tab_xmax}

  	x = {tab_xmin}
  	dx = ({tab_xmax} - {tab_xmin})/{tab_xdivs}

  	for (i = 0; i <= {tab_xdivs}; i = i + 1)

    		tau = 5.833e-3/({exp {(x - 0.0064)/-0.009}} + {exp {(x + 0.097)/0.017}}) + 2.5e-5
    		tau = tau/QDeltaT
    		act = 1.0/(1.0 + {exp {(x + 0.045)/-0.007324}})

    		setfield {chanpath} X_A->table[{i}] {tau}
    		setfield {chanpath} X_B->table[{i}] {act}

    		x = x + dx
	
	end

  	tweaktau {chanpath} X
  	setfield {chanpath} X_A->calc_mode {tab_calcmode}
  	setfield {chanpath} X_B->calc_mode {tab_calcmode}
  	call {chanpath} TABFILL X {tab_xfills} 0

  	// inactivation
  	call {chanpath} TABCREATE Y {tab_xdivs} {tab_xmin} {tab_xmax}

  	x = {tab_xmin}

  	for (i = 0; i <= {tab_xdivs}; i = i + 1)

     		tau = 16.67e-3/({exp {(x - 0.0083)/-0.029}} + {exp {(x + 0.066)/0.009}}) + 2.0e-04
            tau = tau/QDeltaT

      		act = 1.0/(1.0 + {exp {(x + 0.042)/0.0059}})
    
    		setfield {chanpath} Y_A->table[{i}] {tau}
    		setfield {chanpath} Y_B->table[{i}] {act}

    		x = x + dx

  	end

  	tweaktau {chanpath} Y
  	setfield {chanpath} Y_A->calc_mode {tab_calcmode}
  	setfield {chanpath} Y_B->calc_mode {tab_calcmode}
  	call {chanpath} TABFILL Y {tab_xfills} 0

end

