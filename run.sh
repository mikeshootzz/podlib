#!/bin/bash
docker compose run --rm --remove-orphans podlib podlib "$@"
