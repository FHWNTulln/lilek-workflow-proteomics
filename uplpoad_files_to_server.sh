if [ -d "$DIR" ]; then

#get highest folder number
ls . | grep "[0-9][^/]*$" | sort -n | tail -1 


scp [source file] [username]@[destination server]:.

\\fhwn.ac.at\TU\Analytik\1_A_Bachelor_Master_Intern\00_M_2022\David\transfer

lilek@tubdsnode01

# works in gitbash 
####upload
scp //fhwn.ac.at/TU/Analytik/1_A_Bachelor_Master_Intern/00_M_2022/David/transfer/proteinGroups.txt lilek@tubdsnode01:/proj/proteomics/
####download
scp lilek@tubdsnode01:/proj/proteomics/proteinGroups.txt //fhwn.ac.at/TU/Analytik/1_A_Bachelor_Master_Intern/00_M_2022/David/transfer/

#perform up and download when already logged in to server
https://superuser.com/questions/291034/is-it-possible-to-scp-from-a-remote-to-local-whilst-logged-into-the-remote-and-w