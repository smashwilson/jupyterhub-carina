#!/bin/sh

# Set this to your publicly accessible IP address or DNS name
export DNSNAME=

# Comma-separated list of GitHub usernames to permit access
export JUPYTERHUB_USERS=

# Comma-separated list of GitHub usernames of admins
export JUPYTERHUB_ADMINS=

# Populate these from a GitHub application that you've created.
# https://github.com/settings/applications/new
export GITHUB_CLIENT_ID=
export GITHUB_CLIENT_SECRET=

docker build -t jupyterhub-carina .

docker run --detach \
  --name jupyterhub \
  -p 80:8000 \
  -p 8081:8081 \
  --volumes-from swarm-data:ro \
  -e JUPYTERHUB_USERS=${JUPYTERHUB_USERS} \
  -e JUPYTERHUB_ADMINS=${JUPYTERHUB_ADMINS} \
  -e DOCKER_HOST=https://${DOCKER_HOST#tcp://} \
  -e HUB_IP_CONNECT=${DNSNAME} \
  -e OAUTH_CALLBACK_URL=http://${DNSNAME}/hub/oauth_callback \
  -e GITHUB_CLIENT_ID=${GITHUB_CLIENT_ID} \
  -e GITHUB_CLIENT_SECRET=${GITHUB_CLIENT_SECRET} \
  jupyterhub-carina
