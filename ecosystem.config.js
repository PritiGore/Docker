### can call multiple files from one file
module.exports  = {
  apps : [
    {
      name   : "api",
      script : "/app/api/index.js",
      instances: 1,
      autorestart: true,
      watch: false,
      log_size: '5MB',
      log_max: 7
    },
    {
      name   : "socket-chat",
      script : "/app/chat/socket-chat.js",
      instances: 1,
      autorestart: true,
      watch: false,
      log_size: '5MB',
      log_max: 7
    },
    {
      name   : "chat",
      script : "/app/chat/index.js",
      instances: 1,
      autorestart: true,
      watch: false,
      log_size: '5MB',
      log_max: 7
    }
  ]
};

