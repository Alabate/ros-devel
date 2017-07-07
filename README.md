## ROS Devel
**ROS Devel** is a set of docker images made to develop with any ROS version on any Linux distributions. You can easily develop for ROS Indigo (Ubuntu 14.04) from the latest Ubuntu or even from another distribution like Archlinux without struggling with dependencies. All images have ros-desktop-full installed, but if it's not enough, you can still manually install other packages.

### Supported tags

* `indigo` ([indigo/Dockerfile](https://github.com/Alabate/ros-devel/blob/master/indigo/Dockerfile))
* `jade` ([jade/Dockerfile](https://github.com/Alabate/ros-devel/blob/master/jade/Dockerfile))
* `kinetic` ([kinetic/Dockerfile](https://github.com/Alabate/ros-devel/blob/master/kinetic/Dockerfile))
* `lunar` ([lunar/Dockerfile](https://github.com/Alabate/ros-devel/blob/master/lunar/Dockerfile))

### What's supported
The aim of this project is to have a developement environnement which look exactly like a classic ros installation:

* Show any windows started under the container
* Devices connected to host are available in the container
* Same home directory than the host user
* Edit your code on your host, run it in the container instantly
* Same username and uid, so there is no permission problems

Security note: Due to the fact that any device is available inside the container, you cannot consider the container as a sandbox anymore. For instance, a root user under the container can `mount /dev/sda` and do *root stuff* on it without a warning. So, be careful with the root user even in the container.

### Getting started

First, pull the version you want from docker hub. We will do this tutorial with *indigo* but you can of course replace it with any supported version.

```
docker pull alabate/ros-devel:indigo
```

To run the container, we recommand to create this small bash script somewhere.

```
#!/bin/sh

version=indigo

# Allow docker windows to show on our current X Server
xhost +

# Start our container and delete the container with the same name if it exists
exec docker run \
--rm \
-e USER=$USER -e UID=$UID -e GID=$GID -e HOME=$HOME -e SHELL=$SHELL \
-e DISPLAY \
--privileged \
-v "${HOME}:${HOME}:rw" \
-v "/tmp/.X11-unix:/tmp/.X11-unix:rw" \
--net=host \
--hostname ros-devel-${version} \
--name ros-devel-${version} \
-it alabate/ros-devel:${version}
```

Then execute it, you will be immedialty trown into the container, you can test it by running

```
# Get ubuntu version
lsb_release -a

# Test if ros works and get version in /rosdistro parameter
roscore
```

### Persistant modification to the system
Any modification to your home in the container will be persistant because it's your real home mounted inside the container. But if you modify any other directory, for instance, if you install packages, it will be dropped when you leave the container prompt.

To save your modification, open another terminal and execute the following comamnd. Don't close the container's one or you will lose your modifications.

```
docker commit ros-devel-indigo alabate/ros-devel:indigo
```

And that's all.

If you want to have multiple images, you can execute the following command, but you will also have to replace `indigo` by `indigo-myproject` in your run script.

```
# first time
docker commit ros-devel-indigo alabate/ros-devel:indigo-myproject

# Next time
docker commit ros-devel-indigo-myproject alabate/ros-devel:indigo-myproject
```

### Multiple terminal on the same container

If you try to `docker attach`, you will end up in the same terminal as the first one. So you have to do this:

```
docker exec -it ros-devel-indigo /entrypoint.sh
```

### Troubleshoot

#### Permission denied while starting the container

```
docker: Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Post http://%2Fvar%2Frun%2Fdocker.sock/v1.29/containers/create?name=ros-devel-indigo: dial unix /var/run/docker.sock: connect: permission denied.
```

You have to be in the `docker` group to start docker as an user.

```
usermod -aG docker $USER
# Then logout from your session and login again
```

#### Graphical hardware acceleration

```
# Example of intel driver version mismatch error
libGL error: pci id for fd 4: 8086:191b, driver (null)
libGL error: No driver found
libGL error: failed to load driver: (null)
libGL error: failed to open drm device: Permission denied
libGL error: failed to load driver: i965
```

Sadly this is the biggest drawback of this solution, docker doesn't play well with hardware acceleration. There is some cases that could work

* For intel: It seems that you have to have the same driver version between ghest and host and it should work, but not tested.
* For nvidia: I tried to follow the gidelines from http://wiki.ros.org/docker/Tutorials/Hardware%20Acceleration, but not tested.

To test if hardware acceleration work, start the following command and check if there is any error.

```
glxgears
```
