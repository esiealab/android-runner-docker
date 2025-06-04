#!/bin/bash
set -e

docker-compose -f docker-compose-exp1.yml up
docker-compose -f docker-compose-exp2.yml up