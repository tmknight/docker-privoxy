#!/bin/bash
## Assumes routed through NordVPN connection
## API Call
CODE=99
URI=https://nordvpn.com/wp-admin/admin-ajax.php?action=get_user_info_data
TEST=$(curl -fs $URI | jq .status) || CODE=2
if [[ $TEST && $CODE == 99 ]]
then
    CODE=0
else
    CODE=${CODE:-1}
fi
echo "Protected=$TEST"
exit $CODE
