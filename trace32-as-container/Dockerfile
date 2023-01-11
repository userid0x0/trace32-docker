FROM debian:bullseye

ARG T32ZIP
ARG T32EXE
ARG UNZIP_ARG

# simply run
# mkdir debian; touch debian/control
# dpkg-shlibdeps -O t32m??? t32screenqt5.so
RUN apt-get update \
 && apt-get install --no-install-recommends -y \
      libqt5core5a \
      libqt5gui5 \
      libqt5printsupport5 \
      libqt5widgets5 \
      libuuid1 \
      unzip \
      zlib1g \
 && rm -rf /var/lib/apt/lists/*

COPY ${T32ZIP} /tmp/trace32.zip
RUN cd /opt \
  && unzip -q ${UNZIP_ARG} /tmp/trace32.zip -d /opt/t32 \
  && chmod +x /opt/t32/bin/pc_linux64/t32m* \
  && rm /tmp/trace32.zip \
  && mkdir -p /t32work
COPY entrypoint.sh /entrypoint.sh
COPY config-example.t32 /t32work/config.t32

# Intercom
EXPOSE 10000/udp
# RemoteAPI (TCP)
EXPOSE 20000/tcp

ENV T32SYS=/opt/t32
ENV T32EXE=${T32EXE}
WORKDIR /t32work

ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["-c", "config.t32"]