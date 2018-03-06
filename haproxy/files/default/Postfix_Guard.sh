#! /bin/bash -xv

Postfix_ASG=$1
region=$2


echo "Current provided arguments are : $Postfix_ASG , $region ."

source /etc/environment
My_Instance_ID=`/usr/bin/curl --silent http://169.254.169.254/latest/meta-data/instance-id`
declare -i loop
old_asginstances=""
old_mtime=""
while [ . ]; do
asginstances=`aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names ${Postfix_ASG} --region ${region} | grep InstanceId | grep -owP "i-[0-9a-zA-Z]+"`
echo $asginstances
mtime=$(stat -c "%Y" /etc/haproxy/haproxy.cfg)

if [ "$asginstances" != "$old_asginstances" ] || [ "$mtime" != "$old_mtime" ]; then

old_asginstances=$asginstances

loop=0
for i in $asginstances; do
        loop=$(($loop + 1))

        echo "lets check instance $i ."
        instanceIP=`aws ec2 describe-instances --instance-ids ${i} --region ${region} | grep -m 1 PrivateIpAddress | grep -owP "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+"`
        echo "Private IP of Instance : $i is $instanceIP  ."
        sed -i "s/\(^[[:space:]]*\)#*\(server postfix$loop\).*/\1\2 $instanceIP:25/" /etc/haproxy/haproxy.cfg

done
service haproxy reload

mtime=$(stat -c "%Y" /etc/haproxy/haproxy.cfg)
old_mtime=$mtime

fi
sleep 10
done
