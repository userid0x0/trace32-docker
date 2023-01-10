FROM debian:bullseye

ARG T32ZIP
ARG T32EXE

# simply run
# mkdir debian; touch debian/control
# dpkg-shlibdeps -O t32m??? t32screenoff.so
RUN apt-get update \
 && apt-get install --no-install-recommends -y \
      libuuid1 \
      unzip \
      zlib1g \
 && rm -rf /var/lib/apt/lists/*

COPY ${T32ZIP} /tmp/trace32.zip
RUN cd /opt \
  && unzip -q /tmp/trace32.zip -d /opt/t32 \
  && chmod +x /opt/t32/bin/pc_linux64/t32m* \
  && rm /tmp/trace32.zip \
  && mkdir -p /t32work \
  && (echo "#!/bin/bash\nexec /opt/t32/bin/pc_linux64/${T32EXE} \${@}" > /entrypoint.sh) \
  && chmod +x /entrypoint.sh

# generate a super simple config file using TRACE32 Simulator
RUN echo "PBI=SIM\n\
\n\
; T32 Intercom\n\
IC=NETASSIST\n\
PORT=10000\n\
\n\
; T32 API Access (UDP)\n\
RCL=NETASSIST\n\
PORT=20000\n\
PACKLEN=1024\n\
\n\
; T32 API Access (TCP)\n\
RCL=NETTCP\n\
PORT=20000\n" > /t32work/config.t32

# generate a hello-world example script - work-settings.cmm is started upon TRACE32 startup
RUN echo "\n\
DIAG.LOGGER /AREA /STDOUT /PRINTCMD\n\
PRINTER.AREA ASCIIE\n\
PRINT \"Hello World on \" OS.NAME()\n\
WinPRINT.VERSION.SOFTWARE\n\
QUIT\n" > /t32work/work-settings.cmm

# Intercom
EXPOSE 10000/udp
# RemoteAPI (TCP)
EXPOSE 20000/tcp

ENV T32SYS=/opt/t32
ENV T32SCREENSO=t32screenoff.so
ENV T32SCREENOFF=1
WORKDIR /t32work

ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["-c", "config.t32"]