#!/usr/bin/bash
# Poor Mans Data-Diode File Transfer
# sender -(>|)- recipient
sendpath='/opt/pmddft/send'
recipient='192.168.1.20'
interface='enp0s8'
throttle='10M'
erasurecoding='16x16/128'

cd ${sendpath}
inotifywait --recursive --event modify --event create ${sendpath}
udp-sender  --interface ${interface} \
            --async \
            --nokbd \
            --max-bitrate ${throttle} \
            --pointopoint \
            --mcast-data-address ${recipient} \
            --fec ${erasurecoding} \
            --autostart 1 \
            --file <(find . -xdev -ignore_readdir_race -type f -print0 | tar --create --gzip --null --files-from=-)
