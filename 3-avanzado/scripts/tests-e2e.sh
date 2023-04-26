#!/bin/bash
set -x
set +e

terraform apply -auto-approve
# curl -I http://$(terraform output -raw public_ip_address)

sleep 5
terraform refresh

python tests-e2e.py