

#docker run -v $(pwd):/data vikingco/jinja2cli CloudFormationTemplate.j2 config.small.yml > CloudFormationTemplate
docker run -v $(pwd):/data vikingco/jinja2cli ${TEMPLATE_DIR}/CloudFormationTemplate.j2 ${CONFIG_DIR}/${CONFIG_FILE} > CloudFormationTemplate
