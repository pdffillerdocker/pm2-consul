ARG NODE_VERSION=12.10.0
FROM node:${NODE_VERSION}-alpine

ARG BUILD_ID=0
ARG VERSION=${NODE_VERSION}
ARG CONSUL_TEMPLATE_VERSION=0.21.3
ARG COMPONENTS_VERSION=1.0.0

LABEL build_id="${BUILD_ID}" \
      version="${VERSION}" \
      node_version="${NODE_VERSION}" \
      consul-template_version="${CONSUL_TEMPLATE_VERSION}" \
      components_version="${COMPONENTS_VERSION}" \
      description="PM2 with consul-template Docker Image" \
      maintainer="Anton Trifonov <rin@pdffiller.team>"

RUN apk --no-cache add \
      bash \
      curl \
      tar \
      logrotate && \
    rm -rf /etc/logrotate.d/*

ARG PM2_HOME=/pm2
ARG PM2_DEFAULT_LOG_PATH=/var/log/pm2

ENV PM2_HOME=${PM2_HOME} \
    PM2_DEFAULT_LOG_PATH=${PM2_DEFAULT_LOG_PATH}

RUN npm install -g pm2 && \
    pm2 ls && \
    ln -s ${PM2_DEFAULT_LOG_PATH} ${PM2_HOME}/logs

COPY ./files /

ARG DEV_MODE=0

RUN cd /tmp && \
    curl -o consul-template.tgz https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.tgz && \
    tar -zxvf consul-template.tgz && \
    mv consul-template /usr/local/bin/ && \
    mkdir -p \
        /var/log/nodejs \
    cd /tmp && \
    pm2 package consul-template_pm2_module && \
    pm2 install /tmp/consul-template_pm2_module*.tar.gz && \
    pm2 package logrotate_pm2_module && \
    pm2 install /tmp/logrotate_pm2_module*.tar.gz && \
    chmod +x \
        /usr/local/bin/consul-template \
        /usr/local/bin/exec_consul-template.sh \
        /usr/local/bin/exec_logrotate.sh \
        /entrypoint.sh && \
    if [[ ${DEV_MODE} == 0 ]]; then \
        rm -rf /tmp/* /pm2/pm2.log /var/log/pm2/*; \
    fi

WORKDIR /app

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/etc/pm2/ecosystem.config.js"]

ONBUILD RUN rm -rf /app/*
