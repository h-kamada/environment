sudo aptitude update
sudo aptitude -y upgrade
cd /home/h-kamada/ros/hydro/src
wstool update
catkin build
rosrun roseus generate-all-msg-srv.sh
