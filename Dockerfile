ARG NODE_VERSION=13
FROM quay.io/ukhomeofficedigital/cop-node:$NODE_VERSION

ARG CYPRESS_CACHE_FOLDER=/home/node/.cache/Cypress
ARG CYPRESS_VERSION=3.8.3

USER root
RUN apt-get update && \
    apt-get -y install  \
        libasound2 \
        libgtk-3-0 \
        libnss3 \
        libxss1 \
        libxtst6 \
        python-pip  \
        xvfb && \
        pip install s3cmd boto3 flatten-dict

RUN npm config -g set user "$USER" && \
    npm install -g "cypress@${CYPRESS_VERSION}" && \
    cypress verify

# Cypress cache and installed version
RUN cypress cache path && \
    cypress cache list

ENTRYPOINT ["cypress", "run"]
