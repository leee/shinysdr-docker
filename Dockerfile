# TODO: take advantage of multi-stage builds:
# do makes in a build image, make install into prod image

FROM ubuntu:20.04

# git vs git-all
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential \
    # git-all \
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
    python3-setuptools

WORKDIR /tmp

# Install gr-dsd at last gr3.8 compat
RUN mkdir gr-dsd && cd gr-dsd && git init && \
    git remote add origin https://github.com/argilo/gr-dsd && \
    git fetch --depth 1 origin d81c3ed69123fe255708f0f4611e883301acf553 && \
    git checkout FETCH_HEAD && \
    \
    mkdir build && cd build && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr .. && \
    make && make install && ldconfig

# Install gr-radioteletype at last gr3.8 compat
RUN DEBIAN_FRONTEND=noninteractive && \
    mkdir gr-radioteletype && cd gr-radioteletype && git init && \
    git remote add origin https://github.com/dl1ksv/gr-radioteletype && \
    git fetch --depth 1 origin 79b3d75b2bc04caf431361f3e6eb3184a6fe1b43 && \
    git checkout FETCH_HEAD && \
    \
    mkdir build && cd build && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr .. && \
    make && make install && ldconfig

# Install ShinySDR fork
RUN git clone --depth 1 https://github.com/w1xm/shinysdr && \
    cd shinysdr && \
    \
    python3 setup.py build && \
    python3 setup.py install --force

RUN apt-get clean && apt autoclean -y