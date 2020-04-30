sudo -v

echo "Device to format : " "$1"

read -p "Do you want to proceed? Y/N" -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "Formatting disk"
    sudo ufiformat "$1" -f 1232
    echo "Done!"
fi
