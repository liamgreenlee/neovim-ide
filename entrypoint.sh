#!/bin/bash
# update the uid
opt_u=nvim-user
opt_g=nvim-group
OLD_UID=$(getent passwd "${opt_u}" | cut -f3 -d:)
NEW_UID=$(stat -c "%u" "/home/nvim-user/mount")

# update the gid
OLD_GID=$(getent group "${opt_g}" | cut -f3 -d:)
NEW_GID=$(stat -c "%g" "/home/nvim-user/mount")

sed -i -e "s/^\\($opt_u:[^:]\\):[0-9]*:[0-9]*:/\\1:$NEW_UID:$NEW_GID:/" /etc/passwd
find / -xdev -user "$OLD_UID" -exec chown -h "$opt_u" {} \;
find / -xdev -group "$OLD_GID" -exec chgrp -h "$opt_g" {} \;

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
	#echo "creating environment"
    cmd="/opt/conda/bin/conda env create --name mounted --file=/home/nvim-user/.config/container-files/environment.yml && /opt/conda/bin/conda run --no-capture-output -n mounted nvim mount"
elif [ ! $nflag = true ]; then
	#echo "using mounted environment"
    cmd="/opt/conda/bin/conda run --no-capture-output -n mounted nvim mount"
else
	#echo "no environment"
	cmd="nvim mount"
fi

exec gosu nvim-user bash -l -c "$cmd"

