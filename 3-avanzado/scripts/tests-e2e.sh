#!/bin/bash
set -x
set +e

terraform apply -auto-approve
# curl -I http://$(terraform output -raw public_ip_address)
python tests-e2e.py