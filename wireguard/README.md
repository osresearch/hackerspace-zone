# Wireguard proxy setup

This is for a server that is inside of a firewall or behind a NAT gateway
that doesn't have a static IP address.  A cheap $6/month DigitalOcean droplet
can be created that will route *all* internet traffic to the server, allowing
it to change IP.

* On both proxy and the server:

```
sudo apt install wireguard-tools net-tools
wg genkey \
| sudo tee /etc/wireguard/wg0.key \
| wg pubkey \
| sudo tee /etc/wireguard/wg0.pub
sudo chmod -R go-rwx /etc/wireguard
```

* Copy `wireguard/wg0-proxy.conf` to `/etc/wireguard/wg0.conf` on the proxy
* On the **proxy** edit `/etc/wireguard/wg0.conf`:
  * Change `${SERVER_PUBKEY}` to the public key that was output on the server

* Copy `wireguard/wg0-server.conf` to `/etc/wireguard/wg0.conf` on the server.
* On the **server** edit `/etc/wireguard/wg0.conf`:
  * Change `${PROXY_IP}` to the public IP address of the proxy (two places)
  * Change `${PROXY_PUBKEY}` to the public key output on the proxy (two places)
  * Change `${SERVER_GW}` to the gateway address used to reach the internet from the server

* On both machines run `sudo wg-quick up /etc/wireguard/wg0.conf`
