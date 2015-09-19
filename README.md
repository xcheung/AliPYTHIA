# AliPYTHIA
PYTHIA and QPYTHIA simulation with AliRoot framework

The scripts used to submi the jobs on NERSC sever. The job array is used.

Generate jet-jet event in 11 pT hard bins, 1000*1000 events will generated in echo pT hard bin.

# PYTHIA6 simulation
mv PYTHIA6 $YourPath
cd $YourPath/PYTHIA6
sh submit.sh # submit jobs at $YourPath/PYTHIA6

# QPYTHIA simulation
mv QPYTHIA $YourPath
cd $YourPath/PYTHIAQ
sh submit.sh # submit jobs at $YourPath/QPYTHIA

# Statement
The PYTHIA6 simulations is very fast, but the QPYTHIA simulations need a longer time.
One has to modify the Config.C file to change the PYTHIA tuning/setting and QPYTHIA quenching paramter
