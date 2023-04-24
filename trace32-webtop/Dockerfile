FROM lscr.io/linuxserver/webtop:ubuntu-openbox as extractor

ARG T32ZIP
ARG UNZIP_ARG

RUN apt-get update \
  && apt-get install --no-install-recommends -y \
      unzip \
  && rm -rf /var/lib/apt/lists/*

COPY ${T32ZIP} /tmp/trace32.zip
RUN cd /opt \
  && unzip -q ${UNZIP_ARG} /tmp/trace32.zip -d /opt/t32 \
  && chmod +x /opt/t32/bin/pc_linux64/t32m* \
  && rm /tmp/trace32.zip

FROM lscr.io/linuxserver/webtop:ubuntu-openbox

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
      zlib1g \
  && rm -rf /var/lib/apt/lists/*

# copy TRACE32
COPY --from=extractor /opt/t32 /opt/t32

COPY start-t32.sh /usr/local/bin/start-t32
COPY config-example.t32 /t32work/config.t32
COPY user-preferences.cfg /config/.trace32/user-preferences.cfg

RUN sed -i '/id="root-menu"/a   <item label="TRACE32">\n<action name="Execute"><execute>start-t32</execute></action>\n</item>' /defaults/menu.xml \
  && (echo "start-t32" > /defaults/autostart) \
  && chmod +x /usr/local/bin/start-t32

# Intercom
EXPOSE 10000/udp
# RemoteAPI (TCP)
EXPOSE 20000/tcp

ARG T32EXE
ENV T32SYS=/opt/t32
ENV T32EXE=${T32EXE}
