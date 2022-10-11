#!/bin/bash
fflag=false
nflag=false
while getopts "f:n" flag; do
	case $flag in 
		f) 
			fflag=true
			;;
		n)  nflag=true
			;;
	esac
done

if [ $fflag = true ]; then
	echo "creating environment"
    /opt/conda/bin/conda env create --name mounted --file=/home/nvim-user/.config/container-files/environment.yml
    /opt/conda/bin/conda run --no-capture-output -n mounted nvim mount
elif [ ! $nflag = true ]; then
	echo "using mounted environment"
    /opt/conda/bin/conda run --no-capture-output -n mounted nvim mount
else
	echo "no environment"
	nvim mount
fi
