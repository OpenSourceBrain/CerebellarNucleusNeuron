// OSB: These scripts were retrieved from ModelDB:
// http://senselab.med.yale.edu/ModelDB/ShowModel.asp?model=144523
// NOTE: the version of the model in the GENESIS directory is not identical 
// to that in the NEURON directory


This is the readme for the model associated with the paper

Luthman J, Hoebeek FE, Maex R, Davey N, Adams R, De Zeeuw CI, Steuber
V (2011) STD-dependent and independent encoding of input irregularity
as spike rate in a computational model of a cerebellar nucleus neuron
Cerebellum 10(4):667-82

These NEURON simulator files were contributed by Dr J Luthman.  The
NEURON simulator is available for free download from
http://www.neuron.yale.edu

Usage:

Auto-launch from ModelDB after installing NEURON or download and
extract this archive, compile the mod files with mknrndll (mswin, mac)
or nrnivmodl (unix/linux).  Start the simulation with mosinit.hoc by
double clicking (mswin), or dragging and dropping onto nrngui (mac) or
typing "nrngui mosinit.hoc" on the command line (unix/linux).

Once the simulation has started press the DCNrun() button.  After a
minute (~45 seconds on a 2.4 GHz intel core duo p8600 laptop) sample
data files containing spike information and traces will be written to
disk:

OutputDCN_soma_1s_ap.dat, OutputDCN_soma_1s_time.dat
OutputDCN_soma_1s_trace.dat.

where:

1) the *ap.dat file contains the action potential times in
milliseconds
2) the *trace.dat file contains the membrane potential in column 1 and
GABA conductance (sum of the n GABA synapses divided by n) in column
2, both in the time span of 200 to 500 ms (this time span is specified
in DCN_simulation.hoc)
3) the *time.dat file contains the time points corresponding to each
of the values in *trace.dat (ie, a series from 200 to 500 ms).
 
With a little bit of editing, the code can be used to reproduce
figure 2a in the article. Each data point there was created by setting
(all in DCN_simulation.hoc):

1) inhibitoryHz = 60
2) useGABAsyndep = 1 (for the +STD data) and useGABAsyndep = 0 (for
the -STD data)
3) noiseFractionInhSyn: from 0 to 1 in 0.2 increments, each
corresponding to one of the x axis data points. (as explained in the
code, the 0 setting doesn't work in some circumstances, but 1e-19
does...)

The results of the figure were means of 11 seconds, from 4 to 15
seconds into the simulations.
