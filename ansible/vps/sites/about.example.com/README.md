# individual website

To bring up an individual website at a specific subdomain:

- The main Docker Compose stack containing Traefik must already be up
- Copy this entire example directory and name it how you like
- Edit the `docker-compose.yml` to suit your needs (especially the domain name)
- Edit `nginx.conf` if needed for your use case.
- Put some files in the webroot directory `html`
- Bring the docker-compose stack up with `docker-compose up -d` (and `docker-compose down` to bring it back down)

To automatically SCP all the these files to your remote, use a modified version of this command:

```shell
REMOTE_USER=ubuntu
REMOTE_HOST="admin.example.com"
WEBSITE_NAME="about.example.com"
TARGET_ROOT_DIRECTORY="/home/ubuntu/docker-services/sites"
ssh $REMOTE_USER@$REMOTE_HOST "mkdir -p $TARGET_ROOT_DIRECTORY/$WEBSITE_NAME/ && exit"
rsync -avz --progress --exclude=".*" ./* $REMOTE_USER@$REMOTE_HOST:$TARGET_ROOT_DIRECTORY/$WEBSITE_NAME/
```
