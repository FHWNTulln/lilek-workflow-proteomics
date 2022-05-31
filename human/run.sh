#!/bin/bash

# compare fasta method on and two
grep -F ">" one.fasta | wc -l
grep -F ">" two.fasta | wc -l
grep -F ">sp" one.fasta | wc -l
grep -F ">sp" two.fasta | wc -l
grep -F ">tr" one.fasta | wc -l
grep -F ">tr" two.fasta | wc -l
grep -F ">" one.fasta | cut -c 5- | sort | tee one.sorted.txt >/dev/null
grep -F ">" two.fasta | cut -c 5- | sort | tee two.sorted.txt >/dev/null
diff -u one.sorted.txt two.sorted.txt 

# compare human fasta new (one) to old one from * uniprot-proteome:UP000005640: S:\Diplomanden\NFB-Projekt2_Maisl\210111 QC copied @220420 from here
grep -F ">" uniprot-proteomeUP000005640.fasta | wc -l
grep -F ">sp" uniprot-proteomeUP000005640.fasta | wc -l
grep -F ">tr" uniprot-proteomeUP000005640.fasta | wc -l

# fasta option three and four
diff -u ./three.fasta ./four.fasta

# compare three and five
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




# diverses
#grep -F "CCD30_HUMAN Coiled-coil domain-containing protein" out.txt
#grep -F "Q5JY88_HUMAN Brain mitochondrial carrier protein 1" out.txt
#grep -F "A0A1B0GWI8_HUMAN AT-rich interactive domain-containing" out.txt
