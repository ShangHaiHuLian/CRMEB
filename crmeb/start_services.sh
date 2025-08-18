#!/bin/bash

# 确保脚本在错误时不退出（避免一个服务失败导致所有服务无法启动）
set +e

# 创建必要的目录
mkdir -p /var/www/runtime
chmod -R 777 /var/www/runtime

# 启动定时任务
echo "启动定时任务..."
php think timer start --d

# 启动消息队列（以www-data用户在后台运行）
echo "启动消息队列..."
su -c "php think queue:work --queue event" -s /bin/sh www-data &

# 启动长连接服务（以www-data用户在后台运行）
echo "启动长连接服务..."
su -c "php think workerman start" -s /bin/sh www-data &

# 启动PHP-FPM主进程（必须在前台运行）
echo "启动PHP-FPM..."
php-fpm

# 保持容器运行（这个命令可能不会执行到，但保留以防万一）
wait