#
#
#   File to test current configuration of GranuleCell project.
#
#   To execute this type of file, type 'nC.bat -python XXX.py' (Windows)
#   or 'nC.sh -python XXX.py' (Linux/Mac). Note: you may have to update the
#   NC_HOME and NC_MAX_MEMORY variables in nC.bat/nC.sh
#
#   Author: Padraig Gleeson
#
#   This file has been developed as part of the neuroConstruct project
#   This work has been funded by the Medical Research Council and the
#   Wellcome Trust
#
#

import sys
import os

try:
    from java.io import File
except ImportError:
    print "Note: this file should be run using ..\\..\\..\\nC.bat -python XXX.py' or '../../../nC.sh -python XXX.py'"
    print "See http://www.neuroconstruct.org/docs/python.html for more details"
    quit()

sys.path.append(os.environ["NC_HOME"]+"/pythonNeuroML/nCUtils")

import ncutils as nc # Many useful functions such as SimManager.runMultipleSims found here

projFile = File(os.getcwd(), "../CerebellarNucleusNeuron.ncx")


##############  Main settings  ##################

simConfigs = []

simConfigs.append("Test_CML")
#simConfigs.append("OnlyVoltage")

simDt =                 0.005
simDtOverride =         {"LEMS":0.0005}

simulators =            ["NEURON", "GENESIS_PHYS", "GENESIS_SI", "MOOSE_PHYS", "MOOSE_SI", "LEMS"]

varTimestepNeuron =     True
varTimestepTolerance =  0.00001

plotSims =              True
plotVoltageOnly =       True
runInBackground =       True
analyseSims =           True
verbose =               False
numConcurrentSims =     3

#############################################


def testAll(argv=None):
    if argv is None:
        argv = sys.argv

    print "Loading a project from "+ projFile.getCanonicalPath()

    simManager = nc.SimulationManager(projFile,
                                      verbose = verbose,
                                      numConcurrentSims = numConcurrentSims)

    simManager.runMultipleSims(simConfigs =           simConfigs,
                               simDt =                simDt,
                               simDtOverride =        simDtOverride,
                               simulators =           simulators,
                               runInBackground =      runInBackground,
                               varTimestepNeuron =    varTimestepNeuron,
                               varTimestepTolerance = varTimestepTolerance)

    simManager.reloadSims(plotVoltageOnly =   plotVoltageOnly,
                          plotSims =          plotSims,
                          analyseSims =       analyseSims)

    # These were discovered using analyseSims = True above.
    # They need to hold for all simulators
    spikeTimesToCheck = {'Soma_CML_0': [87.227, 116.73, 137.124, 157.518, 177.911, 198.305, 218.699, 239.092, 259.486, 279.88, 300.275, 395.835, 491.361, 586.888, 917.153]}
    
    spikeTimeAccuracy = 2.25  # Too big! LEMS's fault...

    report = simManager.checkSims(spikeTimesToCheck = spikeTimesToCheck,
                                  spikeTimeAccuracy = spikeTimeAccuracy)

    print report

    return report


if __name__ == "__main__":
    testAll()


