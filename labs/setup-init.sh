#!/bin/bash

exec 2>&1
exec > /tmp/lab-setup.out

source /root/.bashrc


log_error () {
    echo -e "[`date`]\033[31mERROR: $1\033[0m"
}

log_task () {
    echo -e "[`date`]\033[32mTASK: $1\033[0m"
}

log_task "Started Lab setup"


# Build docker image while wqe wait for Artifactory
cd jfrog
docker build -t academy-docker-image .
##

# Wait for Artifactory
while [ true ]
do
    wget http://academy-artifactory  > /dev/null 2>&1
    if [ $? -eq 0 ]
    then   
        break
    fi
done
log_task "Artifactory is responding"

while [ true ]
do
    jf config add  academy --url=http://academy-artifactory --user=admin --password=Admin1234! --interactive=false
    if [ $? -eq 0 ]
    then
        break
    fi
    sleep 20
done
log_task "JF Config executed"

echo '{"rclass": "local",
 "packageType": "docker",
 "key": "academy-docker-local",
 "repoLayoutRef": "simple-default",
 "xrayIndex": "true"
}' > /tmp/d.json
jf rt rc /tmp/d.json 
log_task "Docker Repo created"

## Publish image to Artifactory
# put push in the background so we can continue with the script
HFQDN=`nslookup academy-artifactory|grep academy-artifactory|awk '{print $1}'|grep -v Name`
jf docker login  -uadmin -pAdmin1234! ${HFQDN}
log_task "Docker login"
jf docker tag academy-docker-image ${HFQDN}/academy-docker-local/academy-docker-image
log_task "Docker image created"
jf docker push ${HFQDN}/academy-docker-local/academy-docker-image
log_task "Docker image pushed"

 

log_task "Lab Setup Completed"
