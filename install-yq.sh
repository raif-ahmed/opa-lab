VERSION=v4.22.1
curl https://github.com/mikefarah/yq/releases/download/${VERSION}/yq_linux_amd64   --location   --output ~/yq 
chmod +x ~/yq
sudo mv ~/yq /usr/local/bin