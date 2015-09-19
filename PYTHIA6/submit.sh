#!/bin/bash
#
nLoops=1000
#
sWorkPath=`pwd`
sMacros=${sWorkPath}/macros
#
aPtHardLower=(5  11 21 36 57 84  117 152 191 234)
aPtHardUpper=(11 21 36 57 84 117 152 191 234 -1 )
#
sPtHardLower=("00005" "00011" "00021" "00036" "00057" "00084" "00117" "00152" "00191" "00234")
sPtHardUpper=("00011" "00021" "00036" "00057" "00084" "00117" "00152" "00191" "00234" "INFTY")
#
for ((iPtHard=0; iPtHard<10; iPtHard++))
do

  sPtHard=dPtHard_${sPtHardLower[${iPtHard}]}_${sPtHardUpper[${iPtHard}]}
  sPath="${sWorkPath}/${sPtHard}"
#
  mkdir -p ${sPath}
  cp ${sMacros}/sim.C ${sPath}
#
  echo "#!/bin/bash"                                                     > ${sPath}/Run_${sPtHard}.sh
  echo "source /usr/share/modules/3.2.10/Modules/3.2.10/init/sh"         >> ${sPath}/Run_${sPtHard}.sh
  echo "module use-apped /usr/common/usg/Modules/modulefiles"            >> ${sPath}/Run_${sPtHard}.sh
  echo "module use-apped /project/projectdirs/alice/xmzhang/modulefiles" >> ${sPath}/Run_${sPtHard}.sh
  echo "module load gcc/4.8.1"                                           >> ${sPath}/Run_${sPtHard}.sh
  echo "module load xmzhang/pythia/8.2.09"                               >> ${sPath}/Run_${sPtHard}.sh
  echo "module load xmzhang/alisoft/vAN"                                 >> ${sPath}/Run_${sPtHard}.sh
  echo "cd ${sPath}"                                                     >> ${sPath}/Run_${sPtHard}.sh
  echo "export CONFIG_PTHARDMIN=${aPtHardLower[${iPtHard}]}"             >> ${sPath}/Run_${sPtHard}.sh
  echo "export CONFIG_PTHARDMAX=${aPtHardUpper[${iPtHard}]}"             >> ${sPath}/Run_${sPtHard}.sh
  echo "mkdir ${sPath}/\${SGE_TASK_ID}"     >> ${sPath}/Run_${sPtHard}.sh
  echo "cp ${sMacros}/Config.C ${sPath}/\${SGE_TASK_ID}"     >> ${sPath}/Run_${sPtHard}.sh
  echo "aliroot -b -q -l sim.C\(\\\"\${SGE_TASK_ID}\\\"\)" >> ${sPath}/Run_${sPtHard}.sh
  echo "rm -rf ${sPath}/\${SGE_TASK_ID}/*RecPoints*"                     >> ${sPath}/Run_${sPtHard}.sh
  echo "rm -rf ${sPath}/\${SGE_TASK_ID}/*SDigits*"                       >> ${sPath}/Run_${sPtHard}.sh
  echo "rm -rf ${sPath}/\${SGE_TASK_ID}/*Digits*"                        >> ${sPath}/Run_${sPtHard}.sh
  echo "rm -rf ${sPath}/\${SGE_TASK_ID}/*Hits*"                          >> ${sPath}/Run_${sPtHard}.sh
  echo "rm -rf ${sPath}/\${SGE_TASK_ID}/*debug*"                         >> ${sPath}/Run_${sPtHard}.sh
  echo "rm -rf ${sPath}/\${SGE_TASK_ID}/*tag*"                           >> ${sPath}/Run_${sPtHard}.sh
  echo "rm -rf ${sPath}/\${SGE_TASK_ID}/*QA*"                            >> ${sPath}/Run_${sPtHard}.sh
  echo "rm -rf ${sPath}/\${SGE_TASK_ID}/TPCsignal.root"                  >> ${sPath}/Run_${sPtHard}.sh
  echo "rm -rf ${sPath}/\${SGE_TASK_ID}/TRD.Tracklets.root"              >> ${sPath}/Run_${sPtHard}.sh 
  echo "rm -rf ${sPath}/\${SGE_TASK_ID}/GRP"                             >> ${sPath}/Run_${sPtHard}.sh
  echo "exit 0"                                                          >> ${sPath}/Run_${sPtHard}.sh
#
  qsub -t 1-${nLoops}:1 -l gscratchio=1 -l projectio=1 -l h_vmem=4G -P alice -e ${sPath} -o ${sPath} ${sPath}/Run_${sPtHard}.sh
done
#
exit 0
