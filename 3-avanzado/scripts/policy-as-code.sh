#!/bin/bash
set -xe

terraform plan -out terraform.tfplan > /dev/null
python tests-PaC.py