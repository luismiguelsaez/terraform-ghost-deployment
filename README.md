
## Comments

### Networking

- Simple configuration with VPC and only one AZ

### Instance

- Using EBS instance, so information is not lost if it is destroyed
- For this exercise, we are using `aws_ami` resource to get the latest version, but it's better to specify it as part of the instance code, so it isn't recreated every time there is a new version available
- We are adding local SSH public key for testing purposes
- Created SSH key from Terraform. Although this is not secure and should be stored in some service like Vault, it works for this exercise
- To connect to the instance, we would need to get the SSH private key and IP from outputs
  ```bash
  terraform output ssh_private_key | sed 's/^.*EOT.*//g' > key 
  chmod 0600 key
  INSTANCE_IP=$(terraform output public_ip | sed 's/"//g')
  ssh -i key ubuntu@${INSTANCE_IP}
  ```

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

- We would need to configure the following variables in Github Actions to be able to execute the code

  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`
  - `AWS_DEFAULT_REGION` ( this is not needed, as we configured the region in the code )

- New content for Ghost server could be uploaded to the server after `main` branch push/merge events from Github Actions pipeline, if we store it as part of the repo

- Get SSH private key
  ```bash
  terraform output ssh_private_key | sed 's/^.*EOT.*//g'
  ```

- Setup CICD pipeline variables we would need to configure to use [rsync action](https://github.com/marketplace/actions/action-rsync)

  - `AWS_HOST_IP`
  - `AWS_SSH_PRIVKEY`

- Both pipelines have been defined in `.github/workflows`
