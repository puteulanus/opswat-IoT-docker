# opswat-IoT-docker
Run opswat IoT client in docker

Start opswat 
```
docker run -d --name opswat_client puteulanus/opswat_client <registration_code>
```

Get client information
```
docker exec -it opswat_client jq -r '.' gears.json
```

Get device_id
```
docker exec -it opswat_client jq -r '.device_id' gears.json
```
