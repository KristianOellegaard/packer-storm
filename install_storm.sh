cat > /etc/apt/sources.list <<EOF
## Note, this file is written by cloud-init on first boot of an instance
## modifications made here will not survive a re-bundle.
## if you wish to make changes you can:
## a.) add 'apt_preserve_sources_list: true' to /etc/cloud/cloud.cfg
##     or do the same in user-data
## b.) add sources in /etc/apt/sources.list.d
## c.) make changes to template file /etc/cloud/templates/sources.list.tmpl
#

# See http://help.ubuntu.com/community/UpgradeNotes for how to upgrade to
# newer versions of the distribution.
deb http://eu-west-1.ec2.archive.ubuntu.com/ubuntu/ trusty main
deb-src http://eu-west-1.ec2.archive.ubuntu.com/ubuntu/ trusty main

## Major bug fix updates produced after the final release of the
## distribution.
deb http://eu-west-1.ec2.archive.ubuntu.com/ubuntu/ trusty-updates main
deb-src http://eu-west-1.ec2.archive.ubuntu.com/ubuntu/ trusty-updates main

## N.B. software from this repository is ENTIRELY UNSUPPORTED by the Ubuntu
## team. Also, please note that software in universe WILL NOT receive any
## review or updates from the Ubuntu security team.
deb http://eu-west-1.ec2.archive.ubuntu.com/ubuntu/ trusty universe
deb-src http://eu-west-1.ec2.archive.ubuntu.com/ubuntu/ trusty universe
deb http://eu-west-1.ec2.archive.ubuntu.com/ubuntu/ trusty-updates universe
deb-src http://eu-west-1.ec2.archive.ubuntu.com/ubuntu/ trusty-updates universe

## N.B. software from this repository is ENTIRELY UNSUPPORTED by the Ubuntu
## team, and may not be under a free licence. Please satisfy yourself as to
## your rights to use the software. Also, please note that software in
## multiverse WILL NOT receive any review or updates from the Ubuntu
## security team.
deb http://eu-west-1.ec2.archive.ubuntu.com/ubuntu/ trusty multiverse
# deb-src http://eu-west-1.ec2.archive.ubuntu.com/ubuntu/ trusty multiverse
deb http://eu-west-1.ec2.archive.ubuntu.com/ubuntu/ trusty-updates multiverse
# deb-src http://eu-west-1.ec2.archive.ubuntu.com/ubuntu/ trusty-updates multiverse

## Uncomment the following two lines to add software from the 'backports'
## repository.
## N.B. software from this repository may not have been tested as
## extensively as that contained in the main release, although it includes
## newer versions of some applications which may provide useful features.
## Also, please note that software in backports WILL NOT receive any review
## or updates from the Ubuntu security team.
# deb http://eu-west-1.ec2.archive.ubuntu.com/ubuntu/ trusty-backports main restricted universe multiverse
# deb-src http://eu-west-1.ec2.archive.ubuntu.com/ubuntu/ trusty-backports main restricted universe multiverse

## Uncomment the following two lines to add software from Canonical's
## 'partner' repository.
## This software is not part of Ubuntu, but is offered by Canonical and the
## respective vendors as a service to Ubuntu users.
# deb http://archive.canonical.com/ubuntu trusty partner
# deb-src http://archive.canonical.com/ubuntu trusty partner

deb http://security.ubuntu.com/ubuntu trusty-security main
deb-src http://security.ubuntu.com/ubuntu trusty-security main
deb http://security.ubuntu.com/ubuntu trusty-security universe
deb-src http://security.ubuntu.com/ubuntu trusty-security universe
# deb http://security.ubuntu.com/ubuntu trusty-security multiverse
# deb-src http://security.ubuntu.com/ubuntu trusty-security multiverse
EOF

apt-get update
apt-get upgrade -f -y

apt-get install openjdk-7-jre-headless -f -y

# For streamparse
apt-get install python-pip python-dev -f -y
pip install virtualenv

mkdir /etc/storm/
cd /etc/storm/
wget http://ftp.download-by.net/apache/incubator/storm/apache-storm-0.9.2-incubating/apache-storm-0.9.2-incubating.tar.gz
tar xvf apache*
cd apache*
mv * ../
cd ../


cat > /etc/init.d/update_etc_hosts.sh <<EOF
#!/usr/bin/env bash
cat > /etc/hosts <<HOSTSFILE
127.0.0.1 \$HOSTNAME localhost

# The following lines are desirable for IPv6 capable hosts
::1 ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::3 ip6-allhosts
HOSTSFILE

LOCAL_IPV4=\`curl http://169.254.169.254/latest/meta-data/local-ipv4\`
cat > /etc/storm/conf/storm.yaml <<STORM
storm.zookeeper.servers:
    - "$ZOOKEEPER_SERVER"

nimbus.host: "$NIMBUS_HOST"
storm.local.hostname: "\$LOCAL_IPV4"
STORM
EOF

chmod +x /etc/init.d/update_etc_hosts.sh
update-rc.d update_etc_hosts.sh defaults
