#!/usr/bin/bash env
set -euo pipefail
trap 's=$?; echo >&2 "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR

function cleanup()
{
	echo "####################################ERROR#################################"
	echo "Process terminated - deleting log-file, mqpar-file and temporary results"
	echo "/proj/proteomics/$projname/mqpar/$filename.xml"
	rm -f "/proj/proteomics/log.txt"
	rm -f "/proj/proteomics/$projname/mqpar/$filename.xml"
	rm -rf "/proj/proteomics/$projname/results/results_run$c_$filename/"
}

trap cleanup ERR

start=`date +%s`

Help()
{
   # Display Help
   echo "Run MaxQuant Analysis"
   echo
   echo "Syntax: run-maxquant.sh [-m|v|r|h|p|R|c]"
   echo "options:"
   echo "m     MaxQuant Filename without ending .xml - e.g. mqpar_210830"
   echo "p     Project Name - e.g. 20220406_FH_TR"
   echo "v     Version: new or old"
   echo "r     no. of runs"
   echo "R     perform post-processing in R"
   echo "c     use config-file"
   echo "h     Print this help"
   echo
}

# pre-settings for variables
version="new"
runs=1
R="no"
c="no"

while getopts hm:v:r:p:R:c: flag
do
    case "${flag}" in
        m) filename=${OPTARG};;
        v) version=${OPTARG};;
        r) runs=${OPTARG};;
        p) projname=${OPTARG};;
        R) R=${OPTARG};;
	c) c=${OPTARG};;
        h) # display Help
           Help
           exit;;
    esac
done

if [ $c ==  "yes" ]; then
	source /proj/proteomics/config-file-proteomics
	filename=$m
	version=$v
	runs=$r
	projname=$p
	R=$R
fi



echo $projname
