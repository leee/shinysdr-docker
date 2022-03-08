FROM ubuntu:20.04

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && apt-get install -y \
    build-essential \
    git \
    cmake \
    gnuradio \
    gnuradio-dev \
    libsndfile1-dev \
    libboost-all-dev \
    libcppunit-dev \
    libitpp-dev \
    liblog4cpp5-dev \
    swig \
    liborc-0.4-dev \
    gr-osmosdr \
    gr-air-modes \
    wsjtx \
    multimon-ng \
    rtl-433 \
    alsa-utils \
    python3-setuptools \
    dbus \
    avahi-daemon \
    && \
    apt autoclean

WORKDIR /tmp

# Install gr-dsd at last gr3.8 compat
RUN mkdir gr-dsd && cd gr-dsd && git init && \
    git remote add origin https://github.com/argilo/gr-dsd && \
    git fetch --depth 1 origin d81c3ed69123fe255708f0f4611e883301acf553 && \
    git checkout FETCH_HEAD && \
    \
    mkdir build && cd build && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr .. && \
    make && make install && ldconfig && \
    cd ../.. && rm -rf gr-dsd

# Install gr-radioteletype at last gr3.8 compat
RUN DEBIAN_FRONTEND=noninteractive && \
    mkdir gr-radioteletype && cd gr-radioteletype && git init && \
    git remote add origin https://github.com/dl1ksv/gr-radioteletype && \
    git fetch --depth 1 origin 79b3d75b2bc04caf431361f3e6eb3184a6fe1b43 && \
    git checkout FETCH_HEAD && \
    \
    mkdir build && cd build && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr .. && \
    make && make install && ldconfig && \
    cd ../.. && rm -rf gr-radioteletype

# Install ShinySDR fork
RUN git clone --depth 1 https://github.com/w1xm/shinysdr && \
    cd shinysdr && \
    \
    python3 setup.py build && \
    python3 setup.py install --force && \
    cd .. && rm -rf shinysdr

# shinysdr won't run as root
RUN adduser --gecos "" --disabled-password shinysdr

# alsa quirk
RUN su - shinysdr -c "echo 'pcm.!default = null;' >> ~/.asoundrc"

# gnuradio quirk
# ENV HOME=/tmp

COPY --chown=shinysdr:shinysdr shinysdr.sh shinysdr.sh

RUN chmod +x shinysdr.sh

EXPOSE 8100/tcp
EXPOSE 8101/tcp

ENTRYPOINT ["./shinysdr.sh"]
CMD ["/app"]
