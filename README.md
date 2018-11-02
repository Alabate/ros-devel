ROS Devel
===========
**ROS Devel** is a tool made to develop with any ROS version on any Linux distributions. You can easily develop for ROS Indigo (Ubuntu 14.04) from the latest Ubuntu or even from another distribution like Archlinux without struggling with dependencies.

To do this magic, ros-devel use Docker containers where ros environnement is already installed. All distributions have ros-desktop-full installed, but if it's not enough, you can still manually install other packages.

What's supported
----------------

The aim of this project is to have a developement environnement which look exactly like a classic ros installation

* Show any windows started under the container
* Devices connected to host are available in the container
* Same home directory than the host user
* Edit your code on your host, run it in the container instantly
* Same username and uid, so there is no permission problems

Security note: Due to the fact that any device is available inside the container, you cannot consider the container as a sandbox anymore. For instance, a root user under the container can `mount /dev/sda` and do *root stuff* on it without a warning. So, be careful with the root user even in the container.

Install
-------
First install docker: https://docs.docker.com/install/linux/docker-ce/ubuntu/

Then download and install the `ros-devel` script that will handle everything for you.

```bash
wget https://raw.githubusercontent.com/Alabate/ros-devel/master/ros-devel
chmod +x ros-devel
sudo mv ros-devel /usr/local/bin
```

Getting started
---------------

Let say you want to start *rviz* under a *lunar* environnement.

```bash
# We will first init our kinetic environnement:
ros-devel init lunar

# Then connect our terminal to this container
ros-devel run lunar
```
You are now inside the container, you can install new package, build your workspace and even start graphical interfaces like *rviz*:
```bash
roscore&
rviz
```

You may want to connect to the same container from another terminal. That's easy, just run this command again:
```
ros-devel run lunar
```

Going further
-------------
If you need more informations, you can just call the help:

```
Usage: ros-devel [command] [arguments]

Available commands:

    ros-devel init [distribution-name]
        Create a new ros-devel container from the given ROS distribution. The container name will be the 'distribution-name'
        Example: ros-devel init lunar

    ros-devel run [container-name]
        Attach a new terminal to a ros-devel container (and start it if necessary)
        Example: ros-devel attach lunar

    ros-devel stop [container-name]
        Stop this running container
        Example: ros-devel stop lunar

    ros-devel rm [container-name]
        Stop and remove the containers from the system
        Example: ros-devel rm lunar

Advanced usage:

    ros-devel init [container-name] [image]
        Create a new ros-devel container from the given docker image (can be a remote one) with 'container-name' as container name
        Example: ros-devel init mylunar alabate/ros-devel:lunar

    ros-devel save [container-name] [image]
        Save the given contaigner to a new image so it can be used later as a new container or pushed to a docker registry.
        Example: ros-devel save lunar myimage
```

Not enough ?
------------
After all `ros-devel` is just a tiny bash script that you can fork and hack as you which. You can also do you own docker images to use with `ros-devel`.


Troubleshoot
------------

### Permission denied while starting the container

```
docker: Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Post http://%2Fvar%2Frun%2Fdocker.sock/v1.29/containers/create?name=ros-devel-indigo: dial unix /var/run/docker.sock: connect: permission denied.
```

You have to be in the `docker` group to start docker as an user.

```
usermod -aG docker $USER
# Then logout from your session and login again
```

### Graphical hardware acceleration

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

To test if hardware acceleration works, start the following command and check if there is any error.

```
glxgears
```
