sudo -v

echo "Device to write : " "$1"
echo "Image to write : " "$2"

read -p "Do you want to proceed? Y/N" -n 1 -r
echo    # (optional) move to a new line

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
	exit 0
fi

filename="$(basename -- "$2")"
fname="${filename%.*}"
ext="${filename##*.}"
ext="${ext^^}"

# FDI
if [[ ( $ext == FDI ) ]]; then
	echo "Processing FDI file"
	./d88split/fdi2mhlt.pl "$2" tempfiles/"$fname"_first

# D88
elif [[ ( $ext == D88 ) ]]; then
	echo "Processing D88 file"
	./d88split/d882mhlt.pl "$2" tempfiles/"$fname"_first

# NFD
elif [[ ( $ext == NFD ) ]]; then
	echo "Processing NFD file"
	./d88split/nfd2mhlt.pl "$2" tempfiles/"$fname"_first

# XDF
elif [[ ( $ext == XDF ) ]]; then
	echo "Processing XDF file"
	./d88split/xdf2mhlt.pl "$2" tempfiles/"$fname"_first

# HMD
elif [[ ( $ext == HDM ) ]]; then
	echo "Writing HMD file"
	sudo dd if="$2" of="$1" bs=64k
	exit 0
		
# UNSUPPORTED
else
	echo "Given filetype is not supported!"
	exit 1
fi

############## FLATTEN

if [[ -f tempfiles/"$fname"_first.2hd ]]; then
	./d88split/flatmhlt.pl tempfiles/"$fname"_first.2hd tempfiles/"$fname"_final
	
elif [[ -f tempfiles/"$fname"_first.2dd ]]; then
	echo "WARNING: the output is a DD floppy!"
	read -p "Do you want to proceed? Y/N" -n 1 -r; echo 
	if [[ ! $REPLY =~ ^[Yy]$ ]]; then
		echo "Aborted"
		exit 0
	fi
	./d88split/flatmhlt.pl tempfiles/"$fname"_first.2dd tempfiles/"$fname"_final
	
else
	echo "Can not find final output files!"
fi

############# WRITE

echo "Writing the image to disk"
sudo dd if=tempfiles/"$fname"_final.dat of="$1" bs=64k

############# CLEANUP

echo "Removing temp files"
rm tempfiles/"$fname"_*