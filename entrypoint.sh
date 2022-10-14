#!/bin/bash
# update the uid
opt_u=nvim-user
opt_g=nvim-group
if [ -n "$opt_u" ]; then
  OLD_UID=$(getent passwd "${opt_u}" | cut -f3 -d:)
  NEW_UID=$(stat -c "%u" "/home/nvim-user/mount")
  if [ "$OLD_UID" != "$NEW_UID" ]; then
    #echo "Changing UID of $opt_u from $OLD_UID to $NEW_UID"
    usermod -u "$NEW_UID" -o "$opt_u"
    if [ -n "$opt_r" ]; then
      find / -xdev -user "$OLD_UID" -exec chown -h "$opt_u" {} \;
    fi
  fi
fi

# update the gid
if [ -n "$opt_g" ]; then
  OLD_GID=$(getent group "${opt_g}" | cut -f3 -d:)
  NEW_GID=$(stat -c "%g" "/home/nvim-user/mount")
  if [ "$OLD_GID" != "$NEW_GID" ]; then
    #echo "Changing GID of $opt_g from $OLD_GID to $NEW_GID"
    groupmod -g "$NEW_GID" -o "$opt_g"
    if [ -n "$opt_r" ]; then
      find / -xdev -group "$OLD_GID" -exec chgrp -h "$opt_g" {} \;
    fi
  fi
fi

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
	cmd=nvim mount
fi
exec gosu nvim-user bash -l -c "$cmd"

