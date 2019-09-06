#!/bin/bash

set -e

exec /usr/local/bin/consul-template \
       -consul-addr=${CONSUL_HTTP_ADDR} \
       -consul-retry \
       -consul-retry-attempts=0 \
       -consul-retry-backoff="250ms" \
       -consul-retry-max-backoff="1m" \
       -log-level="trace" \
       -config="/etc/consul/consul.hcl"
