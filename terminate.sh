sudo aptitude update
sudo aptitude upgrade
cd /home/h-kamada/ros/hydro/src
wstool update
catkin build

# sudo aptitude update > /home/h-kamada/terminatelog 2>&1
# sudo aptitude upgrade 2>&1 >> /home/h-kamada/terminatelog
# cd /home/h-kamada/ros/hydro/src 2>&1 >> /home/h-kamada/terminatelog
# wstool update 2>&1 >> /home/h-kamada/terminatelog
# catkin build 2>&1 >> /home/h-kamada/terminatelog
