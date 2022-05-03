apt install jq docker-compose

```
cd keycloak
sudo docker-compose up -d
sleep 30
./setup
```

```
cd ../nginx
./setup
sudo docker-compose up -d
```

```
cd ../hedgedoc
./setup
sudo docker-compose up -d
```

```
cd ../nextcloud
sudo docker-compose up -d
./setup
```

