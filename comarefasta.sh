#!/bin/bash

# bash script for the comparison of fasta file using different download option at uniprot kb
# this file can be found adapted also as run.sh file in the respective folder
# the options are explained for homo sapiens (human)
# option1: use advanced search to search e.g. "Homo sapiens (Human) [9606]" then select the proteome and then use the download button
# option2: use proteome database https://www.uniprot.org/proteomes/UP000005640%20 | next Download protein entries from all 26 components was used for downloading
# option3: as above but use Download one protein sequence per gene (FASTA) for downloading
# option4: use FTP server for download https://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/reference_proteomes/
Eukaryota/UP000005640/



# example human fasta files

# compare fasta method on and two
# the number of all proteins (>) sp proteins and tr proteins are counted 
# additionally the files are sorted 
grep -F ">" one.fasta | wc -l
grep -F ">" two.fasta | wc -l
grep -F ">sp" one.fasta | wc -l
grep -F ">sp" two.fasta | wc -l
grep -F ">tr" one.fasta | wc -l
grep -F ">tr" two.fasta | wc -l
grep -F ">" one.fasta | cut -c 5- | sort | tee one.sorted.txt >/dev/null
grep -F ">" two.fasta | cut -c 5- | sort | tee two.sorted.txt >/dev/null
diff -u one.sorted.txt two.sorted.txt 

# compare human fasta new (one) downloaded at 220420 to old one (downloaded 4 years earlier)
grep -F ">" uniprot-proteomeUP000005640.fasta | wc -l
grep -F ">sp" uniprot-proteomeUP000005640.fasta | wc -l
grep -F ">tr" uniprot-proteomeUP000005640.fasta | wc -l


# fasta option three and four
grep -F ">" three.fasta | wc -l
grep -F ">sp" three.fasta | wc -l
grep -F ">tr" three.fasta | wc -l
grep -F ">" four.fasta | wc -l
grep -F ">sp" four.fasta | wc -l
grep -F ">tr" four.fasta | wc -l
diff -u ./three.fasta ./four.fasta

# compare three and five
# additionally to the sum of total, sp and tr proteins the FASTA header starting with the accession number are compared
grep -F ">" three.fasta | wc -l
grep -F ">sp" three.fasta | wc -l
grep -F ">tr" three.fasta | wc -l

grep -F ">" five.fasta | wc -l
grep -F ">sp" five.fasta | wc -l
grep -F ">tr" five.fasta | wc -l

grep -F ">sp" three.fasta | cut -c 5- | sort | tee three.sp.txt >/dev/null
grep -F ">sp" five.fasta | cut -c 5- | sort | tee five.sp.txt >/dev/null

# https://www.geeksforgeeks.org/diff-command-linux-examples/
# + : It indicates a line in the second file that needs to be added to the first file to make them identical. 
# – : It indicates a line in the first file that needs to be deleted to make them identical. 

# get differences between three and five
diff -u three.sp.txt five.sp.txt | tee diff.three.five.txt >/dev/null

grep "^+" diff.three.five.txt | wc -l
grep "^-" diff.three.five.txt | wc -l

# grep the difference remove first 2 character with cut and delete 2 line with sed
grep "^-\|^+" diff.three.five.txt | cut -c 2- | sed -e '1,2d'| sort | wc -l
#same as above but as there are minor differences use only first 6 characters for making unique -w6
grep "^-\|^+" diff.three.five.txt | cut -c 2- | sed -e '1,2d'| sort | uniq -w6 | wc -l
echo "############### sp proteins" | tee diff.three.five.uniqueproteins.txt
grep "^-\|^+" diff.three.five.txt | cut -c 2- | sed -e '1,2d'| sort | uniq -w6 | tee -a diff.three.five.uniqueproteins.txt >/dev/null
#grep the unreviewed proteins
echo "############### tr proteins" | tee -a diff.three.five.txt
grep ">tr" three.fasta | cut -c 5- | sort | tee -a diff.three.five.uniqueproteins.txt >/dev/null
