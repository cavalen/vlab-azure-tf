# Check for the latest version of the Automation Toolchain (ATC) components
as3_uri="https://github.com/F5Networks/f5-appsvcs-extension/releases"
do_uri="https://github.com/F5Networks/f5-declarative-onboarding/releases"
ts_uri="https://github.com/F5Networks/f5-telemetry-streaming/releases"

echo ""
echo "Latest AS3 Version"
as3_version=`curl -s $as3_uri | grep -o -P "f5-appsvcs-\d.*noarch\.rpm" -m 1 | sed -n 1p | cut -d "-" -f 3`
echo $as3_version
as3_file=`curl -s $as3_uri | grep -o -P "f5-appsvcs-\d.*noarch\.rpm" -m 1`
echo $as3_file
echo "https://github.com/F5Networks/f5-appsvcs-extension/releases/download/$as3_version/$as3_file"

echo ""
echo "Latest DO Version"
do_version=`curl -s $do_uri | grep -o -P "f5-declarative-onboarding-\d.*noarch\.rpm" -m 1 | sed -n 1p | cut -d "-" -f 4`
echo $do_version
do_file=`curl -s $do_uri | grep -o -P "f5-declarative-onboarding-\d.*noarch\.rpm" -m 1`
echo $do_file
echo "https://github.com/F5Networks/f5-declarative-onboarding/releases/download/$do_version/$do_file"

echo ""
echo "Latest TS Version"
ts_version=`curl -s $ts_uri | grep -o -P "f5-telemetry-\d.*noarch.rpm" -m 1 | sed -n 1p | cut -d "-" -f 3`
echo $ts_version
ts_file=`curl -s $ts_uri | grep -o -P "f5-telemetry-\d.*noarch.rpm" -m 1`
echo $ts_file
echo "https://github.com/F5Networks/f5-telemetry-streaming/releases/download/$ts_version/$ts_file"
echo ""
