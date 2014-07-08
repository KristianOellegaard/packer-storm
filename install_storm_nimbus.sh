cat > /etc/init/storm-nimbus.conf <<EOF
description "Storm Nimbus daemon"
author "Kristian Oellegaard <kristian@livesystems.info>"

start on runlevel [2345]
respawn
console log
chdir /etc/storm/

script
    exec bin/storm nimbus
end script

EOF

cat > /etc/init/storm-ui.conf <<EOF
description "Storm Web UI daemon"
author "Kristian Oellegaard <kristian@livesystems.info>"

start on runlevel [2345]
respawn
console log
chdir /etc/storm/

script
    exec bin/storm ui
end script

EOF


