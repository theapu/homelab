#!/bin/bash
dhtcount=$(/bin/bash /opt/healthcheck/qbc/bin/qbc -l <qbittorrent webui admin username> -p <qbittorrent webui admin user password> http://localhost:8080 -c "qbnetwork"|/opt/healthcheck/qbc/bin/jq -r '(.dht_nodes // 0)')
echo "DHT: $dhtcount"
if [ "$dhtcount" == "0" ] || [ -z "$dhtcount" ]
then
false
else
true
fi
