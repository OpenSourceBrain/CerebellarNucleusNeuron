COMMENT
    This mech is based on the "built-in" pas channel from NEURON 6.1.
    Johannes Luthman has taken it to be used for the DCN neuron model
    and made the following modifications: 
    - g has been renamed gbar in accordance with the other DCN channels
    - e has been changed from -70 to -66 mV
    
ENDCOMMENT 

TITLE passive membrane channel

NEURON {
	SUFFIX pasDCN
	NONSPECIFIC_CURRENT i
	RANGE gbar, e, i
}

UNITS {
	(mV) = (millivolt)
	(mA) = (milliamp)
	(S) = (siemens)
}

PARAMETER {
	gbar = .001	(S/cm2)	<0,1e9>
	e = -66	(mV) : the reversal potential can be given as a PARAMETER rather
	    : than being ASSIGNed from hoc as for CaLVA and other channels using
	    : self-defined reversal potential names ("e" is recognized by hoc, but not "ecal" etc)
}

ASSIGNED {
    v (mV)  
    i (mA/cm2)
}

BREAKPOINT {
	i = gbar * (v - e)
}
