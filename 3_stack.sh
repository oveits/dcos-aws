#!/bin/sh

TEMPLATE_URL='https://s3.amazonaws.com/my-us-west-2-bucket/template_master=1_PlublicSlaveInstanceCount=1_SlaveInstanceCount=5_SlaveInstanceCountDesired=2.txt'
#SSH_KEY=dcos-demo-key
SSH_KEY=AWS_SSH_Key

up() {
   aws --region us-west-2 cloudformation create-stack --stack-name dcos-demo \
       --template-url ${TEMPLATE_URL} \
       --parameters ParameterKey=AcceptEULA,ParameterValue="Yes",ParameterKey=KeyName,ParameterValue="AWS_SSH_Key" \
       --capabilities CAPABILITY_IAM
}

down() {
   aws --region us-west-2 cloudformation delete-stack --stack-name dcos-demo
}

status() {
   aws cloudformation describe-stacks --region us-west-2 | awk '/StackName|StackStatus/'
}

describe() {
   aws cloudformation describe-stacks --region us-west-2
}

usage() {
   echo "usage: $0 [up|down|status|describe]"
}

if [ "$#" != 1 ]; then
   usage >&2
   exit 1
fi

case "$1" in
  up)   	up; exit $? ;;
  down)   	down; exit $? ;;
  status)   	status; exit $? ;;
  describe)   	describe; exit $? ;;
  *)   		usage >&2; exit 1 ;;
esac


