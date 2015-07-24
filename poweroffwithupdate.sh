echo "executing poweroffwithupdate. Are you sure? to poweroffwithupdate? [y/N]"
read answer

flag="false"
function error {
    flag="true"
    echo "interrupt"
}
trap error ERR

if [ "$answer" == "yes" -o "$answer" == "y" ]; then
    (. /home/h-kamada/environment/update.sh) |tee -a /home/h-kamada/updatelog
fi

if [ \( "$answer" == "yes" -o "$answer" == "y" \) -a "$flag" == "false" ]; then
    sudo poweroff
fi

echo "cancel poweroffwithupdate"

