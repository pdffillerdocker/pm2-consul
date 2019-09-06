module.exports = {
    apps: [].concat(
        {
            script: 'server.js',
            name: 'app',
            max_memory_restart: '256M',
            restart_delay: 100,
            max_restarts: 0,
            log_type: 'json',
        }
    ),
};
