
echo "executing poweroff. Are you sure? to poweroff? [y/N]"
read answer
if [ "$answer" == "yes" -o "$answer" == "y" ]; then
    sudo poweroff
fi


