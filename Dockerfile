FROM digitalpatterns/node:4

ENV CI=1
ARG CYPRESS_VERSION="3.3.1"

RUN yum -y update && \
    yum -y install  \
        python2-pip  \
        gtk3 \
        xorg-x11-server-Xvfb \
        libXScrnSaver \
        GConf2-devel \
        alsa-lib \
        git \
        yum -y clean all && \
        pip install s3cmd && \
        chown -R "$USER":"$GROUP" "$HOME" /app /usr/src /drone

USER 1000
RUN npm config -g set user "$USER" && \
    npm install -g "cypress@${CYPRESS_VERSION}" \
                cypress-file-upload\
                mocha@5.2.0 \
                mochawesome \
                mochawesome-report-generator && \
    cypress verify

# Cypress cache and installed version
RUN cypress cache path && \
    cypress cache list

USER root

ENTRYPOINT ["cypress", "run"]
