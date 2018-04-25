FROM lsiobase/mono:xenial

# SONARR
# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="sparklyballs"

# set environment variables
ARG DEBIAN_FRONTEND="noninteractive"
ENV XDG_CONFIG_HOME="/config/xdg"

RUN \
 echo "**** add sonarr repository ****" && \
 apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FDA5DFFC && \
 echo "deb http://apt.sonarr.tv/ master main" > \
	/etc/apt/sources.list.d/sonarr.list && \
 echo "**** install packages ****" && \
 apt-get update && \
 apt-get install -y \
	nzbdrone && \
 echo "**** cleanup ****" && \
 apt-get clean && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# ports and volumes
EXPOSE 8989
VOLUME /config /downloads /tv


# JACKETT
# set version label

# environment settings
#ENV XDG_DATA_HOME="/config" \
#XDG_CONFIG_HOME="/config"

RUN \
 echo "**** install packages ****" && \
 apt-get update && \
 apt-get install -y \
        wget telnet && \
 echo "**** install jackett ****" && \
 mkdir -p \
        /app/Jackett && \
 jack_tag=$(curl -sX GET "https://api.github.com/repos/Jackett/Jackett/releases/latest" \
        | awk '/tag_name/{print $4;exit}' FS='[""]') && \
 curl -o \
 /tmp/jacket.tar.gz -L \
        https://github.com/Jackett/Jackett/releases/download/$jack_tag/Jackett.Binaries.Mono.tar.gz && \
 tar xf \
 /tmp/jacket.tar.gz -C \
        /app/Jackett --strip-components=1 && \
 echo "**** cleanup ****" && \
 apt-get clean && \
 rm -rf \
        /tmp/* \
        /var/lib/apt/lists/* \
        /var/tmp/*


# add local files
COPY root/ /

# ports and volumes
EXPOSE 9117
