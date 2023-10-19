# #!/bin/bash
# package_version = "$1" 
# echo "version is from shell script  $package_version"
# yum install python3.11-devel python3.11-pip -y
# pip3.11 install ansible botocore boto3
# cd /tmp
# ansible-pull -U https://github.com/saikiranreddy11/roboshop-ansible-roles-tf.git -e component = catalogue -e version = $package_version  main.yaml

#!/bin/bash
APP_VERSION=$1
echo "app version: $APP_VERSION"
yum install python3.11-devel python3.11-pip -y
pip3.11 install ansible botocore boto3
cd /tmp
ansible-pull -U https://github.com/sivadevopsdaws74s/ansible-roboshop-roles-tf.git -e component=catalogue -e app_version=$APP_VERSION main.yaml