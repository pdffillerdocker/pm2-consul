#!/bin/bash

set -e

exec /usr/sbin/logrotate -v /etc/logrotate.conf
