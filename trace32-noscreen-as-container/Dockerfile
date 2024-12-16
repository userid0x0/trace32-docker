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
# dpkg-shlibdeps -O t32m??? t32screenoff.so
RUN apt update \
    && apt install --no-install-recommends -y \
      libcurl4 \
      libuuid1 \
      zlib1g \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/

# copy TRACE32
COPY --from=extractor /opt/t32 /opt/t32

RUN mkdir -p /t32work
COPY entrypoint.sh /entrypoint.sh
COPY config-example.t32 /t32work/config.t32

# generate a hello-world example script - work-settings.cmm is started upon TRACE32 startup
RUN echo "\n\
DIAG.LOGGER /AREA /STDOUT /PRINTCMD\n\
PRINTER.AREA ASCIIE\n\
PRINT \"Hello World on \" OS.NAME()\n\
WinPRINT.VERSION.SOFTWARE\n\
QUIT\n" > /t32work/work-settings.cmm

ARG TARGETARCH
RUN (([ "$TARGETARCH" = "arm64" ] && sed -i 's/pc_linux64/linux-aarch64/g' /entrypoint.sh) || true) \
    && chmod +x /entrypoint.sh

# Intercom
# RemoteAPI (TCP)
EXPOSE 10000/udp \
       20000/tcp

ARG T32EXE=t32marm
ENV T32EXE=${T32EXE} \
    T32SYS=/opt/t32 \
    T32SCREENSO=t32screenoff.so \
    T32SCREENOFF=1
WORKDIR /t32work

ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["-c", "config.t32"]