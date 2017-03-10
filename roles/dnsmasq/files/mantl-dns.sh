#!/bin/bash
if [ ! -f /etc/resolv.conf.masq ]; then
    mv /etc/resolv.conf /etc/resolv.conf.masq
else
    rm /etc/resolv.conf
    ln -s /etc/resolv.conf.mantl-dns /etc/resolv.conf
fi

# update the installed config search list with resolv.conf values
search=$(grep ^search /etc/resolv.conf.masq | sed -e "s/consul\s//")
sed -i -e "s/\(^search.*$\)/$search/" /etc/resolv.conf.mantl-dns
# link the installed config
ln -s /etc/resolv.conf.mantl-dns /etc/resolv.conf
# turn off PEERDNS on all interfaces
find /etc/sysconfig/network-scripts -name 'ifcfg-*' \
     -exec sed -i 's/PEERDNS=.*/PEERDNS=no/g' {} \;
# turn off NetworkManager's management of DNS - without this, NM will
# overwrite /etc/resolv.conf every time it starts up
sed -i '/^\[main\]$/a dns=none' /etc/NetworkManager/NetworkManager.conf
# restart everything to pick up the new changes
systemctl enable dnsmasq 2>/dev/null
systemctl restart NetworkManager dnsmasq
# start consul again - upgrading NetworkManager turns it off
systemctl start consul