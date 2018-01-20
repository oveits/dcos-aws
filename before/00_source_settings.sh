
[ -r ~/.aws/credentials.sh ] && source ~/.aws/credentials.sh
if [ "$AWS_ACCESS_KEY_ID" == "" ]; then
   echo "Please specify the AWS_ACCESS_KEY_ID" >&2
   exit 1
fi

if [ "$AWS_SECRET_ACCESS_KEY" == "" ]; then
   echo "Please specify the AWS_SECRET_ACCESS_KEY" >&2
   exit 1
fi

# export AWS_DEFAULT_REGION

[ "$TEMPLATE_URL" == "" ] && export TEMPLATE_URL='https://s3.amazonaws.com/my-us-east-1-bucket/CloudFormationTemplate'
[ "$SSH_KEY" == "" ] && export SSH_KEY=AWS_SSH_Key
[ "$TEMPLATE_DIR" == "" ] && export TEMPLATE_DIR=templates
[ "$CONFIG_DIR" == "" ] && export CONFIG_DIR=config
[ "$SHARED_DIR" == "" ] && export SHARED_DIR=shared
[ "$CONFIG_FILE" == "" ] && export CONFIG_FILE=config.yml || echo "" 
