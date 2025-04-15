cluster_name="prodxcloud-cluster-dev"
UUID="0d22999b-xxxx"

curl -sL https://github.com/UpCloudLtd/upcloud-cli/releases/latest/download/upctl-linux-amd64 -o upctl

chmod +x upctl

# (Optional) Move upctl to /usr/local/bin/
# sudo mv upctl /usr/local/bin/
upctl --version
# Login to UpCloud
export UPCLOUD_USERNAME="prodxcloud"
export UPCLOUD_PASSWORD=""
# upctl account login --username prodxcloud --password M4P3c8OldA35yQ.atlasv1
upctl kubernetes config 0de3f068-f987-4df6-b15a-c0f667b239aa --write prodxcloud-cluster-dev_kubeconfig.yaml
# export KUBECONFIG=$(pwd)/prodxcloud-cluster-dev_kubeconfig.yaml
export KUBECONFIG=$(pwd)/prodxcloud-cluster-dev_kubeconfig.yaml
export KUBECONFIG=prodxcloud-cluster-dev_kubeconfig.yaml

./upctl cluster create $cluster_name --zone fi-hel1 --plan 1xCPU-1GB --storage 10GB --labels $cluster_name


kubectl get nodes
kubectl get pods -A



kubectl create secret docker-registry dockerhub-secret \
  --docker-server=https://index.docker.io/v1/ \
  --docker-username=joelwembo \
  --docker-password=dckr_pat_CHaIgJjstRjvowOLe1P9P7Nxnv8 \
  --docker-email=joelotepawembo@gmail.com \
  -n default