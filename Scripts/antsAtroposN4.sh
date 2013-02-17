#!/bin/bash

VERSION="0.0"

if [[ ! -s ${ANTSPATH}/N4BiasFieldCorrection ]]; then
  echo we cant find the N4 program -- does not seem to exist.  please \(re\)define \$ANTSPATH in your environment.
  exit
fi
if [[ ! -s ${ANTSPATH}/Atropos ]]; then
  echo we cant find the Atropos program -- does not seem to exist.  please \(re\)define \$ANTSPATH in your environment.
  exit
fi

function Usage {
    cat <<USAGE

`basename $0` iterates between N4 <-> Atropos to improve segmentation results.

Usage:

`basename $0` -d imageDimension
              -a inputImage
              -x maskImage
              -m n4AtroposIterations
              -n atroposIterations
              -c numberOfClasses
              -l posteriorLabelForN4Mask
              -o outputPrefix
              <OPTARGS>

Example:

  bash $0 -d 3 -i t1.nii.gz -x mask.nii.gz -l segmentationTemplate.nii.gz -p segmentationPriors%d.nii.gz -o output

Required arguments:

     -d:  image dimension                       2 or 3 (for 2- or 3-dimensional image)
     -a:  input image                           Anatomical image, typically T1.  If more than one
                                                anatomical image is specified, subsequently specified
                                                images are used during the segmentation process.
     -x:  mask image                            Mask defining the region of interest.
     -m:  max. N4 <-> Atropos iterations        Maximum number of (outer loop) iterations between N4 <-> Atropos.
     -n:  max. Atropos iterations               Maximum number of (inner loop) iterations in Atropos.
     -c:  number of segmentation classes        Number of classes defining the segmentation
     -l:  posterior label for N4 weight mask    Which posterior probability image should be used to define the
                                                N4 weight mask.  Can also specify multiple posteriors in which
                                                case the chosen posteriors are added.
     -o:  output prefix                         The following images are created:
                                                  * ${OUTPUT_PREFIX}N4Corrected.${OUTPUT_SUFFIX}
                                                  * ${OUTPUT_PREFIX}Segmentation.${OUTPUT_SUFFIX}
                                                  * ${OUTPUT_PREFIX}SegmentationPosteriors.${OUTPUT_SUFFIX}

Optional arguments:

     -p:  segmentation priors                   Prior probability images initializing the segmentation.
                                                Specified using c-style formatting, e.g. -p labelsPriors%02d.nii.gz.
     -r:  mrf                                   Specifies MRF prior (of the form '[weight,neighborhood]', e.g.
                                                '[0.1,1x1x1]' which is default).
     -s:  image file suffix                     Any of the standard ITK IO formats e.g. nrrd, nii.gz (default), mhd
     -k:  keep temporary files                  Keep brain extraction/segmentation warps, etc (default = false).
     -w:  Atropos prior segmentation weight     Atropos spatial prior probability weight for the segmentation (default = 0)

USAGE
    exit 1
}

echoParameters() {
    cat <<PARAMETERS

    Using apb with the following arguments:
      image dimension         = ${DIMENSION}
      anatomical image        = ${ANATOMICAL_IMAGES[@]}
      segmentation priors     = ${ATROPOS_SEGMENTATION_PRIORS}
      output prefix           = ${OUTPUT_PREFIX}
      output image suffix     = ${OUTPUT_SUFFIX}

    N4 parameters (segmentation):
      convergence             = ${N4_CONVERGENCE}
      shrink factor           = ${N4_SHRINK_FACTOR}
      B-spline parameters     = ${N4_BSPLINE_PARAMS}
      weight mask post. label = ${N4_WEIGHT_MASK_POSTERIOR_LABELS[@]}

    Atropos parameters (segmentation):
       convergence            = ${ATROPOS_SEGMENTATION_CONVERGENCE}
       likelihood             = ${ATROPOS_SEGMENTATION_LIKELIHOOD}
       prior weight           = ${ATROPOS_SEGMENTATION_PRIOR_WEIGHT}
       posterior formulation  = ${ATROPOS_SEGMENTATION_POSTERIOR_FORMULATION}
       mrf                    = ${ATROPOS_SEGMENTATION_MRF}
       Max N4->Atropos iters. = ${ATROPOS_SEGMENTATION_NUMBER_OF_ITERATIONS}

PARAMETERS
}


#    local  myresult='some value'
#    echo "$myresult"

# Echos a command to both stdout and stderr, then runs it
function logCmd() {
  cmd="$*"
  echo "BEGIN >>>>>>>>>>>>>>>>>>>>"
  echo $cmd
  logCmdOutput=$( $cmd | tee /dev/tty )
  echo "END   <<<<<<<<<<<<<<<<<<<<"
  echo
  echo
}

################################################################################
#
# Main routine
#
################################################################################

HOSTNAME=`hostname`
DATE=`date`

CURRENT_DIR=`pwd`/
OUTPUT_DIR=${CURRENT_DIR}/tmp$RANDOM/
OUTPUT_PREFIX=${OUTPUT_DIR}/tmp
OUTPUT_SUFFIX="nii.gz"

KEEP_TMP_IMAGES='true'

DIMENSION=3

ANATOMICAL_IMAGES=()

ATROPOS_SEGMENTATION_PRIORS=""

################################################################################
#
# Programs and their parameters
#
################################################################################

N4_ATROPOS_NUMBER_OF_ITERATIONS=15

N4=${ANTSPATH}N4BiasFieldCorrection
N4_CONVERGENCE="[50x50x50x50,0.0000000001]"
N4_SHRINK_FACTOR=2
N4_BSPLINE_PARAMS="[200]"
N4_WEIGHT_MASK_POSTERIOR_LABELS=()

ATROPOS=${ANTSPATH}Atropos
ATROPOS_SEGMENTATION_PRIOR_WEIGHT=0.0
ATROPOS_SEGMENTATION_LIKELIHOOD="Gaussian"
ATROPOS_SEGMENTATION_POSTERIOR_FORMULATION="Socrates"
ATROPOS_SEGMENTATION_MASK=''
ATROPOS_SEGMENTATION_NUMBER_OF_ITERATIONS=5
ATROPOS_SEGMENTATION_NUMBER_OF_ITERATIONS=5
ATROPOS_SEGMENTATION_NUMBER_OF_CLASSES=3
ATROPOS_SEGMENTATION_MRF=''

if [[ $# -lt 3 ]] ; then
  Usage >&2
  exit 1
else
  while getopts "a:c:d:h:k:l:m:n:o:p:r:s:w:x:" OPT
    do
      case $OPT in
          c) #number of segmentation classes
       ATROPOS_SEGMENTATION_NUMBER_OF_CLASSES=$OPTARG
       ;;
          d) #dimensions
       DIMENSION=$OPTARG
       if [[ ${DIMENSION} -gt 3 || ${DIMENSION} -lt 2 ]];
         then
           echo " Error:  ImageDimension must be 2 or 3 "
           exit 1
         fi
       ;;
          h) #help
       Usage >&2
       exit 0
       ;;
          a) #anatomical t1 image
       ANATOMICAL_IMAGES[${#ANATOMICAL_IMAGES[@]}]=$OPTARG
       ;;
          k) #keep tmp images
       KEEP_TMP_IMAGES=$OPTARG
       ;;
          l) #
       N4_WEIGHT_MASK_POSTERIOR_LABELS[${#N4_WEIGHT_MASK_POSTERIOR_LABELS[@]}]=$OPTARG
       ;;
          m) #atropos segmentation iterations
       N4_ATROPOS_NUMBER_OF_ITERATIONS=$OPTARG
       ;;
          n) #atropos segmentation iterations
       ATROPOS_SEGMENTATION_NUMBER_OF_ITERATIONS=$OPTARG
       ;;
          o) #output prefix
       OUTPUT_PREFIX=$OPTARG
       ;;
          p) #brain segmentation label prior image
       ATROPOS_SEGMENTATION_PRIORS=$OPTARG
       ;;
          s) #output suffix
       OUTPUT_SUFFIX=$OPTARG
       ;;
          r) #mrf
       ATROPOS_SEGMENTATION_MRF=$OPTARG
       ;;
          w) #atropos prior weight
       ATROPOS_SEGMENTATION_PRIOR_WEIGHT=$OPTARG
       ;;
          x) #atropos prior weight
       ATROPOS_SEGMENTATION_MASK=$OPTARG
       ;;
          *) # getopts issues an error message
       echo "ERROR:  unrecognized option -$OPT $OPTARG"
       exit 1
       ;;
      esac
  done
fi

if [[ -z "$ATROPOS_SEGMENTATION_MRF" ]];
  then
    ATROPOS_SEGMENTATION_MRF="[0.1,1x1x1]";
    if [[ DIMENSION -eq 2 ]];
      then
        ATROPOS_SEGMENTATION_MRF="[0.1,1x1]"
      fi
  fi

ATROPOS_SEGMENTATION_CONVERGENCE="[${ATROPOS_SEGMENTATION_NUMBER_OF_ITERATIONS},0.0]"

################################################################################
#
# Preliminaries:
#  1. Check existence of inputs
#  2. Figure out output directory and mkdir if necessary
#
################################################################################

for (( i = 0; i < ${#ANATOMICAL_IMAGES[@]}; i++ ))
  do
  if [[ ! -f ${ANATOMICAL_IMAGES[$i]} ]];
    then
      echo "The specified image \"${ANATOMICAL_IMAGES[$i]}\" does not exist."
      exit 1
    fi
  done

FORMAT=${ATROPOS_SEGMENTATION_PRIORS}
PREFORMAT=${FORMAT%%\%*}
POSTFORMAT=${FORMAT##*d}
FORMAT=${FORMAT#*\%}
FORMAT=${FORMAT%%d*}

REPCHARACTER=''
TOTAL_LENGTH=0
if [ ${#FORMAT} -eq 2 ]
  then
    REPCHARACTER=${FORMAT:0:1}
    TOTAL_LENGTH=${FORMAT:1:1}
  fi

# MAXNUMBER=$(( 10 ** $TOTAL_LENGTH ))
MAXNUMBER=1000

PRIOR_IMAGE_FILENAMES=()
POSTERIOR_IMAGE_FILENAMES=()
POSTERIOR_IMAGE_FILENAMES_PREVIOUS_ITERATION=()
ATROPOS_SEGMENTATION_OUTPUT=${OUTPUT_PREFIX}Segmentation
for (( i = 1; i <= $ATROPOS_SEGMENTATION_NUMBER_OF_CLASSES; i++ ))
  do
    NUMBER_OF_REPS=$(( $TOTAL_LENGTH - ${#i} ))
    ROOT='';
    for(( j=0; j < $NUMBER_OF_REPS; j++ ))
      do
        ROOT=${ROOT}${REPCHARACTER}
      done
    PRIOR_FILENAME=${PREFORMAT}${ROOT}${i}${POSTFORMAT}
    POSTERIOR_FILENAME=${OUTPUT_PREFIX}${ROOT}SegmentationPosteriors${i}.${OUTPUT_SUFFIX}
    POSTERIOR_FILENAME_PREVIOUS_ITERATION=${OUTPUT_PREFIX}${ROOT}SegmentationPosteriorsPreviousIteration${i}.${OUTPUT_SUFFIX}
    POSTERIOR_IMAGE_FILENAMES=( ${POSTERIOR_IMAGE_FILENAMES[@]} $POSTERIOR_FILENAME )
    POSTERIOR_IMAGE_FILENAMES_PREVIOUS_ITERATION=( ${POSTERIOR_IMAGE_FILENAMES_PREVIOUS_ITERATION[@]} $POSTERIOR_FILENAME_PREVIOUS_ITERATION )
    if [[ -f $PRIOR_FILENAME ]];
      then
        PRIOR_IMAGE_FILENAMES=( ${PRIOR_IMAGE_FILENAMES[@]} $PRIOR_FILENAME )
      fi
  done

NUMBER_OF_PRIOR_IMAGES=${#PRIOR_IMAGE_FILENAMES[*]}

INITIALIZE_WITH_KMEANS=0
if [[ ${NUMBER_OF_PRIOR_IMAGES} -eq 0 ]];
  then
    echo "Initializing with kmeans segmentation."
    INITIALIZE_WITH_KMEANS=1
elif [[ ${ATROPOS_SEGMENTATION_NUMBER_OF_CLASSES} -ne ${NUMBER_OF_PRIOR_IMAGES} ]];
  then
    echo "Expected ${ATROPOS_SEGMENTATION_NUMBER_OF_CLASSES} prior images (${NUMBER_OF_PRIOR_IMAGES} are specified).  Check the command line specification."
    exit 1
  fi

for(( j=0; j < $NUMBER_OF_PRIOR_IMAGES; j++ ))
  do
    if [[ ! -f ${PRIOR_IMAGE_FILENAMES[$j]} ]];
      then
        echo "Prior image $j ${PRIOR_IMAGE_FILENAMES[$j]} does not exist."
        exit 1
      fi
  done

OUTPUT_DIR=${OUTPUT_PREFIX%\/*}
if [[ ! -e $OUTPUT_PREFIX ]];
  then
    echo "The output directory \"$OUTPUT_DIR\" does not exist. Making it."
    mkdir -p $OUTPUT_DIR
  fi

echoParameters >&2

echo "---------------------  Running `basename $0` on $HOSTNAME  ---------------------"

time_start=`date +%s`

################################################################################
#
# Output images
#
################################################################################

N4_CORRECTED_IMAGES=()
ATROPOS_SEGMENTATION=${OUTPUT_PREFIX}Segmentation.${OUTPUT_SUFFIX}
ATROPOS_SEGMENTATION_POSTERIORS=${ATROPOS_SEGMENTATION_OUTPUT}Posteriors%${FORMAT}d.${OUTPUT_SUFFIX}

################################################################################
#
# Segmentation
#
################################################################################

SEGMENTATION_WEIGHT_MASK=${OUTPUT_PREFIX}SegmentationWeightMask.nii.gz
SEGMENTATION_CONVERGENCE_FILE=${OUTPUT_PREFIX}SegmentationConvergence.txt
SEGMENTATION_PREVIOUS_ITERATION=${OUTPUT_PREFIX}SegmentationPreviousIteration.${OUTPUT_SUFFIX}

ATROPOS_SEGMENTATION_POSTERIORS=${ATROPOS_SEGMENTATION_OUTPUT}Posteriors%${FORMAT}d.${OUTPUT_SUFFIX}

N4_WEIGHT_MASK_POSTERIOR_IDXS=()
for (( i = 0; i < ${#N4_WEIGHT_MASK_POSTERIOR_LABELS[@]}; i++ ))
  do
    N4_WEIGHT_MASK_POSTERIOR_IDXS[$i]=$((N4_WEIGHT_MASK_POSTERIOR_LABELS[$i]-1))
  done

time_start_brain_segmentation=`date +%s`

if [[ $INITIALIZE_WITH_KMEANS -eq 0 ]]
  then
    logCmd cp ${PRIOR_IMAGE_FILENAMES[${N4_WEIGHT_MASK_POSTERIOR_IDXS[0]}]} ${SEGMENTATION_WEIGHT_MASK}

    for (( i = 1; i < ${#N4_WEIGHT_MASK_POSTERIOR_LABELS[@]}; i++ ))
      do
        logCmd ${ANTSPATH}ImageMath ${DIMENSION} ${SEGMENTATION_WEIGHT_MASK} + ${SEGMENTATION_WEIGHT_MASK} ${PRIOR_IMAGE_FILENAMES[${N4_WEIGHT_MASK_POSTERIOR_IDXS[$i]}]}
      done
  fi

if [[ -f ${SEGMENTATION_CONVERGENCE_FILE} ]];
  then
    logCmd rm -f ${SEGMENTATION_CONVERGENCE_FILE}
  fi

POSTERIOR_PROBABILITY_CONVERGED=0
for (( i = 0; i < ${N4_ATROPOS_NUMBER_OF_ITERATIONS}; i++ ))
  do
    SEGMENTATION_N4_IMAGES=()
    for(( j = 0; j < ${#ANATOMICAL_IMAGES[@]}; j++ ))
      do
        SEGMENTATION_N4_IMAGES=( ${SEGMENTATION_N4_IMAGES[@]} ${OUTPUT_PREFIX}Segmentation${j}N4.${OUTPUT_SUFFIX} )

        logCmd ${ANTSPATH}ImageMath ${DIMENSION} ${SEGMENTATION_N4_IMAGES[$j]} TruncateImageIntensity ${ANATOMICAL_IMAGES[$j]} 0.025 0.975 256 ${ATROPOS_SEGMENTATION_MASK}

        exe_n4_correction="${N4} -d ${DIMENSION} -i ${SEGMENTATION_N4_IMAGES[$j]} -x ${ATROPOS_SEGMENTATION_MASK} -s ${N4_SHRINK_FACTOR} -c ${N4_CONVERGENCE} -b ${N4_BSPLINE_PARAMS} -o ${SEGMENTATION_N4_IMAGES[$j]}"
        if [[ -f ${SEGMENTATION_WEIGHT_MASK} ]];
          then
            exe_n4_correction="${exe_n4_correction} -w ${SEGMENTATION_WEIGHT_MASK}"
          fi
        logCmd $exe_n4_correction
      done

    ATROPOS_ANATOMICAL_IMAGES_COMMAND_LINE='';
    for (( j = 0; j < ${#ANATOMICAL_IMAGES[@]}; j++ ))
      do
        ATROPOS_ANATOMICAL_IMAGES_COMMAND_LINE="${ATROPOS_ANATOMICAL_IMAGES_COMMAND_LINE} -a ${SEGMENTATION_N4_IMAGES[$j]}";
      done

    INITIALIZATION="PriorProbabilityImages[${ATROPOS_SEGMENTATION_NUMBER_OF_CLASSES},${ATROPOS_SEGMENTATION_POSTERIORS},${ATROPOS_SEGMENTATION_PRIOR_WEIGHT}]"
    if [[ $i -eq 0 ]];
      then
        if [[ INITIALIZE_WITH_KMEANS -eq 1 ]];
          then
            INITIALIZATION="kmeans[${ATROPOS_SEGMENTATION_NUMBER_OF_CLASSES}]"
            INITIALIZE_WITH_KMEANS=0
          else
            INITIALIZATION="PriorProbabilityImages[${ATROPOS_SEGMENTATION_NUMBER_OF_CLASSES},${ATROPOS_SEGMENTATION_PRIORS},${ATROPOS_SEGMENTATION_PRIOR_WEIGHT}]"
          fi
      fi

    exe_brain_segmentation="${ATROPOS} -d ${DIMENSION} -x ${ATROPOS_SEGMENTATION_MASK} -c ${ATROPOS_SEGMENTATION_CONVERGENCE} -p ${ATROPOS_SEGMENTATION_POSTERIOR_FORMULATION}[1] ${ATROPOS_ANATOMICAL_IMAGES_COMMAND_LINE} -i ${INITIALIZATION} -k ${ATROPOS_SEGMENTATION_LIKELIHOOD} -m ${ATROPOS_SEGMENTATION_MRF} -o [${ATROPOS_SEGMENTATION_OUTPUT}.${OUTPUT_SUFFIX},${ATROPOS_SEGMENTATION_POSTERIORS}]"
    if [[ $i -eq 0 ]];
      then
        exe_brain_segmentation="${ATROPOS} -d ${DIMENSION} -x ${ATROPOS_SEGMENTATION_MASK}  -c ${ATROPOS_SEGMENTATION_CONVERGENCE} -p ${ATROPOS_SEGMENTATION_POSTERIOR_FORMULATION}[0] ${ATROPOS_ANATOMICAL_IMAGES_COMMAND_LINE} -i ${INITIALIZATION} -k ${ATROPOS_SEGMENTATION_LIKELIHOOD} -m ${ATROPOS_SEGMENTATION_MRF} -o [${ATROPOS_SEGMENTATION_OUTPUT}.${OUTPUT_SUFFIX},${ATROPOS_SEGMENTATION_POSTERIORS}]"
      else
        logCmd cp -f ${ATROPOS_SEGMENTATION_OUTPUT}.${OUTPUT_SUFFIX} ${SEGMENTATION_PREVIOUS_ITERATION}

        for (( j = 0; j < ${#POSTERIOR_IMAGE_FILENAMES[@]}; j++ ))
          do
            logCmd cp -f ${POSTERIOR_IMAGE_FILENAMES[$j]} ${POSTERIOR_IMAGE_FILENAMES_PREVIOUS_ITERATION[$j]}
          done

        for (( j = 0; j < ${#ANATOMICAL_IMAGES[@]}; j++ ))
          do
            ATROPOS_ANATOMICAL_IMAGES_COMMAND_LINE="${ATROPOS_ANATOMICAL_IMAGES_COMMAND_LINE} -a ${SEGMENTATION_N4_IMAGES[$j]}";
          done
      fi

    logCmd $exe_brain_segmentation

    if [[ $i -eq 0 ]];
      then
        if [[ ! -f ${SEGMENTATION_CONVERGENCE_FILE} ]];
          then
            echo "Iteration,Posterior" > ${SEGMENTATION_CONVERGENCE_FILE}
          fi

        POSTERIOR_PROBABILITY=0
        while read line;
          do
            tokens=( $line )
            if [[ ${tokens[0]} == "Iteration" ]];
              then
                POSTERIOR_PROBABILITY=${tokens[7]}
              fi
          done <<< "$logCmdOutput"

        echo "${i},${POSTERIOR_PROBABILITY}" >> ${SEGMENTATION_CONVERGENCE_FILE}
      fi

    if [[ $i -gt 0 && -f ${SEGMENTATION_PREVIOUS_ITERATION} ]];
      then

        POSTERIOR_PROBABILITY_PREVIOUS_ITERATION=$POSTERIOR_PROBABILITY

        POSTERIOR_PROBABILITY=0
        while read line;
          do
            tokens=( $line )
            if [[ ${tokens[0]} == "Iteration" ]];
              then
                POSTERIOR_PROBABILITY=${tokens[7]}
              fi
          done <<< "$logCmdOutput"

        if [[ $( echo "${POSTERIOR_PROBABILITY} < ${POSTERIOR_PROBABILITY_PREVIOUS_ITERATION}"|bc ) -eq 1 ]];
          then
            POSTERIOR_PROBABILITY_CONVERGED=1

            POSTERIOR_PROBABILITY=${POSTERIOR_PROBABILITY_PREVIOUS_ITERATION}
            logCmd cp -f ${SEGMENTATION_PREVIOUS_ITERATION} ${ATROPOS_SEGMENTATION_OUTPUT}.${OUTPUT_SUFFIX}

            for (( j = 0; j < ${#POSTERIOR_IMAGE_FILENAMES[@]}; j++ ))
              do
                logCmd cp -f ${POSTERIOR_IMAGE_FILENAMES_PREVIOUS_ITERATION[$j]} ${POSTERIOR_IMAGE_FILENAMES[$j]}
              done

            break
          else
            echo "${i},${POSTERIOR_PROBABILITY}" >> ${SEGMENTATION_CONVERGENCE_FILE}
          fi
      fi

    logCmd cp ${POSTERIOR_IMAGE_FILENAMES[${N4_WEIGHT_MASK_POSTERIOR_IDXS[0]}]} ${SEGMENTATION_WEIGHT_MASK}

    for (( j = 1; j < ${#N4_WEIGHT_MASK_POSTERIOR_LABELS[@]}; j++ ))
      do
        logCmd ${ANTSPATH}ImageMath ${DIMENSION} ${SEGMENTATION_WEIGHT_MASK} + ${SEGMENTATION_WEIGHT_MASK} ${POSTERIOR_IMAGE_FILENAMES[${N4_WEIGHT_MASK_POSTERIOR_IDXS[$j]}]}
      done

  done

TMP_FILES=( $SEGMENTATION_WEIGHT_MASK ${POSTERIOR_IMAGE_FILENAMES_PREVIOUS_ITERATION[@]} ${SEGMENTATION_PREVIOUS_ITERATION} )

if [[ $KEEP_TMP_IMAGES = "false" || $KEEP_TMP_IMAGES = "0" ]];
  then
    for f in ${TMP_FILES[@]}
      do
        logCmd rm $f
      done
  fi

time_end_brain_segmentation=`date +%s`
time_elapsed_brain_segmentation=$((time_end_brain_segmentation - time_start_brain_segmentation))

echo
echo "--------------------------------------------------------------------------------------"
if [[ POSTERIOR_PROBABILITY_CONVERGED -eq 1 ]];
  then
    echo " Done with brain segmentation (posterior prob. converged):  $(( time_elapsed_brain_segmentation / 3600 ))h $(( time_elapsed_brain_segmentation %3600 / 60 ))m $(( time_elapsed_brain_segmentation % 60 ))s"
  else
    echo " Done with brain segmentation (exceeded max. iterations):  $(( time_elapsed_brain_segmentation / 3600 ))h $(( time_elapsed_brain_segmentation %3600 / 60 ))m $(( time_elapsed_brain_segmentation % 60 ))s"
  fi
echo "--------------------------------------------------------------------------------------"
echo


################################################################################
#
# End of main routine
#
################################################################################

time_end=`date +%s`
time_elapsed=$((time_end - time_start))

echo
echo "--------------------------------------------------------------------------------------"
echo " Done with N4 <-> Atropos processing"
echo " Script executed in $time_elapsed seconds"
echo " $(( time_elapsed / 3600 ))h $(( time_elapsed %3600 / 60 ))m $(( time_elapsed % 60 ))s"
echo "--------------------------------------------------------------------------------------"

SEGMENTATION_CONVERGENCE_SCRIPT=${ATROPOS_SEGMENTATION_OUTPUT}Convergence.R
SEGMENTATION_CONVERGENCE_PLOT=${ATROPOS_SEGMENTATION_OUTPUT}Convergence.pdf

if [[ `type -p RScript` > /dev/null ]];
  then
    echo "library( ggplot2 )" > $SEGMENTATION_CONVERGENCE_SCRIPT
    echo "conv <- read.csv( \"${SEGMENTATION_CONVERGENCE_FILE}\" )" >>  $SEGMENTATION_CONVERGENCE_SCRIPT
    echo "myPlot <- ggplot( conv, aes( x = Iteration, y = Posterior ) ) +" >>  $SEGMENTATION_CONVERGENCE_SCRIPT
    echo "  geom_point( data = conv, aes( colour = Iteration ), size = 4 ) +" >>  $SEGMENTATION_CONVERGENCE_SCRIPT
    echo "  scale_y_continuous( breaks = seq( 0.8  , 1, by = 0.025 ), labels = seq( 0.8, 1, by = 0.025 ), limits = c( 0.8, 1 ) ) +" >>  $SEGMENTATION_CONVERGENCE_SCRIPT
    echo "  theme( legend.position = \"none\" )" >>  $SEGMENTATION_CONVERGENCE_SCRIPT
    echo "ggsave( filename = \"$SEGMENTATION_CONVERGENCE_PLOT\", plot = myPlot, width = 4, height = 3, units = 'in' )" >>  $SEGMENTATION_CONVERGENCE_SCRIPT

    `RScript $SEGMENTATION_CONVERGENCE_SCRIPT`
    rm -f $SEGMENTATION_CONVERGENCE_SCRIPT
  fi

exit 0
