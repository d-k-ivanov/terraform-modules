#!/usr/bin/env bash

yum update -y

cat >> /etc/ecs/ecs.config << EOF
ECS_CLUSTER=${cluster_name}
ECS_LOGLEVEL=info
ECS_LOGFILE=/var/log/ecs-agent.log
EOF
