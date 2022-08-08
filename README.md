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
### Server configuration
#### Install Minukube:
```shell
wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo cp minikube-linux-amd64 /usr/local/bin/minikube
sudo chmod 755 /usr/local/bin/minikube
minikube start --apiserver-ips="`hostname -I | cut -d' ' -f1`,`minikube ip`,10.96.0.1,127.0.0.1,10.0.0.1"
minikube node add
alias kubectl="minikube kubectl -- "
```

#### Setup reverse-proxy:
```shell
apt install nginx
cd /var/www/hello-world
cat ./deploy-level-3/nginx.conf | \
 sed "s/host-ip/$(hostname -I | cut -d' ' -f1)/" \
 sed "s/kube-ip/$(minikube ip)/" \
  > /etc/nginx/nginx.conf
service nginx reload
```

#### Kubernetes Github Actions secret configuration 
```shell
kubectl create namespace php-helloworld
kubectl create secret docker-registry github-container-registry --namespace=php-helloworld --docker-server=ghcr.io --docker-username=$USER --docker-password=$GH_TOKEN
kubectl apply -f ./k8s/clusterrole.yaml 
```

#### Kubernetes secret configuration
```shell
kubectl create serviceaccount github-actions
kubectl create clusterrolebinding continuous-deployment \
--clusterrole=continuous-deployment \
--serviceaccount=default:github-actions
kubectl apply -f ./k8s/github-actions-secret.yaml
# Copy out to github secret KUBERNETES_SECRET
kubectl get secret github-actions-secret -o yaml
```