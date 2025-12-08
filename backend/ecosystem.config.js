module.exports = {
    apps: [{
        name: 'rabbitfarm-api',
        script: 'src/server.js',
        instances: 1,
        autorestart: true,
        watch: false,
        max_memory_restart: '1G',
        env: {
            NODE_ENV: 'development',
            PORT: 4567
        },
        env_production: {
            NODE_ENV: 'production',
            PORT: 4567
        },
        error_file: 'logs/err.log',
        out_file: 'logs/out.log',
        log_date_format: 'YYYY-MM-DD HH:mm:ss Z',
        merge_logs: true
    }]
};
