# opswat-IoT-docker
Run opswat IoT client in docker

### Start opswat 
```
docker run -d --name opswat_client puteulanus/opswat_client <registration_code>
```

### Start with specified MAC address
```
docker run -d --name opswat_client \
  --mac-address 00:11:22:33:44:55 \
  puteulanus/opswat_client <registration_code>
```
opswat use MAC address to generate device_id, but docker create container with MAC address by uniform rule.

Run ```ifconfig | grep ether``` to get a MAC address from your device.

### Get client information
```
docker exec -it opswat_client jq -r '.' gears.json
```

### Get device_id
```
docker exec -it opswat_client jq -r '.device_id' gears.json
```
