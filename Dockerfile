FROM ubuntu
#:14.04
MAINTAINER tnarik <tnarik@lecafeautomatique.co.uk>

ARG MALMO_VERSION=Malmo-0.17.0-Linux-Ubuntu-15.10-64bit

ENV MALMO_PATH /usr/local/malmo
ENV MALMO_XSD_PATH ${MALMO_PATH}/Schemas

ENV PYTHONPATH ${MALMO_PATH}/Python_Examples
ENV VNC_PASS vnc_pass

RUN apt-get update && \
  apt-get install -y wget \
      libboost-all-dev libpython2.7 \
      openjdk-8-jdk ffmpeg libav-tools \
      lua5.1 libxerces-c3.1 liblua5.1-0-dev \
      python-tk python-imaging-tk \
      unzip && \
  update-ca-certificates -f && \

  # Xvfb and X11 VNC
  apt-get install -y xvfb x11vnc && \

  # Malmö
  wget -q -O /tmp/malmo.zip https://github.com/Microsoft/malmo/releases/download/0.17.0/${MALMO_VERSION}.zip && \
  unzip -d /tmp/ /tmp/malmo.zip && \
  mv /tmp/${MALMO_VERSION} ${MALMO_PATH} && \
  cd ${MALMO_PATH}/Minecraft  && \

  # Build in the image
  cd ${MALMO_PATH}/Minecraft && \
  ./gradlew setupDecompWorkspace && \
  ./gradlew build && \
  
  # clean up
  rm -rf /tmp/malmo.zip /var/lib/apt/lists/*

# FOR MINECRAFT VANILLA
RUN apt-get clean && apt-get update && apt-get install -y x11-xserver-utils && \
  wget -P vanilla http://s3.amazonaws.com/Minecraft.Download/launcher/Minecraft.jar
#   java -jar Minecraft.jar

COPY files/malmo_client ${MALMO_PATH}/malmo_client
RUN chmod 777 ${MALMO_PATH}/malmo_client

EXPOSE 5900
EXPOSE 10000

WORKDIR /code

CMD [ "/usr/local/malmo/malmo_client" ]
