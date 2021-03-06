#!/bin/bash

mkdir -p /config/cloud
cat << 'EOF' > /config/cloud/runtime-init-conf.yaml
---
runtime_parameters:
  - name: VIP
    type: static
    value: ${vipv}
  - name: NODE
    type: static
    value: ${node}
  - name: SELFIP
    type: static
    value: ${selfip}
pre_onboard_enabled:
  - name: provision_rest
    type: inline
    commands:
      - /usr/bin/setdb provision.extramb 500
      - /usr/bin/setdb restjavad.useextramb true
  - name: change_setting
    type: inline
    commands:
      - tmsh modify sys db ui.system.preferences.recordsperscreen value 100
      - tmsh modify sys db ui.advisory.text value "Azure ${prefix}- bigip.example.com"
extension_packages:
    install_operations:
        - extensionType: do
          extensionVersion: 1.20.0
        - extensionType: as3
          extensionVersion: 3.27.0
        - extensionType: ts
          extensionVersion: 1.19.0
extension_services:
    service_operations:
    - extensionType: do
      type: url
      value: https://raw.githubusercontent.com/cavalen/vlab-azure-tf/master/files/do.tmpl.json
    - extensionType: as3
      type: url
      value: https://raw.githubusercontent.com/cavalen/vlab-azure-tf/master/files/as3.tmpl.json     


EOF

curl https://cdn.f5.com/product/cloudsolutions/f5-bigip-runtime-init/v1.2.1/dist/f5-bigip-runtime-init-1.2.1-1.gz.run -o f5-bigip-runtime-init-1.2.1-1.gz.run && bash f5-bigip-runtime-init-1.2.1-1.gz.run -- '--cloud azure'
f5-bigip-runtime-init --config-file /config/cloud/runtime-init-conf.yaml
