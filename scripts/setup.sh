#!/bin/bash -ex

# Authenticate with AWS CLI locally
~/exec/aws-creds.sh eksctl

# Create Cluster 1 (snowflake cluster)
cat > snowflake-cluster.yaml <<EOF
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

metadata:
  name: snowflake
  region: eu-north-1

nodeGroups:
  - name: ng-1
    instanceType: t3.medium
    desiredCapacity: 1
EOF

cat snowflake-cluster.yaml | eksctl create cluster --config-file -

# Create Cluster 2 (GitOps cluster)
cat > gitops-cluster.yaml <<EOF
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

metadata:
  name: gitops
  region: eu-north-1

nodeGroups:
  - name: ng-1
    instanceType: t3.medium
    desiredCapacity: 1
EOF

cat gitops-cluster.yaml | eksctl create cluster --config-file -

# Setup Flux in Cluster 2
flux bootstrap github --owner=$GITHUB_USER --repository=gitops-energy-usage --path=clusters --private

# Update Deployment name
./name-setter

# Apply changes to Cluster 1
eksctl utils write-kubeconfig --cluster snowflake-cluster --region eu-north-1
kubectl apply -f ../clusters/formatted-deployment.yaml

# Push changes for Cluster 2
git add . && git commit -m "Format date" && git push
