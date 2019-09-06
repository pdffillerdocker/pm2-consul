#!/bin/bash

export PM2_DEFAULT_LOG_PATH="${PM2_DEFAULT_LOG_PATH:=/root/.pm2}"
sed -i "s#%PM2_DEFAULT_LOG_PATH%#${PM2_DEFAULT_LOG_PATH}#g" /etc/logrotate.d/pm2
