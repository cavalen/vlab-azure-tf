as3_uri="https://github.com/F5Networks/f5-appsvcs-extension/releases"
do_uri="https://github.com/F5Networks/f5-declarative-onboarding/releases"
ts_uri="https://github.com/F5Networks/f5-telemetry-streaming/releases"
echo "Latest AS3 Version"
curl -s $as3_uri | grep -o -P "f5-appsvcs-\d.*noarch\.rpm" -m 1 | sed -n 1p | cut -d "-" -f 3
echo "Latest DO Version"
curl -s $do_uri | grep -o -P "f5-declarative-onboarding-\d.*noarch\.rpm" -m 1 | sed -n 1p | cut -d "-" -f 4
echo "Latest TS Version"
curl -s $ts_uri | grep -o -P "f5-telemetry-\d.*noarch.rpm" -m 1 | sed -n 1p | cut -d "-" -f 3
