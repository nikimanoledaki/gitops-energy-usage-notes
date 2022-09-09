#!/bin/bash -ex

# Create clusters
eksctl create cluster -f snowflake-cluster.yaml
eksctl create cluster -f gitops-cluster.yaml
