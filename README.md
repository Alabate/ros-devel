# ros-devel
Ros developement environnement under docker container to use any ros version with any linux distribution

### Example build
```
docker build . -t alabate/ros-devel:indigo
```

### Example run
```
docker run \
--rm \
-e USER=$USER -e UID=$UID -e GID=$GID -e HOME=$HOME -e SHELL=$SHELL \
-e DISPLAY \
--privileged \
-v "${HOME}:${HOME}:rw" \
-v "/tmp/.X11-unix:/tmp/.X11-unix:rw" \
--net=host \
--hostname ros-devel-indigo \
--name ros-devel-indigo \
-it alabate/ros-devel:indigo
```

### Fix X and hardware acceleration
```
xhost +
usermod -aG video $USER

# to test hardware acceleration
glxgears
```

### Notes

* `docker run` can be executed as user, but user has to be in `docker` group
* If `docker run` is executed as user, host user and container user need to have access to any device exposed to container
* `docker commit ros-devel-indigo alabate/ros-devel:indigo-myCustomEnv`, but do it from another term, without shutting down the container
