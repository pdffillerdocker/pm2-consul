#!/bin/bash
set -e

# run provision scripts
for f in $(ls -1 /provision.d/*.sh 2>/dev/null); do
    echo "$0: sourcing $f"
    . "$f"
    set -e
done

# if options specified run 'pm2-runtime --error ...'
if [ "${1#-}" != "$1" ]; then
    set -- pm2-runtime --error ${PM2_DEFAULT_LOG_PATH}/app-error.log --output ${PM2_DEFAULT_LOG_PATH}/app-out.log "$@"
fi

# if pm2 config specified run pm2-runtime
if [[ $1 == *.config.js || $1 == *.config.mjs || $1 == *.json || $1 == *.yml || $1 == *.yaml ]]; then
    set -- pm2-runtime "$@"
# if nodejs application specified write this application to /etc/pm2/ecosystem.config.js and run 'pm2-runtime /etc/pm2/ecosystem.config.js'
elif [[ $1 == *.js ]]; then
    scriptname="$1"
    scriptbasename="`basename "${scriptname}"`"
    appname="${scriptbasename%.js}"
    sed -i "s# script: 'server.js',# script: '${scriptname}',#" /etc/pm2/ecosystem.config.js
    sed -i "s# name: 'app',# name: '${appname}',#" /etc/pm2/ecosystem.config.js
    set -- pm2-runtime /etc/pm2/ecosystem.config.js
fi

# if 'start' command specified run 'pm2-runtime start --error ...'
if [ "$1" == "start" ]; then
    shift
    set -- pm2-runtime start --error ${PM2_DEFAULT_LOG_PATH}/app-error.log --output ${PM2_DEFAULT_LOG_PATH}/app-out.log "$@"
fi

echo "$0: executing '$@' ($1)"
exec "$@"
