FROM debian:bookworm as extractor

ARG T32ZIP \
    UNZIP_ARG \
    TARGETARCH

RUN apt update \
    && apt install --no-install-recommends -y \
      unzip \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/

RUN --mount=type=bind,target=/context \
    cd /opt \
    && unzip -q ${UNZIP_ARG} /context/${T32ZIP} -d /opt/t32 \
    && (([ "$TARGETARCH" = "arm64" ] && chmod +x /opt/t32/bin/linux-aarch64/t32m*) || chmod +x /opt/t32/bin/pc_linux64/t32m*)

RUN rm -rf /opt/t32/{windows,windows64,macosx64} \
    && (([ "$TARGETARCH" = "arm64" ] && rm -rf /opt/t32/bin/pc_linux64) || rm -rf /opt/t32/bin/linux-aarch64)

FROM debian:bookworm

# simply run
# mkdir debian; touch debian/control
# dpkg-shlibdeps -O t32m??? t32screenqt5.so
RUN apt update \
    && apt install --no-install-recommends -y \
      libcurl4 \
      libqt5core5a \
      libqt5gui5 \
      libqt5printsupport5 \
      libqt5svg5 \
      libqt5widgets5 \
      libuuid1 \
      zlib1g \
      # X-Server related
      xauth \
      xxd \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/

# copy TRACE32
COPY --from=extractor /opt/t32 /opt/t32

RUN mkdir -p /t32work
COPY entrypoint.sh /entrypoint.sh
COPY config-example.t32 /t32work/config.t32
ADD --chown=root:root \
    --chmod=555 \
    https://gist.github.com/userid0x0/6e4fc3b424358ed98ad3fcece9d4a797/raw/xauthority-wildcard.sh \
    /usr/local/bin/xauthority-wildcard.sh

ARG TARGETARCH
RUN (([ "$TARGETARCH" = "arm64" ] && sed -i 's/pc_linux64/linux-aarch64/g' /entrypoint.sh) || true) \
    && chmod +x /entrypoint.sh

# Intercom
# RemoteAPI (TCP)
EXPOSE 10000/udp \
       20000/tcp

ARG T32EXE=t32marm
ENV T32SYS=/opt/t32 \
    T32EXE=${T32EXE}
WORKDIR /t32work

ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["-c", "config.t32"]
