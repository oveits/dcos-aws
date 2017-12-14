

source ~/.aws/credentials.sh

# commented out because I do not want to alter the return value:
#RETURN=$?
#[ "$RETURN" == "0" ] || echo "Could not set credentials; exiting"

export TEMPLATE_URL='https://s3.amazonaws.com/my-us-east-1-bucket/CloudFormationTemplate'
export SSH_KEY=AWS_SSH_Key
