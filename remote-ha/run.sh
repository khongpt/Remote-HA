#!/usr/bin/env bashio
WAIT_PIDS=()
CONFIG_PATH='/share/frpc.toml'
DEFAULT_CONFIG_PATH='/frpc.toml'

function stop_frpc() {
    bashio::log.info "Shutdown frpc client"
    kill -15 "${WAIT_PIDS[@]}"
}
serverip="ws3.airplaycar.com"
port_number="8123"		
key=`cat /etc/hostname | tr -d '\n'`
lanip=`cat /etc/hostname | tr -d '\n'`		
rid=$(bashio::config 'remoteID')		
rserver=`echo $rid | cut -d '-' -f2 | cut -d '.' -f2`

case "$rserver" in
   "hass") serverip="ws5.airplaycar.com" 
   ;;
   "tinymation") serverip="ws3.airplaycar.com"
   ;;
esac	
		
name=`cat /etc/hostname | tr -d '\n'` 
stat=`curl --max-time 10 -s vu.airplaycar.com/ip.php` 		
ver="haos"
token=`curl --connect-timeout 10 -s -k -G "https://$serverip/api/hass/remoteluci.php" -d "key=$key&lanip=$lanip&hostname=$name&status=$stat&version=$ver&rid=$rid&port=$port_number"`
echo $token > /tmp/rid
cp $DEFAULT_CONFIG_PATH $CONFIG_PATH
uci_server=`/bin/cat /tmp/rid | cut -d ' ' -f1`
uci_time=`/bin/cat /tmp/rid | cut -d ' ' -f2`
uci_key=`/bin/cat /tmp/rid | cut -d ' ' -f3`
uci_subdomain=`/bin/cat /tmp/rid | cut -d ' ' -f4`	
	if [ "$uci_subdomain" != "" ]; then
	subdomain=`echo $uci_subdomain`			
else	
	subdomain=`echo $rid | cut -d '-' -f2 | cut -d '.' -f1`
fi	
uci_mac_lower=`echo $key | sed -r 's/[:]+//g' | awk '{print tolower($0)}'`
sed -i "s/server.tinymation.com/$uci_server/" $CONFIG_PATH
sed -i "s/020007a29b47/$uci_mac_lower/" $CONFIG_PATH
sed -i "s/001c1/$subdomain/" $CONFIG_PATH
sed -i "s/1924905600000/$uci_time/" $CONFIG_PATH
sed -i "s/de101b22-df7f-4671-9fe4-c052a22042e6/$uci_key/" $CONFIG_PATH
#bashio::log.info "Starting tunnel"
#cat $CONFIG_PATH
cd /usr/src
./frpc -c $CONFIG_PATH & WAIT_PIDS+=($!)

#tail -f /share/frpc.log &

trap "stop_frpc" SIGTERM SIGHUP
wait "${WAIT_PIDS[@]}"
