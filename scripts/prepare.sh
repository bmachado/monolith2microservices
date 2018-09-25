#!/bin/bash
minishift config set memory 8GB
minishift config set cpus 4
minishift config set image-caching true
minishift addon enable admin-user
minishift addon enable anyuid
