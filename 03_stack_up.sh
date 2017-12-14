#!/bin/sh

# default value for the TEMPLATE_URL:
[ "$TEMPLATE_URL" == "" ] && export TEMPLATE_URL='https://s3.amazonaws.com/my-us-east-1-bucket/CloudFormationTemplate'
#SSH_KEY=dcos-demo-key
export SSH_KEY=AWS_SSH_Key

bash stack.sh up

