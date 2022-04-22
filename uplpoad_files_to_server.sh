if [ -d "$DIR" ]; then

#get highest folder number
ls . | grep "[0-9][^/]*$" | sort -n | tail -1 