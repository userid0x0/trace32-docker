FROM debian:bullseye as extractor

ARG T32ZIP
ARG UNZIP_ARG
ARG TARGETARCH

RUN apt-get update \
  && apt-get install --no-install-recommends -y \
      unzip \
  && rm -rf /var/lib/apt/lists/*

COPY ${T32ZIP} /tmp/trace32.zip
RUN cd /opt \
  && unzip -q ${UNZIP_ARG} /tmp/trace32.zip -d /opt/t32 \
  && (([ "$TARGETARCH" = "arm64" ] && chmod +x /opt/t32/bin/linux-aarch64/t32m*) || chmod +x /opt/t32/bin/pc_linux64/t32m*) \
  && rm /tmp/trace32.zip

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
      libqt5svg5 \
      libqt5widgets5 \
      libuuid1 \
      zlib1g \
  && rm -rf /var/lib/apt/lists/*

# copy TRACE32
COPY --from=extractor /opt/t32 /opt/t32

RUN mkdir -p /t32work
COPY entrypoint.sh /entrypoint.sh
COPY config-example.t32 /t32work/config.t32

ARG TARGETARCH
RUN (([ "$TARGETARCH" = "arm64" ] && sed -i 's/pc_linux64/linux-aarch64/g' /entrypoint.sh) || true) \
  && chmod +x /entrypoint.sh

# Intercom
EXPOSE 10000/udp
# RemoteAPI (TCP)
EXPOSE 20000/tcp

ARG T32EXE=t32marm
ENV T32SYS=/opt/t32
ENV T32EXE=${T32EXE}
WORKDIR /t32work

ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["-c", "config.t32"]
