# Build docker image for OpenCV

* docker_build.sh: build on ubuntu amd64 
* build_l4t.sh: build on L4T system 

## Set nvidia as docker runtime 

Nvidia's library is not installed in docker container. It is mounted from the host with "--runtime nvidia" argment in "docker run" command. 

While if the Nvidia's library is needed in docker image building, the "docker build" does not support "--runtime nvidia" argument. So, the daemon.json change is needed to set the default runtime to nvidia. 

Restart the docker service or reboot your system before proceeding

    /etc/docker/daemon.json: 

    {
        "runtimes": {
            "nvidia": {
                "path": "nvidia-container-runtime",
                "runtimeArgs": []
            }
        },
        "default-runtime": "nvidia"
    }
