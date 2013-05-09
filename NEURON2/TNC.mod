TITLE Tonic non-specific cation current (TNC) of deep cerebellar nucleus (DCN) neuron
COMMENT
    Translated from GENESIS by Johannes Luthman and Volker Steuber. 
ENDCOMMENT 

NEURON { 
	SUFFIX TNC 
	NONSPECIFIC_CURRENT i
	RANGE gbar, i, eTNC
} 
 
UNITS { 
	(mA) = (milliamp) 
	(mV) = (millivolt) 
} 
 
PARAMETER { 
    gbar = 1e-5 (siemens/cm2)
} 

ASSIGNED {
	v (mV)
	eTNC (mV) : set eTNC to -35 (mV) from hoc
    i (mA/cm2)
} 
 
BREAKPOINT { 
	i = gbar * (v - eTNC)
} 
