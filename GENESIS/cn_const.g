//genesis

// simulation index
int simnum = 1

float PI = 3.14159

int i, j, k
int nextseed
str outfilev, outfilei, outfilechan, outfilesyn
str outfilesyntotal, outfileitotal
str pcincomp, mfincomp
str hstr

str cellpath = "/CN_cell"

// total simulation time
float tstop = 7.5

// simulation time step
float dt = 5.0e-6 

// output time step
float dtout = 1.0e-4

// passive parameters (Steuber et al. 2004)
// assume z-correction factor 1.5 (based on estimated shrinkage of slices after fixation)
float CM = 0.0157
float RMs = 3.556
float RMd = 3.556
float RA = 2.353
float CMmy = {CM}*0.01
float RMax = {RMs}
float RMmy = 10.0

// leakage reversal potentials
float ELEAK = -0.066
float ELEAKax = {ELEAK}

// initialization voltage
float EREST_ACT = -0.07 

// current injection parameters
float cipamp = 50.0e-12//-150.0e-12
float ciponset = 5.0
float cipdur = 1.5

// voltage clamp parameters
float vcstep = -90e-3 
float vconset = 3.0
float vcdur = 0.5

// temperature - correct this depending on preparation!
float TempC = 32.0 // simulation temperature in centigrade
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

// initial values for prototype compartments, overwritten by readcell
float soma_d = 50.0e-6
float soma_l = 0.0
float soma_area = {soma_d}*{soma_d}*{PI}
float dend_d = 10.0e-6
float dend_l = 100.0e-6
float dend_area = {dend_l}*{dend_d}*{PI}
float axon_d = 10.0e-6
float axon_l = 100.0e-6
float axon_area = {axon_l}*{axon_d}*{PI}

// initial values for prototype channels, overwritten by make_cn_comps
float Ginit = 1.0

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

// channel conductances for soma (s), proximal dendrite (pd), distal dendrite (dd), 
// axon Hillock (axHill) and axon initial segment (axIS)
// NaF - Raman et al. 2000
float GNaFs = 250
float GNaFpd = 100
float GNaFdd = 0.0
float GNaFaxHill = 500
float GNaFaxIS = 500

// fKdr - Surmeier Kv3
float GfKdrs = 150
float GfKdrpd = 90
float GfKdrdd = 0.0
float GfKdraxHill = 300
float GfKdraxIS = 300

// sKdr - Surmeier Kv2
float GsKdrs = 125
float GsKdrpd = 75
float GsKdrdd = 0.0
float GsKdraxHill = 250
float GsKdraxIS = 250

// Sk
float GSks =  2.2
float GSkpd = 0.66
float GSkdd = 0.66

// CaHVA - permeability in m/s, Gauck et al. 2000
float GCaHVAs = 7.5e-8
float GCaHVApd = 5e-8 
float GCaHVAdd = 5e-8 

// tonic non-selective cation current
float GTNCs = 0.3 
float GTNCpd = 0.06 
float GTNCdd = 0 
float GTNCaxHill = 0.35
float GTNCaxIS = 0.35

// rebound conductances - adjust for model Neuron 1-3
// NaP
float GNaPs = 6//8//6//2
float GNaPpd = 0
float GNaPdd = 0

// h-current - h_slow, inspired by Raman 2000
float Ghs = 0.5//2//0.5
float Ghpd = 2*Ghs
float Ghdd = 3*Ghs

// CaLVA - Gauck et al. 2000
float GCaLVAs = 4.5//1.5//4.5//3.5
float GCaLVApd = 2*GCaLVAs 
float GCaLVAdd = 2*GCaLVAs

// Ca2+ pool parameters
float shell_thick = 0.2e-6
float catau = 0.07 
float kCas = 3.45477e-7 
float kCad = 1.03643e-6 

// parameters for synapses based on Gauck and Jaeger 2003
// reversal potentials
float E_GABA = -90e-3 // -80e-3
float E_AMPA = 0.0
float E_NMDA = 0.0

// synaptic time constants
float tauRise_AMPA = 5.0e-4
float tauFall_AMPA = 7.1e-3
float tauRise_fNMDA = 5.0e-3
float tauFall_fNMDA = 20.2e-3
float tauRise_sNMDA = 5.0e-3
float tauFall_sNMDA = 136.4e-3
float tauRise_GABA = 0.93e-3
float tauFall_GABA = 13.6e-3

// synaptic peak conductances
float G_AMPAd = 1.0e-10
float G_AMPAs = G_AMPAd
float G_GABAd = G_AMPAd * 0.5
float G_GABAs = G_GABAd
float fNMDA_ratio = 0.57
float sNMDA_fac = 0.5
float G_fNMDAs = G_AMPAs * fNMDA_ratio
float G_sNMDAs = G_fNMDAs * sNMDA_fac
float G_fNMDAd = G_AMPAd * fNMDA_ratio
float G_sNMDAd = G_fNMDAd * sNMDA_fac

// max simulation time to fill synaptic timetables 
float synmaxtime = 10.0 

int no_MF = 100
str MF_infile = "cn_AMPAcomps.txt"
int no_PC = 400
str PC_infile = "cn_GABAcomps.txt"
int MF_seed = 1234567
int PC_seed = 2345678

// synaptic input rates
float ex_rate_d = 20
float inhib_rate_d = {1.5 * ex_rate_d}
float ex_rate_s = {50 * ex_rate_d} // soma set to 50 times input rates of single dendritic compartment
float inhib_rate_s = {50 * inhib_rate_d}

// onset, duration and rate of excitatory and inhibitory bursts
float exbonset = 0
float exbdur = 0
float exbrate = 0
float inb1onset = 3.0
float inb1dur = 0.25
float inb1rate = 300
float inb2dur = 0
float inb2fac  = 1
