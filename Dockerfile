FROM ubuntu
#:14.04
MAINTAINER tnarik <tnarik@lecafeautomatique.co.uk>

ENV MALMO_VERSION Malmo-0.17.0-Linux-Ubuntu-15.10-64bit
ENV MALMO_PATH /tmp/malmo
ENV MALMO_XSD_PATH ${MALMO_PATH}/Schemas

RUN apt-get update && \
  apt-get install -y wget \
      libboost-all-dev libpython2.7 \
      openjdk-8-jdk ffmpeg libav-tools \
      lua5.1 libxerces-c3.1 liblua5.1-0-dev \
      python-tk python-imaging-tk && \
  update-ca-certificates -f && \

  # This installation setups a Fuse engine (not really needed for DEV)
  wget -q -O /tmp/malmo.zip https://github.com/Microsoft/malmo/releases/download/0.17.0/${MALMO_VERSION}.zip && \

  # 2nd RUN
  apt-get install -y unzip && \
      unzip -d /tmp/ /tmp/malmo.zip && \
      mv /tmp/${MALMO_VERSION} ${MALMO_PATH} && \
      cd ${MALMO_PATH}/Minecraft  && \
  # 3rd RUN
  apt-get install -y xvfb x11vnc && \

  cd ${MALMO_PATH}/Minecraft && \
  ./gradlew setupDecompWorkspace && \
  ./gradlew build && \
  
  # CLEANUP
  rm -rf /tmp/malmo.zip /var/lib/apt/lists/*

# FOR MINECRAFT VANILLA
#RUN apt-get install x11-xserver-utils && \
# wget -P vanilla http://s3.amazonaws.com/Minecraft.Download/launcher/Minecraft.jar
# java -jar Minecraft.jar

RUN echo "#!/usr/bin/env bash \\n \
      Xvfb :1 -screen 0 1024x768x16 &> xvfb.log & \\n \
      export DISPLAY=:1.0 \\n \
      ${MALMO_PATH}/Minecraft/launchClient.sh & \\n \
      x11vnc -nopw -forever -bg -shared -display :1" > ${MALMO_PATH}/Minecraft/malmo && \
  chmod +x ${MALMO_PATH}/Minecraft/malmo

RUN echo "#!/usr/bin/env bash \\n \
      Xvfb :1 -screen 0 320x240x16 &> xvfb.log & \\n \
      export DISPLAY=:1.0 \\n \
      ${MALMO_PATH}/Minecraft/launchClient.sh & \\n \
      x11vnc -nopw -forever -bg -shared -display :1" > ${MALMO_PATH}/Minecraft/malmo2 && \
  chmod +x ${MALMO_PATH}/Minecraft/malmo2

EXPOSE 5900

CMD ["${MALMO_PATH}/Minecraft/malmo"]