#!/bin/sh

export TEMPLATE_URL='https://s3.amazonaws.com/my-us-west-2-bucket/CloudFormationTemplate'
#SSH_KEY=dcos-demo-key
export SSH_KEY=AWS_SSH_Key

bash stack.sh down 
