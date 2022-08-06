# How it Works

Docker builds an image containing the application in src/ and all of its dependencies by using the Dockerfile contained in this repository.

The Dockerfile tells docker to use the [official PHP Docker image](https://hub.docker.com/_/php/) as the parent image.

The PHP image then uses the [official Debian Jessie Docker image](https://hub.docker.com/_/debian/) as its parent image.

Debian then uses the [scratch image](https://hub.docker.com/_/scratch/) as its base image.

At this point, an image has been built which contains Apache, PHP and all of the OS dependencies and libraries required to serve a webpage written in PHP.

Finally, docker copies everything in src/ inside this repository to the /var/www/html folder inside the image. This is the Apache web root directory.

# Setup

 - Ensure you have Docker installed
 - `git clone` this repository
 - `sudo docker build -t docker-php-helloworld .` 
 - `sudo docker run -p 80:80 docker-php-helloworld`

# What You Should See

![Docker PHP App](https://image.ibb.co/cTxSf7/whale.png "Hello World")

This was originally created to test Amazon Elastic Container Service which is why Moby Dock says "Hello ECS!"

# CI/CD via Github Actions

## Level 1:
HOST: your host name
USERNAME: host username for ssh
SSH_PRIV_KEY:
```shell
ssh-keygen -t ed25519 -a 200 -N "" -f ./vars/key
cat ./vars/key.pub | ssh root@$HOST 'cat >> /home/$USERNAME/.ssh/authorized_keys'
SSH_PRIV_KEY=`cat ./vars/key`
```

## Level 2:
```shell
ssh $USER@$HOST
sudo apt update
sudo apt install docker
usermod -a -G docker $USER

```

## Level 3:
```shell
wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo cp minikube-linux-amd64 /usr/local/bin/minikube
sudo chmod 755 /usr/local/bin/minikube
minikube version
minikube start --apiserver-ips=$KUBE_IPS
minikube node add
alias kubectl="minikube kubectl -- "

$ kubectl create serviceaccount github-actions
serviceaccount/github-actions created
$ kubectl create namespace php-helloworld
namespace/php-helloworld created
$ kubectl create secret docker-registry github-container-registry --namespace=php-helloworld --docker-server=ghcr.io --docker-username=$USER --docker-password=$GH_TOKEN
secret/github-container-registry created

cd /var/www/hello-world
$ kubectl apply -f ./k8s/clusterrole.yaml 
clusterrole.rbac.authorization.k8s.io/continuous-deployment created

kubectl create clusterrolebinding continuous-deployment \
    --clusterrole=continuous-deployment \
    --serviceaccount=default:github-actions
```