#!/bin/bash
dhtcount=$(/bin/bash /opt/healthcheck/qbc/bin/qbc -l admin -p vm757aTd http://localhost:58080 -c "qbnetwork"|/opt/healthcheck/qbc/bin/jq -r '(.dht_nodes // 0)')
connectionstatus=$(/bin/bash /opt/healthcheck/qbc/bin/qbc -l admin -p vm757aTd http://localhost:58080 -c "qbnetwork"|/opt/healthcheck/qbc/bin/jq -r '(.connection_status // 0)')
#activetorrentcheck=$(/bin/bash /opt/healthcheck/qbc/bin/qbc -l admin -p vm757aTd http://localhost:58080 -c "qbselect 0"|grep "hash=null"|wc -l)
echo "DHT: $dhtcount, Connection Status: $connectionstatus."
if [ "$dhtcount" == "0" ] || [ -z "$dhtcount" ]
then
false
else
#if [ "$connectionstatus" != "connected" ] || [ -z "$connectionstatus" ]
#then
#false
#else
activetorrentcheck=$(/bin/bash /opt/healthcheck/qbc/bin/qbc -l admin -p vm757aTd http://localhost:58080 -c "qblist"|grep "state:downloading\|state:stalledDL"|sed -E 's/\"([0-9]+)\.(.*)\"/\1/g'|wc -l)
if [ "$activetorrentcheck" != "0" ]
then
#connectedtrackers=$(/bin/bash /opt/healthcheck/qbc/bin/qbc -l admin -p vm757aTd http://localhost:58080 -c "qbselect 0;qbtortrack"|grep "udp\|http"|grep "Working"|wc -l)
connectedtrackers=$(/bin/bash /opt/healthcheck/qbc/bin/qbc -l admin -p vm757aTd http://localhost:58080 -c "qblist"|grep "state:downloading\|state:stalledDL"|sed -E 's/\"([0-9]+)\.(.*)\"/\1/g'|while read i;do /bin/bash /opt/healthcheck/qbc/bin/qbc -l admin -p vm757aTd http://localhost:58080 -c "qbselect $i;qbtortrack"|grep "udp\|http"|grep "Working";done|wc -l)
echo " Active Torrent status: $activetorrentcheck, Connected Trackers: $connectedtrackers."
if [ "$connectedtrackers" == "0" ]
then
false
else
true
fi
else
true
fi
#fi
fi
