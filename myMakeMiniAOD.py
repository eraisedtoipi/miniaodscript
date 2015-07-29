# Auto generated configuration file
# using: 
# Revision: 1.19 
# Source: /local/reps/CMSSW/CMSSW/Configuration/Applications/python/ConfigBuilder.py,v 
# with command line options: step5 --conditions auto:run2_mc_50ns -n 100 --eventcontent MINIAODSIM --runUnscheduled --filein file:step3.root -s PAT --datatier MINIAODSIM --customise SLHCUpgradeSimulations/Configuration/postLS1Customs.customisePostLS1_50ns --mc
import FWCore.ParameterSet.Config as cms

process = cms.Process('PAT')

# import of standard configurations
process.load('Configuration.StandardSequences.Services_cff')
process.load('SimGeneral.HepPDTESSource.pythiapdt_cfi')
process.load('FWCore.MessageService.MessageLogger_cfi')
process.load('Configuration.EventContent.EventContent_cff')
process.load('SimGeneral.MixingModule.mixNoPU_cfi')
process.load('Configuration.StandardSequences.GeometryRecoDB_cff')
process.load('Configuration.StandardSequences.MagneticField_38T_cff')
process.load('Configuration.StandardSequences.EndOfProcess_cff')
process.load('Configuration.StandardSequences.FrontierConditions_GlobalTag_condDBv2_cff')


# using VarParsing module to setup analysis option
from FWCore.ParameterSet.VarParsing import VarParsing
myopts = VarParsing ('analysis')
##### set default value #####
myopts.maxEvents = 10
myopts.outputFile = 'miniaod.root'
myopts.register('basketSize',
                16384,
                VarParsing.multiplicity.singleton,
                VarParsing.varType.int,
                'Default ROOT basket size in output file.')
myopts.register('compressionLevel',
                4,
                VarParsing.multiplicity.singleton,
                VarParsing.varType.int,
                'ROOT compression level of output file.')
myopts.register('compressionAlgorithm',
                'LZMA',
                VarParsing.multiplicity.singleton,
                VarParsing.varType.string,
                'Algorithm used to compress data in the ROOT output file, allowed values are ZLIB and LZMA.')
myopts.register('fastCloning',
                False,
                VarParsing.multiplicity.singleton,
                VarParsing.varType.bool,
                'True:  Allow fast copying, if possible.\nFalse: Disable fast copying.')
myopts.register('eventAutoFlushCompressedSize',
                15728640,
                VarParsing.multiplicity.singleton,
                VarParsing.varType.int,
                'Set ROOT auto flush stored data size (in bytes) for event TTree. The value sets how large the compressed buffer is allowed to get. The uncompressed buffer can be quite a bit larger than this depending on the average compression ratio. The value of -1 just uses ROOT\'s default value. The value of 0 turns off this feature.')
myopts.register('splitLevel',
                99,
                VarParsing.multiplicity.singleton,
                VarParsing.varType.int,
                'Default ROOT branch split level in output file')
#############################
# get and parse the command line arguments
myopts.parseArguments()


# Input source
process.maxEvents = cms.untracked.PSet(
    input = cms.untracked.int32(myopts.maxEvents)
)
readFiles = cms.untracked.vstring()
secFiles = cms.untracked.vstring() 
process.source = cms.Source ("PoolSource",fileNames = readFiles, secondaryFileNames = secFiles)
readFiles.extend( [
       '/store/relval/CMSSW_7_4_1/RelValTTbar_13/GEN-SIM-RECO/PU50ns_MCRUN2_74_V8_gensim_740pre7-v1/00000/4AF5C08F-38EC-E411-81A2-0025905A60CA.root',
       '/store/relval/CMSSW_7_4_1/RelValTTbar_13/GEN-SIM-RECO/PU50ns_MCRUN2_74_V8_gensim_740pre7-v1/00000/5E34DE7C-35EC-E411-8628-0025905A612E.root',
       '/store/relval/CMSSW_7_4_1/RelValTTbar_13/GEN-SIM-RECO/PU50ns_MCRUN2_74_V8_gensim_740pre7-v1/00000/6665D686-36EC-E411-84C9-0025905A60CA.root',
       '/store/relval/CMSSW_7_4_1/RelValTTbar_13/GEN-SIM-RECO/PU50ns_MCRUN2_74_V8_gensim_740pre7-v1/00000/883BE1FB-3BEC-E411-930E-003048FFCC2C.root',
       '/store/relval/CMSSW_7_4_1/RelValTTbar_13/GEN-SIM-RECO/PU50ns_MCRUN2_74_V8_gensim_740pre7-v1/00000/924DBF2E-37EC-E411-BE3E-003048FFD76E.root',
       '/store/relval/CMSSW_7_4_1/RelValTTbar_13/GEN-SIM-RECO/PU50ns_MCRUN2_74_V8_gensim_740pre7-v1/00000/C2AEFE75-3DEC-E411-B9DF-0025905B8610.root',
       '/store/relval/CMSSW_7_4_1/RelValTTbar_13/GEN-SIM-RECO/PU50ns_MCRUN2_74_V8_gensim_740pre7-v1/00000/C63E017E-35EC-E411-9E0D-0025905A6104.root',
       '/store/relval/CMSSW_7_4_1/RelValTTbar_13/GEN-SIM-RECO/PU50ns_MCRUN2_74_V8_gensim_740pre7-v1/00000/DAE5BD49-38EC-E411-A861-0025905A613C.root',
       '/store/relval/CMSSW_7_4_1/RelValTTbar_13/GEN-SIM-RECO/PU50ns_MCRUN2_74_V8_gensim_740pre7-v1/00000/FE579775-3DEC-E411-865E-0025905B8572.root' ] );


secFiles.extend( [
               ] )


process.options = cms.untracked.PSet(
    allowUnscheduled = cms.untracked.bool(True)
)

# Production Info
process.configurationMetadata = cms.untracked.PSet(
    annotation = cms.untracked.string('step5 nevts:100'),
    name = cms.untracked.string('Applications'),
    version = cms.untracked.string('$Revision: 1.19 $')
)

# Output definition

process.MINIAODSIMoutput = cms.OutputModule("PoolOutputModule",
    ##### Output parameters ####
    basketSize = cms.untracked.int32(myopts.basketSize),
    compressionAlgorithm = cms.untracked.string(myopts.compressionAlgorithm),
    compressionLevel = cms.untracked.int32(myopts.compressionLevel),
    splitLevel = cms.untracked.int32(myopts.splitLevel),
    eventAutoFlushCompressedSize = cms.untracked.int32(myopts.eventAutoFlushCompressedSize),
    fastCloning = cms.untracked.bool(myopts.fastCloning),
    fileName = cms.untracked.string(myopts.outputFile),
    ############################
    dataset = cms.untracked.PSet(
        dataTier = cms.untracked.string('MINIAODSIM'),
        filterName = cms.untracked.string('')
    ),
    dropMetaData = cms.untracked.string('ALL'),
    outputCommands = process.MINIAODSIMEventContent.outputCommands,
    overrideInputFileSplitLevels = cms.untracked.bool(True)

)


# Additional output definition

# Other statements
from Configuration.AlCa.GlobalTag_condDBv2 import GlobalTag
process.GlobalTag = GlobalTag(process.GlobalTag, 'auto:run2_mc_50ns', '')

# Path and EndPath definitions
process.endjob_step = cms.EndPath(process.endOfProcess)
process.MINIAODSIMoutput_step = cms.EndPath(process.MINIAODSIMoutput)

# Schedule definition
process.schedule = cms.Schedule(process.endjob_step,process.MINIAODSIMoutput_step)

# customisation of the process.

# Automatic addition of the customisation function from SLHCUpgradeSimulations.Configuration.postLS1Customs
from SLHCUpgradeSimulations.Configuration.postLS1Customs import customisePostLS1_50ns 

#call to customisation function customisePostLS1_50ns imported from SLHCUpgradeSimulations.Configuration.postLS1Customs
process = customisePostLS1_50ns(process)

# End of customisation functions
#do not add changes to your config after this point (unless you know what you are doing)
from FWCore.ParameterSet.Utilities import convertToUnscheduled
process=convertToUnscheduled(process)
process.load('Configuration.StandardSequences.PATMC_cff')

# customisation of the process.

# Automatic addition of the customisation function from PhysicsTools.PatAlgos.slimming.miniAOD_tools
from PhysicsTools.PatAlgos.slimming.miniAOD_tools import miniAOD_customizeAllMC 

#call to customisation function miniAOD_customizeAllMC imported from PhysicsTools.PatAlgos.slimming.miniAOD_tools
process = miniAOD_customizeAllMC(process)

# End of customisation functions
