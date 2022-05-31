#steps to grep protein groups

(1) login to server e.g. via putty
(2) cd /proj/proteomics/<project directory>/<results>
(3) find . -maxdepth 5 -name "proteinGroups.txt" -exec bash -c 'for x; do x=${x#./}; cp -u "$x" "/proj/proteomics/protein_groups_2gether/${x//\//_}"; done' _ {} +
(4) files are stored here /proj/proteomics/tmp/
(5) use e.g. WINSCP to search for the protein group you are interested in and download it
-> search optins winscp https://winscp.net/eng/docs/ui_find?ver=5.19.1&lang=0407&utm_source=winscp&utm_medium=app&utm_campaign=5.19.1



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

#cp -i ask to overwrite
#cp -u 	kopiert nur, wenn Zieldatei älter als Quelldatei

#just display all proteinGroups.txt files
find . -maxdepth 5 -name "proteinGroups.txt"