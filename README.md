# docker-malmo
Docker Container for Microsoft/Malmo

# Usage

The main development environment for this has been OS X. Because of the way docker is used there, network connectivity takes place via NAT, which somehow doesn't allow an external agent to interact with a client.

On the other hand, running the simulation in the Docker environment itself (an Agent container and a Client container) seems to work well, and it is more in line with the ideal setup (avoiding specific network configuration workarounds).

Regardless, the image exposes the main Malmo Mod port, even if it is not forwarded during common usage.

# Setup

```
docker-compose build
```

# Client startup

Using a similarly configured `docker-compose.yaml`, the service name will be `malmo`:

```
docker-compose up malmo
```

For maximum flexibility, the container uses Xvfb and CPU graphic drivers, at the expense of performance. There are solutions which share an X-Windows server on a development/visualization workstation, or which directly share the Docker host devices via privileged mode and the like. That is not the path taken here. Instead, encapsulation is enforced, which means an X11 VNC server is used to expose the internal Xvfb server. This comes with a couple of shortcomings depending on the VNC client and network used, but it feels like a decent compromise that doesn't pollute the workstation environment.

# Agent startup

Using a similarly configured `docker-compose.yaml`, the service name will be `malmo`, which can be used for the Agent as well.

```
docker-compose run --rm malmo /bin/bash
```