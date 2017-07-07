FROM oberthur/docker-centos_i386

# Java Version
ENV JAVA_VERSION_MAJOR=8 \
    JAVA_VERSION_MINOR=131 \
    JAVA_VERSION_BUILD=11 \
    JAVA_PACKAGE=jdk \
    JAVA_PLATFORM=linux-i586.tar.gz \
    JAVA_HOME=/opt/jdk \
    PATH=${PATH}:/opt/jdk/bin

LABEL author="Tomasz Malinowski <t.malinowski@oberthur.com>"
LABEL version="docker-centos_i386-gcc"

RUN yum -y update

RUN yum -y install yum-plugin-ovl epel-release

RUN yum -y install tar unzip wget gcc vim git jq

RUN wget -c -O "${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-${JAVA_PLATFORM}" \
        --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" \
        "http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/d54c1d3a095b4ff2b6607d096fa80163/${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-${JAVA_PLATFORM}" \
    && tar xfv ${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-i586.tar.gz -C /opt \
    && rm ${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-i586.tar.gz \
    && ln -s /opt/jdk1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR} /opt/jdk \
    && rm -rf /opt/jdk/*src.zip \
           /opt/jdk/lib/missioncontrol \
           /opt/jdk/lib/visualvm \
           /opt/jdk/lib/*javafx* \
           /opt/jdk/jre/lib/plugin.jar \
           /opt/jdk/jre/bin/javaws \
           /opt/jdk/jre/lib/javaws.jar \
           /opt/jdk/jre/lib/desktop \
           /opt/jdk/jre/plugin \
           /opt/jdk/jre/lib/deploy* \
           /opt/jdk/jre/lib/*javafx* \
           /opt/jdk/jre/lib/*jfx* \
           /opt/jdk/jre/lib/i386/libdecora_sse.so \
           /opt/jdk/jre/lib/i386/libprism_*.so \
           /opt/jdk/jre/lib/i386/libfxplugins.so \
           /opt/jdk/jre/lib/i386/libglass.so \
           /opt/jdk/jre/lib/i386/libgstreamer-lite.so \
           /opt/jdk/jre/lib/i386/libjavafx*.so \
           /opt/jdk/jre/lib/i386/libjfx*.so \

    && mkdir -p /opt/jdk/jre/lib/security \
    # Download Java Cryptography Extension
    && curl -s -k -L -C - -b "oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jce/${JAVA_VERSION_MAJOR}/jce_policy-${JAVA_VERSION_MAJOR}.zip > /tmp/jce_policy-${JAVA_VERSION_MAJOR}.zip \
    && unzip -d /tmp/ /tmp/jce_policy-${JAVA_VERSION_MAJOR}.zip \
    && yes |cp -v /tmp/UnlimitedJCEPolicyJDK${JAVA_VERSION_MAJOR}/*.jar /opt/jdk/jre/lib/security/ \

# clean up
    && rm -rf /var/cache/yum/* \
    && yum clean all

