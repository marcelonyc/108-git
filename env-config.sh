#!/bin/bash

read  -p "Enter JFrog Access Token: " JF_TOKEN

mkdir -p ~/.pip

echo "[global]
index-url = https://admin:${JF_TOKEN}@academy-artifactory/artifactory/api/pypi/pypi-secure/simple
trusted-host = academy-artifactory" > ~/.pip/pip.conf

echo "export JFROG_ACCESS_TOKEN=${JF_TOKEN}" >> ~/.bashrc

jf pip-config --repo-resolve pypi-secure
