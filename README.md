# AWS DC/OS Installer
## Prerequisites
### Credentials File
Create a credentials file on `~/.aws/credentials.sh` with the content similar to:
```
export AWS_ACCESS_KEY_ID="YOUR_ACCESS_KEY"
export AWS_SECRET_ACCESS_KEY="YOUR_SECRET"
export AWS_DEFAULT_REGION=us-west-2
```

Note: The scripts work only in `AWS_DEFAULT_REGION=us-west-2`

### User Permissions

The user used for the tasks in this README will need following access rights:
- AmazonEC2FullAccess
- AmazonS3FullAccess
- AWSCloudFormationReadOnlyAccess
- CloudFormation (managed)

The rights can be added on the [US West 2 AWS Console](https://console.aws.amazon.com/iam/home?region=us-west-2). The first three access rights can be assigned by searching and attaching the rights to the user. The CloudFormation managed policy is a little more tricky. The process is described in steps 4.2 and 4.3 of [my blog post on DC/OS on AWS](https://oliverveits.wordpress.com/2017/11/21/installing-and-testing-dc-os-on-aws/).

## Configure DC/OS on AWS
Edit the file `config/config.yml`, if needed.
The config.yml defaults to a small installation with one master, one public slave and one private slave with auto-scaling to up to two private slaves. 

## Deploy  DC/OS on AWS:
```
bash entrypoint up
```

## Show Status of deployment:
```
bash entrypoint stack status
```
Repeat this command until you see the status `CREATE_COMPLETE`. If the status does reach this state within ~15 minutes, you will need to troubleshoot the issue on the AWS Console.

## Get Console URL
```
CONSOLE=$(bash entrypoint stack describe | grep dcos-demo-ElasticL | awk -F '"' '{print $4}')
echo $CONSOLE
```

## Open Console URL in Browser
Copy & Paste the printed URL of the previous step in the address bar of your browser. Sign in with your favorite identity provider (Google/Github/Microsoft)

## Install DCOS CLI
Look for the DCOS CLI installation instructions in the drop-down field when clicking the upper left corner of the Web Console. For Linux, copy&paste the instructions on a Linux system. If your are root on a system that does not understand sudo, then the following alias might help:
```
alias sudo="$@"
```

The console is printing following output and is waiting for the token to be pasted:
```
If your browser didn't open, please go to the following link:

    http://<some-cryptic-URL>

Enter OpenID Connect ID Token:
```
We will retrieve the token in the next step.

## Configure DCOS CLI
Log into the Browser using the cryptic URL that has been printed out in the previous step. Log in and copy the presented token to the commandline you have used in the previous step. 

If this step was successful, you will see the following message:
```
Command line utility for the Mesosphere Datacenter Operating
System (DC/OS). The Mesosphere DC/OS is a distributed operating
system built around Apache Mesos. This utility provides tools
for easy management of a DC/OS installation.

Available DC/OS commands:

        auth            Authenticate to DC/OS cluster
        cluster         Manage your DC/OS clusters
        config          Manage the DC/OS configuration file
        experimental    Manage commands that are under development
        help            Display help information about DC/OS
        job             Deploy and manage jobs in DC/OS
        marathon        Deploy and manage applications to DC/OS
        node            View DC/OS node information
        package         Install and manage DC/OS software packages
        service         Manage DC/OS services
        task            Manage DC/OS tasks

Get detailed command description with 'dcos <command> --help'.
```

## Install Marathon Load Balancer
On the Commandline, issue the following command:
```
$ dcos package install marathon-lb
By Deploying, you agree to the Terms and Conditions https://mesosphere.com/catalog-terms-conditions/#community-services
We recommend at least 2 CPUs and 1GiB of RAM for each Marathon-LB instance.

*NOTE*: For additional ```Enterprise Edition``` DC/OS instructions, see https://docs.mesosphere.com/administration/id-and-access-mgt/service-auth/mlb-auth/
Continue installing? [yes/no] yes
Installing Marathon app for package [marathon-lb] version [1.11.2]
Marathon-lb DC/OS Service has been successfully installed!
See https://github.com/mesosphere/marathon-lb for documentation.
```
Type 'yes'<enter> when you are being asked to continue installing.

On the Web Console, you will see, that the Marathon Load Balancer is being deployed.

## Make use of the API
### Create App
Creation of two simple apps with a single call:
```
$ MESOS_MASTER=$(dcos config show core.dcos_url)
$ TOKEN=$(dcos config show core.dcos_acs_token)
$ curl -s -X PUT -k -H "Authorization: token=$TOKEN" -H 'Content-Type: application/json' "$MESOS_MASTER/service/marathon/v2/apps" --data '[{"id":"/test/sleep60","cmd":"sleep 60","cpus":0.3,"instances":2,"mem":9,"dependencies":["/test/sleep120","/other/namespace/or/app"]},{"id":"/test/sleep120","cmd":"sleep 120","cpus":0.3,"instances":2,"mem":9}
{"version":"2018-01-20T17:13:52.420Z","deploymentId":"4f41b278-787d-4644-aded-edc42c87c033"}[root@b99956351c4a /]]'
```
The status of the deployments can be seen with:

```
$ curl -s -X GET -k -H "Authorization: token=$TOKEN" -H 'Content-Type: application/json' "$MESOS_MASTER/service/marathon/v2/deployments/"
[]
```
The deployment is ready already.

Every 60 sec a new deployment is created:
```
MESOS_MASTER=$(dcos config show core.dcos_url)
TOKEN=$(dcos config show core.dcos_acs_token)
while true; 
do 
   json=$(curl -s -X GET -k -H "Authorization: token=$TOKEN" -H 'Content-Type: application/json' "$MESOS_MASTER/service/marathon/v2/deployments/") && 
   echo "$json" && 
   echo "$json" | jq -r 'map(select(any(.affectedApps[]; contains("/test/sleep60")))|.id)[]' | wc -l; sleep 1; 
done
```
This will create the output:
```
[]
0
[]
0
[{"id":"00d2d752-c9f2-4fec-b164-279cb16c7e41","version":"2018-01-20T19:48:40.238Z","affectedApps":["/test/sleep60"],"affectedPods":[],"steps":[{"actions":[{"action":"RestartApplication","app":"/test/sleep60"}]}],"currentActions":[{"action":"RestartApplication","app":"/test/sleep60","readinessCheckResults":[]}],"currentStep":1,"totalSteps":1}]
1
[{"id":"00d2d752-c9f2-4fec-b164-279cb16c7e41","version":"2018-01-20T19:48:40.238Z","affectedApps":["/test/sleep60"],"affectedPods":[],"steps":[{"actions":[{"action":"RestartApplication","app":"/test/sleep60"}]}],"currentActions":[{"action":"RestartApplication","app":"/test/sleep60","readinessCheckResults":[]}],"currentStep":1,"totalSteps":1}]
1
[]
0
```
See tasks:
```
MESOS_MASTER=$(dcos config show core.dcos_url)
TOKEN=$(dcos config show core.dcos_acs_token)
curl -s -k -H "Authorization: token=$TOKEN" -H 'Accept: text/plain' -H 'Content-Type: application/json' "$MESOS_MASTER/service/marathon/v2/tasks"
```
For output in json format, remove the option `-H 'Accept: text/plain'`.

## Remove DC/OS Infrastructure from AWS:
bash entrypoint down

## TODO:
for small AMI's, the variables MasterEbsOptimized and SlaveEbsOptimized must always be false.
- Coupling of instance types and EBS optimization.
  For small instance types, the variables MasterEbsOptimized and SlaveEbsOptimized must always be false, since 
  small instance types do not support EBS optimization. In the moment, we do not verify, whether the configuration 
  is correct, which leads to the CloudFormation Stack to be stuck in CREATE_IN_PROGRESS and a rollback after some time. 

  See [Instance Types That Support EBS Optimization](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSOptimized.html#ebs-optimization-support) to see, which instance types support EBS Optimization
