#!/bin/sh

#aws s3 cp template_master\=1_PlublicSlaveInstanceCount\=1_SlaveInstanceCount\=5_SlaveInstanceCountDesired\=2.txt s3://my-us-west-2-bucket/
aws s3 cp CloudFormationTemplate s3://my-us-east-1-bucket/
