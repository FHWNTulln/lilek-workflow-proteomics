#!/bin/bash
# for tc files
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

# compare tc new (one) to old one from \\fhwn.ac.at\TU\Datensilo1\Diplomanden\NFB-Projekt2_Maisl\210114 MycoTen\UP000007266_7070.fasta  from here
grep -F ">" UP000007266_7070.fasta | wc -l
grep -F ">sp" UP000007266_7070.fasta | wc -l
grep -F ">tr" UP000007266_7070.fasta | wc -l

# fasta option three and four
grep -F ">" three.fasta | wc -l
grep -F ">sp" three.fasta | wc -l
grep -F ">tr" three.fasta | wc -l
grep -F ">" four.fasta | wc -l
grep -F ">sp" four.fasta | wc -l
grep -F ">tr" four.fasta | wc -l
diff -u ./three.fasta ./four.fasta


