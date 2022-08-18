### Architecture
Browser|>|ExternalService|>|MongoExpressPod|>|MongoInternalService|>|MongoDBService
---|---|---|---|---|---|---|---|---
#### DEPLOY the application
```shell
bash deploy.sh
```
#### DESTROY the application
```shell
bash destroy.sh
```
#### Troubleshooting
```shell
# If you face below ERROR
WARNING: MongoDB 5.0+ requires a CPU with AVX support, and your current system does not appear to have that!
# Solution
# ---------
Change mongodb image version to "4.4.6" in mongo.yml file
```