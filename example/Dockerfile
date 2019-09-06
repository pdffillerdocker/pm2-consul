ARG PM2_CONSUL_VERSION=latest
FROM pdffiller/pm2-consul:${PM2_CONSUL_VERSION}

ARG BUILD_ID=0
ARG VERSION=0.1.0

LABEL build_id="${BUILD_ID}" \
      version="${VERSION}" \
      pm2-consul_version="${PM2_CONSUL_VERSION}" \
      description="Node.js application" \
      maintainer="Anton Trifonov <rin@pdffiller.team>"

COPY . .

RUN cp -Rvp docker/files/* / && \
    npm install --production && \
    rm -rf \
        docker

EXPOSE 8080/tcp

CMD [ "app.js" ]
