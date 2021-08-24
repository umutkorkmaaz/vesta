#!/bin/bash
# Adding php pool conf
user="$1"
domain="$2"
ip="$3"
home_dir="$4"
docroot="$5"

pool_conf="[$2]

listen = /run/php/php7.4-fpm-$2.sock
listen.owner = $1
listen.group = $1
listen.mode = 0666

user = $1
group = $1

pm = ondemand
pm.max_children = 8
request_terminate_timeout = 90s
pm.max_requests = 4000
pm.process_idle_timeout = 10s
pm.status_path = /status

php_admin_value[upload_tmp_dir] = /home/$1/tmp
php_admin_value[session.save_path] = /home/$1/tmp
php_admin_value[open_basedir] = $5:/home/$1/tmp:/bin:/usr/bin:/usr/local/bin:/var/www/html:/tmp:/usr/share:/etc/phpmyadmin:/var/lib/phpmyadmin:/etc/roundcube:/var/log/roundcube:/var/lib/roundcube
php_admin_value[upload_max_filesize] = 80M
php_admin_value[max_execution_time] = 30
php_admin_value[post_max_size] = 80M
php_admin_value[memory_limit] = 256M
php_admin_value[sendmail_path] = \"/usr/sbin/sendmail -t -i -f info@$2\"
php_admin_flag[mysql.allow_persistent] = off
php_admin_flag[safe_mode] = off

env[PATH] = /usr/local/bin:/usr/bin:/bin
env[TMP] = /home/$1/tmp
env[TMPDIR] = /home/$1/tmp
env[TEMP] = /home/$1/tmp
"

pool_file_56="/etc/php/5.6/fpm/pool.d/$2.conf"
pool_file_70="/etc/php/7.0/fpm/pool.d/$2.conf"
pool_file_71="/etc/php/7.1/fpm/pool.d/$2.conf"
pool_file_72="/etc/php/7.2/fpm/pool.d/$2.conf"
pool_file_73="/etc/php/7.3/fpm/pool.d/$2.conf"
pool_file_74="/etc/php/7.4/fpm/pool.d/$2.conf"
pool_file_80="/etc/php/8.0/fpm/pool.d/$2.conf"

if [ -f "$pool_file_56" ]; then
    rm $pool_file_56
    systemctl reset-failed php5.6-fpm
    systemctl restart php5.6-fpm
fi

if [ -f "$pool_file_70" ]; then
    rm $pool_file_70
    systemctl reset-failed php7.0-fpm
    systemctl restart php7.0-fpm
fi

if [ -f "$pool_file_71" ]; then
    rm $pool_file_71
    systemctl reset-failed php7.1-fpm
    systemctl restart php7.1-fpm
fi

if [ -f "$pool_file_72" ]; then
    rm $pool_file_72
    systemctl reset-failed php7.2-fpm
    systemctl restart php7.2-fpm
fi

if [ -f "$pool_file_73" ]; then
    rm $pool_file_73
    systemctl reset-failed php7.3-fpm
    systemctl restart php7.3-fpm
fi

write_file=0
if [ ! -f "$pool_file_74" ]; then
  write_file=1
else
  user_count=$(grep -c "/home/$1/" $pool_file_74)
  if [ $user_count -eq 0 ]; then
    write_file=1
  fi
fi
if [ $write_file -eq 1 ]; then
    echo "$pool_conf" > $pool_file_74
    systemctl reset-failed php7.4-fpm
    systemctl restart php7.4-fpm
fi
if [ -f "/etc/php/7.4/fpm/pool.d/www.conf" ]; then
    rm /etc/php/7.4/fpm/pool.d/www.conf
fi

if [ -f "$pool_file_80" ]; then
    rm $pool_file_80
    systemctl reset-failed php8.0-fpm
    systemctl restart php8.0-fpm
fi

exit 0
