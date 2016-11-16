FROM ubuntu

MAINTAINER tnarik <tnarik@lecafeautomatique.co.uk>

ARG MALMO_BUILD_PATH=/tmp/malmo_build

ENV MALMO_PATH /opt/malmo
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

  # Build Malmö from source
  apt-get install -y wget \
  build-essential \
  git \
  cmake cmake-qt-gui \
  libboost-all-dev libpython2.7-dev \
  lua5.1 liblua5.1-0-dev \
  openjdk-8-jdk \
  swig \
  xsdcxx libxerces-c-dev \
  doxygen \
  xsltproc \
  ffmpeg \
  python-tk python-imaging-tk && \

  export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 && \

  # Mono
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
  echo "deb http://download.mono-project.com/repo/debian wheezy main" | tee /etc/apt/sources.list.d/mono-xamarin.list && \
  echo "deb http://download.mono-project.com/repo/debian wheezy-apache24-compat main" | tee -a /etc/apt/sources.list.d/mono-xamarin.list && \
  apt-get update && \
  apt-get install -y mono-devel && \

  git clone https://github.com/rpavlik/luabind.git /tmp/luabind && \
  cd /tmp/luabind && \
  mkdir build && cd build && \
  cmake -DCMAKE_BUILD_TYPE=Release .. && \
  make install && \
# TILL THE MARK, ADDED TO SUPPORT work from a local repo (breaks the Dockerfile in 2 RUN sections with a COPY of local code)
  true

COPY malmo ${MALMO_BUILD_PATH}

RUN  cd ${MALMO_BUILD_PATH} && \
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 && \

# MARK, ADDED TO SUPPORT work from a local repo  (where removed, the below lines should be uncommented) 
# git clone https://github.com/tnarik/malmo.git ${MALMO_BUILD_PATH} && \
# cd ${MALMO_BUILD_PATH} && \
# git checkout -t origin/multiagent_single_account && \

  wget https://raw.githubusercontent.com/bitfehler/xs3p/1b71310dd1e8b9e4087cf6120856c5f701bd336b/xs3p.xsl -P ${MALMO_BUILD_PATH}/Schemas && \
  mkdir build && cd build && \
  cmake -DCMAKE_BUILD_TYPE=Release .. && \
  make install && \

  cp -r ${MALMO_BUILD_PATH}/build/install ${MALMO_PATH} && \
  cd ${MALMO_PATH}/Minecraft && \
  ./gradlew setupDecompWorkspace && \
  ./gradlew build && \

  # clean up
  apt-get clean && \
  rm -rf /tmp/* /tmp/.[!.]* /tmp/..?*  /var/lib/apt/lists/*

COPY files/malmo_client ${MALMO_PATH}/malmo_client
RUN chmod 777 ${MALMO_PATH}/malmo_client

EXPOSE 5900
EXPOSE 10000

WORKDIR /code

CMD [ "/opt/malmo/malmo_client" ]
