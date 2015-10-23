FROM ubuntu:12.04

MAINTAINER Pete Hodgson <phodgson@thoughtworks.com>

RUN apt-get update && apt-get install -y \
	build-essential \
  libbluetooth-dev \
  bluez \
  rfkill \
  bluetooth \
  lib32z1 \
  lib32ncurses5 \
  unzip \
  binutils-avr \
	git \
  cmake 

RUN mkdir -p /opt/fruityfactory/downloads

WORKDIR /opt/fruityfactory

RUN wget -qO- https://github.com/mwaylabs/fruitymesh-devenv/archive/master.tar.gz | tar -xz && mv fruitymesh-devenv-master nrf

RUN wget --post-data="agree=1&confirm=yes" "https://www.segger.com/jlink-software.html?step=1&file=JLinkLinuxDEB64_5.2.6" -O downloads/jlink_5.2.6_x86_64.deb && dpkg -i downloads/jlink_5.2.6_x86_64.deb

ADD https://launchpad.net/gcc-arm-embedded/4.9/4.9-2015-q3-update/+download/gcc-arm-none-eabi-4_9-2015q3-20150921-linux.tar.bz2 downloads/gcc-arm-none-eabi-4_9-2015q3-20150921-linux.tar.bz2
RUN tar -C /usr/local -xjf downloads/gcc-arm-none-eabi-4_9-2015q3-20150921-linux.tar.bz2

ADD https://developer.nordicsemi.com/nRF51_SDK/nRF51_SDK_v9.x.x/nRF51_SDK_9.0.0_2e23562.zip downloads/nRF51_SDK_9.0.0_2e23562.zip
RUN unzip downloads/nRF51_SDK_9.0.0_2e23562.zip -d nrf/sdk/nrf_sdk_9_0

ADD https://developer.nordicsemi.com/nRF52_SDK/nRF52_SDK_v0.x.x/nRF52_SDK_0.9.2_dbc28c9.zip downloads/nRF52_SDK_0.9.2_dbc28c9.zip
RUN unzip downloads/nRF51_SDK_9.0.0_2e23562.zip -d nrf/sdk/nrf52_sdk_0_9_1

RUN ln -s ehal_2015_09_08 nrf/sdk/ehal_latest
RUN ln -s ../../arm_cmsis_4_3/CMSIS nrf/sdk/ehal_latest/ARM/CMSIS

COPY files/Makefile.posix nrf/sdk/nrf_sdk_9_0/components/toolchain/gcc/Makefile.posix
COPY files/Makefile.posix nrf/sdk/nrf52_sdk_0_9_1/components/toolchain/gcc/Makefile.posix

COPY files/nrf_svc.h nrf/sdk/nrf_sdk_9_0/components/softdevice/s130/headers/nrf_svc.h

