#ufw route delete allow in on wg0 out on eth0
iptables -D FORWARD -i wg0 -o eth0 -j ACCEPT
iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
ip6tables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
