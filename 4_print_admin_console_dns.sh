

sh 3_stack.sh describe | grep dcos-demo-ElasticL | awk -F '"' '{print $4}'
