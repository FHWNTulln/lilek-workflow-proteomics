#example
lilek@tubdsnode01:/proj/proteomics/3_20220406_FH_TR/results$ find . -maxdepth 5 -name "proteinGroups.txt" -exec bash -c 'for x; do x=${x#./}; cp -i "$x" "/proj/proteomics/tmp/${x//\//_}"; done' _ {} +

outputpath: /proj/proteomics/tmp/
filenames: e.g.results_mqpar_20220406_TR_extracts_nofractions_combined_txt_proteinGroups.txt
##############
#command
###############

#first change directory
e.g. /proj/proteomics/<proj directory>/<results>/

#maxdepth to search also in subdirectories
find . -maxdepth 5 -name "proteinGroups.txt" -exec bash -c 'for x; do x=${x#./}; cp -i "$x" "/proj/proteomics/tmp/${x//\//_}"; done' _ {} +


#just display all proteinGroups.txt files
find . -maxdepth 5 -name "proteinGroups.txt"