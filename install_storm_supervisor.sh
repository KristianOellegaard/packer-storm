cat > /etc/init/storm-supervisor.conf <<EOF
description "Storm Supervisor daemon"
author "Kristian Oellegaard <kristian@livesystems.info>"

start on runlevel [2345]
respawn
console log
chdir /etc/storm/

script
    exec bin/storm supervisor
end script

EOF
