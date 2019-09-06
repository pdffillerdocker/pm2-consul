# PM2-Consul usage example

Very simple Node.js server, which writes to STDOUT and STDERR and use the `winston` Node.js module
to write own log file.

To start simply run:

```shell
$ docker-compose up
```

After that application can be accessed via [http://localhost/](http://localhost/)

Log files are located in `logs/pm2` and `logs/nodejs` directories.

To force log files rotation run:

```shell
$ docker-compose exec app /usr/sbin/logrotate -f /etc/logrotate.conf
```

Consul KV can be changed via [http://localhost:8500/ui/dc1/kv](http://localhost:8500/ui/dc1/kv)
