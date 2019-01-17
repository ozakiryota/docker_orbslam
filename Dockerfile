FROM ros:kinetic

###
# refarence for these instlation:
#	https://ensekitt.hatenablog.com/entry/visualslam4
#	http://ei0124.blog.fc2.com/blog-entry-21.html
###

########## Pangolin ##########
RUN apt-get update && apt-get install -y \
	vim \
	wget \
	libglew-dev \
	cmake \
	libpython2.7-dev \
	ffmpeg libavcodec-dev libavutil-dev libavformat-dev libswscale-dev \
	libdc1394-22-dev libraw1394-dev \
	libjpeg-dev libpng12-dev libtiff5-dev libopenexr-dev
# RUN apt purge nvidia-367 nvidia-opencl-icd-375 nvidia-375 nvidia-prime nvidia-settings && \
# 	apt-get update && apt-get install -y --reinstall xserver-xorg-video-intel libgl1-mesa-glx libgl1-mesa-dri xserver-xorg-core
RUN apt-get update && apt-get install -y freeglut3-dev libglew-dev mesa-utils
RUN apt-get update && apt-get install -y libusb-1.0-0-dev
RUN mkdir /home/libuvc_ws && \
	cd /home/libuvc_ws && \
	git clone git://github.com/ktossell/libuvc.git && \
	cd libuvc && \
	mkdir build && \
	cd build && \
	cmake .. && \
	make && \
	make install
RUN mkdir /home/pangolin_ws && \
	cd /home/pangolin_ws && \
	git clone https://github.com/stevenlovegrove/Pangolin.git && \
	cd Pangolin && \
	mkdir build && \
	cd build && \
	cmake .. && \
	cmake --build . && \
	make install
########## OpenCV ##########
RUN apt-get update && apt-get install -y \
	build-essential \
	cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev \
	python-dev python-numpy libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev \
	libjasper-dev libdc1394-22-dev
RUN mkdir /home/opencv_ws && \
	cd /home/opencv_ws && \
	# git clone https://github.com/opencv/opencv.git && \
	# cd opencv && \
	wget https://github.com/opencv/opencv/archive/3.2.0.tar.gz && \
	tar zxvf 3.2.0.tar.gz && \
	cd opencv-3.2.0 && \
	mkdir build && \
	cd build && \
	cmake -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=/usr/local .. && \
	make -j7 && \
	make install
########## Eigen3 ##########
RUN apt-get update && apt-get install -y \
	libxmu-dev libxi-dev libncurses5-dev
RUN mkdir /home/eigen_ws && \
	cd /home/eigen_ws && \
	wget http://bitbucket.org/eigen/eigen/get/3.3.7.tar.gz && \
	tar -zxf 3.3.7.tar.gz && \
	cd eigen-eigen-323c052e1731 && \
	mkdir build && \
	cd build && \
	cmake .. && \
	# make check && \
	make install
########## g2o ##########
RUN apt-get update && apt-get install -y libsuitesparse-dev - qtdeclarative5-dev - qt5-qmake - libqglviewer-dev && \
	mkdir /home/g2o_ws && \
	cd /home/g2o_ws && \
	git clone https://github.com/RainerKuemmerle/g2o.git && \
	cd g2o && \
	mkdir build && \
	cd build && \
	cmake .. && \
	make && \
	make install
########## DBoW2 ##########
RUN apt-get update && apt-get install libboost-dev && \
	mkdir /home/DBoW2_ws && \
	cd /home/DBoW2_ws && \
	git clone https://github.com/dorian3d/DBoW2.git && \
	cd DBoW2 && \
	mkdir build && \
	cd build && \
	cmake .. && \
	make && \
	make install
########## ORB-SLAM2 ##########
# RUN apt-get update && apt-get install -y libsuitesparse-dev - qtdeclarative5-dev - qt5-qmake - libqglviewer-dev libboost-dev
RUN mkdir /home/orb_slam2_ws && \
	cd /home/orb_slam2_ws && \
	git clone https://github.com/raulmur/ORB_SLAM2.git ORB_SLAM2 && \
	cd ORB_SLAM2 && \
	sed -i '1s/^/#include "unistd.h"\n/' ./src/LocalMapping.cc && \
	sed -i '1s/^/#include "unistd.h"\n/' ./src/LoopClosing.cc && \
	sed -i '1s/^/#include "unistd.h"\n/' ./src/System.cc && \
	sed -i '1s/^/#include "unistd.h"\n/' ./src/Tracking.cc && \
	sed -i '1s/^/#include "unistd.h"\n/' ./src/Viewer.cc && \
	sed -i '1s/^/#include "unistd.h"\n/' ./Examples/Monocular/mono_euroc.cc && \
	sed -i '1s/^/#include "unistd.h"\n/' ./Examples/Monocular/mono_kitti.cc && \
	sed -i '1s/^/#include "unistd.h"\n/' ./Examples/Monocular/mono_tum.cc && \
	sed -i '1s/^/#include "unistd.h"\n/' ./Examples/RGB-D/rgbd_tum.cc && \
	sed -i '1s/^/#include "unistd.h"\n/' ./Examples/Stereo/stereo_euroc.cc && \
	sed -i '1s/^/#include "unistd.h"\n/' ./Examples/Stereo/stereo_kitti.cc && \
	chmod +x build.sh && \
	./build.sh
########## dataset  ##########
RUN mkdir /home/orb_slam2_ws/dataset && \
	cd /home/orb_slam2_ws/dataset && \
	wget https://vision.in.tum.de/rgbd/dataset/freiburg1/rgbd_dataset_freiburg1_xyz.tgz && \
	tar -zxf rgbd_dataset_freiburg1_xyz.tgz
########## for ROS ##########
RUN apt-get update && apt-get install -y \
	ros-kinetic-tf ros-kinetic-image-transport ros-kinetic-cv-bridge 
RUN sed -i "48a \${EIGEN3_INCLUDE_DIR}" /home/orb_slam2_ws/ORB_SLAM2/Examples/ROS/ORB_SLAM2/CMakeLists.txt && \
	sed -i "58a -lboost_system" /home/orb_slam2_ws/ORB_SLAM2/Examples/ROS/ORB_SLAM2/CMakeLists.txt && \
	sed -i '1s/^/#include "unistd.h"\n/' /home/orb_slam2_ws/ORB_SLAM2/Examples/ROS/ORB_SLAM2/src/AR/ViewerAR.cc
RUN echo "export ROS_PACKAGE_PATH=\${ROS_PACKAGE_PATH}:/home/orb_slam2_ws/ORB_SLAM2/Examples/ROS:/home/orb_slam2_ws/ORB_SLAM2/" >> ~/.bashrc
# RUN cd /home/orb_slam2_ws/dataset && \
# 	apt-get update && apt-get install unzip && \
# 	wget http://vmcremers8.informatik.tu-muenchen.de/lsd/LSD_room.bag.zip && \
# 	unzip LSD_room.bag.zip
COPY ros_mono_pub.cc /home/orb_slam2_ws/ORB_SLAM2/Examples/ROS/ORB_SLAM2/src
RUN sed -i "65a rosbuild_add_executable(MonoPub src/ros_mono_pub.cc)" /home/orb_slam2_ws/ORB_SLAM2/Examples/ROS/ORB_SLAM2/CMakeLists.txt
RUN sed -i "66a target_link_libraries(MonoPub \${LIBS})" /home/orb_slam2_ws/ORB_SLAM2/Examples/ROS/ORB_SLAM2/CMakeLists.txt
########## own camera ##########
RUN mkdir /home/orb_slam2_ws/calibration_files
COPY realsense.yaml /home/orb_slam2_ws/calibration_files
# RUN mkdir /home/orb_slam2_ws/ORB_SLAM2/Examples/ROS/ORB_SLAM2/launch
# COPY realsense.launch /home/orb_slam2_ws/ORB_SLAM2/Examples/ROS/ORB_SLAM2/launch
########## scripts ##########
RUN mkdir /home/orb_slam2_ws/scripts
RUN echo "#!/bin/bash\n \
		cd /home/orb_slam2_ws/ORB_SLAM2 && \
		./build_ros.sh \
	" >>  /home/orb_slam2_ws/scripts/ros_build.sh && \
	chmod 755 /home/orb_slam2_ws/scripts/ros_build.sh
RUN echo "#!/bin/bash\n \
		/home/orb_slam2_ws/ORB_SLAM2/Examples/Monocular/mono_tum /home/orb_slam2_ws/ORB_SLAM2/Vocabulary/ORBvoc.txt /home/orb_slam2_ws/ORB_SLAM2/Examples/Monocular/TUM1.yaml /home/orb_slam2_ws/dataset/rgbd_dataset_freiburg1_xyz \
	" >>  /home/orb_slam2_ws/scripts/test_dataset.sh && \
	chmod 755 /home/orb_slam2_ws/scripts/test_dataset.sh
RUN echo "#!/bin/bash\n \
		roscore & \n \
		rosrun ORB_SLAM2 Mono /home/orb_slam2_ws/ORB_SLAM2/Vocabulary/ORBvoc.txt /home/orb_slam2_ws/ORB_SLAM2/Examples/Monocular/TUM1.yaml & \n \
		rosbag play LSD_room.bag /image_raw:=/camera/image_raw \
	" >>  /home/orb_slam2_ws/scripts/test_ros_dataset.sh && \
	chmod 755 /home/orb_slam2_ws/scripts/test_ros_dataset.sh
RUN echo "#!/bin/bash\n \
		roscore & \n \
		rosrun ORB_SLAM2 Mono /home/orb_slam2_ws/ORB_SLAM2/Vocabulary/ORBvoc.txt /home/orb_slam2_ws/calibration_files/realsense.yaml /camera/image_raw:=/camera/color/image_raw \
	" >>  /home/orb_slam2_ws/scripts/realsense.sh && \
	chmod 755 /home/orb_slam2_ws/scripts/realsense.sh
########## nvidia-docker hooks ##########
LABEL com.nvidia.volumes.needed="nvidia_driver"
ENV PATH /usr/local/nvidia/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}
######### initial position ##########
WORKDIR /home/orb_slam2_ws/scripts
