mkdir -p /config/cloud
mkdir -p /var/log/cloud/azure
curl https://raw.githubusercontent.com/cavalen/vlab-azure-tf/master/files/runtime-init-conf.yaml -o /config/cloud/runtime-init-conf.yaml
curl https://cdn.f5.com/product/cloudsolutions/f5-bigip-runtime-init/v1.1.0/dist/f5-bigip-runtime-init-1.1.0-1.gz.run -o /tmp/f5-bigip-runtime-init-1.1.0-1.gz.run && bash /tmp/f5-bigip-runtime-init-1.1.0-1.gz.run -- '--cloud azure'
f5-bigip-runtime-init --config-file /config/cloud/runtime-init-conf.yaml
