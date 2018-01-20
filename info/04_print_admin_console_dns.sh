

sh ${SHARED_DIR}/stack.sh describe | grep dcos-demo-ElasticL | awk -F '"' '{print $4}'
