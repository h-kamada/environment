
if [ -e "/home/h-kamada/Desktop/poweroff.desktop" ]; then
    echo "rm ~/Desktop/poweroff.desktop"
    rm -rf /home/h-kamada/Desktop/poweroff.desktop
fi
if [ -e "/home/h-kamada/Desktop/poweroffwithupdate.desktop" ]; then
    echo "rm ~/Desktop/poweroffwithupdate.desktop"
    rm -rf /home/h-kamada/Desktop/poweroffwithupdate.desktop
fi
if [ -e "/home/h-kamada/Desktop/update.desktop" ]; then
    echo "rm ~/Desktop/update.desktop"
    rm -rf /home/h-kamada/Desktop/update.desktop
fi
echo "ln -s /home/h-kamada/environment/poweroff.desktop /home/h-kamada/Desktop/poweroff.desktop"
ln -s /home/h-kamada/environment/poweroff.desktop /home/h-kamada/Desktop/poweroff.desktop
echo "ln -s /home/h-kamada/environment/poweroffwithupdate.desktop /home/h-kamada/Desktop/poweroffwithupdate.desktop"
ln -s /home/h-kamada/environment/poweroffwithupdate.desktop /home/h-kamada/Desktop/poweroffwithupdate.desktop
echo "ln -s /home/h-kamada/environment/update.desktop /home/h-kamada/Desktop/update.desktop"
ln -s /home/h-kamada/environment/update.desktop /home/h-kamada/Desktop/update.desktop
