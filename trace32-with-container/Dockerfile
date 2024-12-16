FROM debian:bookworm

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
      unzip \
      zlib1g \
      # X-Server related
      xauth \
      xxd \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/

RUN mkdir -p /t32work /opt/t32
COPY entrypoint.sh /entrypoint.sh
COPY config-example.t32 /t32work/config.t32
ADD --chown=root:root \
    --chmod=555 \
    https://gist.github.com/userid0x0/6e4fc3b424358ed98ad3fcece9d4a797/raw/xauthority-wildcard.sh \
    /usr/local/bin/xauthority-wildcard.sh

ARG TARGETARCH
RUN (([ "$TARGETARCH" = "arm64" ] && sed -i 's/pc_linux64/linux-aarch64/g' /entrypoint.sh) || true) \
  && chmod +x /entrypoint.sh

# Volumes
## TRACE32 working directory
VOLUME /t32work
## TRACE32 installation
VOLUME /opt/t32

# Intercom
# RemoteAPI (TCP)
EXPOSE 10000/udp \
       20000/tcp

ENV T32SYS=/opt/t32
WORKDIR /t32work

ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["t32marm", "-c", "config.t32"]
