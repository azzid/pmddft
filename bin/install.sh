#!/usr/bin/bash
bindir="`dirname $0`"
basedir="${bindir%/*}"
case $1 in
  sender)
    dnf -y install epel-release
    dnf -y install inotify-tools udpcast
    sed -i "s#%%BASEDIR%%#$basedir#" ${bindir}/send.sh
    source <(egrep ^[a-z]\+= ${bindir}/send.sh)
    mkdir -p ${sendpath}
    sed "s#%%BINPATH%%#$bindir#" ${basedir}/etc/systemd/system/udp-sender.service > /etc/systemd/system/udp-sender.service
    systemctl enable --now udp-receiver
    ;;
  receiever)
    dnf -y install udpcast
    cp ${basedir}/etc/systemd/system/udp-receiver.service /etc/systemd/system/udp-receiver.service
    sed "s#%%BASEDIR%%#$basedir#" ${basedir}/etc/sysconfig/udp-receiver > /etc/sysconfig/udp-receiver
    source /etc/sysconfig/udp-receiver
    mkdir -p $TRANSDIR
    systemctl enable --now udp-receiver
    ;;
  *)
    echo "USAGE: $0 <sender|receiever>"
    exit 1
esac
