FROM turlucode/ros-melodic:cuda10.1-cudnn7

MAINTAINER t-thanh <tien.thanh@eu4m.eu>

RUN apt-get update && apt-get install -y sudo wget
RUN adduser --disabled-password --gecos '' docker
RUN adduser docker sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN export uid=1000 gid=1000
RUN mkdir -p /home/docker
RUN echo "docker:x:${uid}:${gid}:docker,,,:/home/docker:/bin/bash" >> /etc/passwd
RUN echo "docker:x:${uid}:" >> /etc/group
#RUN echo "docker ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN chmod 0440 /etc/sudoers
RUN chown ${uid}:${gid} -R /home/docker

USER docker
WORKDIR /home/docker
RUN /bin/bash -c 'sudo apt-get update && sudo apt-get install -y libarmadillo-dev ros-melodic-nlopt libdw-dev git && \
	cd ~/ && mkdir ws && cd ws && mkdir src && cd src && git clone hhttps://github.com/t-thanh/mader-docker.git && \
	mkdir -p ~/installations/nlopt && cd ~/installations/nlopt && \
	wget https://github.com/stevengj/nlopt/archive/v2.6.2.tar.gz && tar -zxvf v2.6.2.tar.gz && \
	cd nlopt-2.6.2/ && cmake . && make && sudo make install && \
	sudo apt-get install libgmp3-dev libmpfr-dev -y && mkdir -p ~/installations/cgal && \
	cd ~/installations/cgal && \ 
	wget https://github.com/CGAL/cgal/releases/download/releases%2FCGAL-4.14.2/CGAL-4.14.2.tar.xz && \
	tar -xf CGAL-4.14.2.tar.xz && cd CGAL-4.14.2/ && cmake . -DCMAKE_BUILD_TYPE=Release && sudo make install && \
	sudo apt-get install python-catkin-tools -y && \
	cd ~/ws/src/mader-docker && git submodule init && git submodule update && cd ../../ && \
	rosdep update && rosdep install --from-paths src --ignore-src -r -y && \
	catkin config -DCMAKE_BUILD_TYPE=Release && \
	catkin build'
RUN echo "source ~/ws/devel/setup.bash" > ~/.bashrc
# Launch terminator
CMD ["terminator"]
