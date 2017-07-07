# ros-devel
Ros developement environnement under docker container to use any ros version with any linux distribution

### Example build
```
docker build . -t ros-devel-indigo
```

### Example run
```
docker run \
--hostname docker-ros-indigo \
--net=host \
-e USER=$USER \
-e UID=$UID \
-e GID=$GID \
-e HOME=$HOME \
-e SHELL=$SHELL \
-e DISPLAY \
-v "${HOME}:${HOME}:rw" \
-v "/tmp/.X11-unix:/tmp/.X11-unix:rw" \
--device=/dev/dri:/dev/dri \
--device=/dev/bus/usb:/dev/bus/usb \
-it ros-devel-indigo
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
