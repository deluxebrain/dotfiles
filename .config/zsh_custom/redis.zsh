#!/bin/zsh

# redis extensions

# to start redis now and at login:
# brew services start redis

# start local redis server
function redis.start() {
    /opt/homebrew/opt/redis/bin/redis-server /opt/homebrew/etc/redis.conf
}
