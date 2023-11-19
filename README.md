# docker-mdns-repeater
Allow docker containers in virtual networks to send/receive mdns broadcast messages

Forked from https://github.com/angelnu/docker-mdns_repeater

Docker image: https://hub.docker.com/repository/docker/thib4ut/mdns-repeater/

Original sources from https://bitbucket.org/geekman/mdns-repeater/raw/28ecc2ab9a0e26c73148711c867d9d2b5dafff91/mdns-repeater.c

## Sample docker-compose file:

```yaml
services:
  mdns-repeater:
    image: thib4ut/mdns-repeater
    container_name: "mdns_repeater"
    network_mode: host
    restart: unless-stopped
    environment:
    - hostNIC=${HOSTNICHA} # use 'route -n' and look for server IP - something like enp3s0
    - dockerNIC=${DOCKERNICHA} # use 'route -n' and look for subnet of hass - something like br-1ac0fbbf0c3b
    cap_drop: 
      - ALL
    cap_add: 
      - NET_RAW
      - NET_ADMIN
    security_opt:  
      - no-new-privileges 
    deploy:
      resources:
        limits:
          cpus: '0.50'
          memory: 2G
```

## Sample examples to get environment values: 
```bash
# Setting ENV variables
DOCKERNICHA=$(ip -o route get 172.20.0.0 | perl -nle 'if ( /dev\s+(\S+)/ ) {print $1}')
HOSTNICHA=$(ip route show to match 10.0.3.100 | perl -nle 'if ( /dev\s+(\S+)/ ) {print $1}' | sed -n 1p)
```
