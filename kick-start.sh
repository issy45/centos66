#!/bin/sh -x
# PFM-infra init script

# Update Everything move to chef
#yum -y update
#yum -y install kernel-devel-`uname -r`

# disable ipv6. see http://wiki.centos.org/FAQ/CentOS6#head-d47139912868bcb9d754441ecb6a8a10d41781df
# if [ `grep disable_ipv6 /etc/sysctl.conf | wc -l` -ne 2 ]; then
#     cat >> /etc/sysctl.conf << EOM
# net.ipv6.conf.all.disable_ipv6 = 1
# net.ipv6.conf.default.disable_ipv6 = 1
# EOM
# fi
# sysctl -w net.ipv6.conf.all.disable_ipv6=1
# sysctl -w net.ipv6.conf.default.disable_ipv6=1
# sed -i "s/^#AddressFamily any/AddressFamily inet/" /etc/ssh/sshd_config
# sed -i "s/^#ListenAddress 0\.0\.0\.0/ListenAddress 0\.0\.0\.0/" /etc/ssh/sshd_config

# chef & chef-solo install
if [ ! -e /opt/chef/embedded/bin/gem ]; then
    curl -L https://www.opscode.com/chef/install.sh | bash
    /opt/chef/embedded/bin/gem install knife-solo
fi