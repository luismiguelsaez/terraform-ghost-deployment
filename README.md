
## Comments

### Networking

- Simple configuration with VPC and only one AZ

### Instance

- Using EBS instance, so information is not lost if it is destroyed
- For this exercise, we are using `aws_ami` resource to get the latest version, but it's better to specify it as part of the instance code, so it isn't recreated every time there is a new version available
- We are adding local SSH public key for testing purposes

### Bootstrap

- As the exercise requires Ubuntu as OS, we are following the official guide from [Ghost website](https://ghost.org/docs/install/docker/)
- For simplicity, we are using Docker image to run Ghost server
- Testing how it works with `docker` command
  ```bash
  docker run --name ghost_server -d -p 80:2368 -v /data/ghost/content:/var/lib/ghost/content -e url=http://54.75.7.80 ghost:5.2.3
  ```

### Networking

- We don't have any `Route53` zone available, so we use IP to access the server
- Added `url` env var to the container, so we can use IP to navigate in the application

### CICD

- New code will be uploaded to the server after `main` branch push/merge events from Github Actions pipeline
