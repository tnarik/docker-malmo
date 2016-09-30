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

```
docker-compose up malmo
```