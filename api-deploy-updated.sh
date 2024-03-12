#!/bin/bash
set -x #this enable  makes the script exit immediately if any command in the script exits with a non-zero status along with more verbose mode

CONTAINER_NAME=erp-backend
TAG=`date +%d%m%y`
KEY_FILE=/home/ubuntu/.ssh/aws
#DVCS=git@bitbucket.org:fleeca1/erp-backend.git
DVCS=ssh://git-codecommit.ap-south-1.amazonaws.com/v1/repos/Erp-Backend
IMAGE_NAME=${CONTAINER_NAME}:${TAG}
DEFAULT_BRANCH="develop"

#previous clean up
rm -rf /home/ubuntu/fleeca-docker/Erp-Backend

if [ -z "$1" ]; then
  BRANCH="$DEFAULT_BRANCH"
else
  BRANCH="$1"
fi


pkill -f ssh-agent
eval `ssh-agent -s`
ssh-add ${KEY_FILE}
cd /home/ubuntu/fleeca-docker
git clone ${DVCS} -b ${BRANCH}
git pull origin ${BRANCH}
cp /home/ubuntu/deployment-files/erp-api/Dockerfile /home/ubuntu/fleeca-docker/Erp-Backend/laravel-src-v9
cp -r /home/ubuntu/deployment-files/erp-api/docker /home/ubuntu/fleeca-docker/Erp-Backend/laravel-src-v9/
#cp /home/ubuntu/deployment-files/erp-api/supervisord.conf /home/ubuntu/fleeca-docker/Erp-Backend/laravel-src-v9/
cd /home/ubuntu/fleeca-docker/Erp-Backend/laravel-src-v9
docker cp ${CONTAINER_NAME}:/var/www/html/.env .

#docker deployment start from here
echo "deployment start in container"
sudo docker build --no-cache=true -t ${IMAGE_NAME} .
#rm -rf /home/ubuntu/fleeca-docker/Erp-Backend
sudo docker rm -f ${CONTAINER_NAME}
sudo docker run -itd -p 8081:80 --name ${CONTAINER_NAME} --restart always ${IMAGE_NAME}
sleep 10

if docker inspect ${CONTAINER_NAME} | grep -q '"Status": "running",';
then
    echo "\e[32mDeployment is successfull\e[0m"
	timeout 60s docker logs -f "$CONTAINER_NAME"
else docker inspect ${CONTAINER_NAME} | grep -q '"Status": "exited",';
    echo -e "\e[31mDeployment is failed\e[0m"
fi
