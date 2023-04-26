#!/bin/bash
#set -xe
set -x
set +e

terraform fmt -check -diff

terraform validate

