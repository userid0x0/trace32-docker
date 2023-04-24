FROM debian:bullseye

# simply run
# mkdir debian; touch debian/control
# dpkg-shlibdeps -O t32m??? t32screenqt5.so
RUN apt-get update \
  && apt-get install --no-install-recommends -y \
      libcurl4 \
      libqt5core5a \
      libqt5gui5 \
      libqt5printsupport5 \
      libqt5widgets5 \
      libuuid1 \
      unzip \
      zlib1g \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /t32work /opt/t32
COPY entrypoint.sh /entrypoint.sh
COPY config-example.t32 /t32work/config.t32

# Volumes
## TRACE32 working directory
VOLUME /t32work
## TRACE32 installation
VOLUME /opt/t32

# Intercom
EXPOSE 10000/udp
# RemoteAPI (TCP)
EXPOSE 20000/tcp

ENV T32SYS=/opt/t32
ENV PATH="/opt/t32/bin/pc_linux64:${PATH}"
WORKDIR /t32work

ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["t32marm", "-c", "config.t32"]
