# Load all the names of the Axial repos from GitHub and slice/dice results
tmpfile=/tmp/repolist$$.json

trap 'rm $tmpfile' EXIT

curl -su "gltarsa" https://api.github.com/orgs/AxialExchange/repos?type=private > $tmpfile

jq '.[] | "\(.updated_at) \(.name)"' $tmpfile | sed 's/"//g' | sort
jq '.[] | "\(.created_at) \(.name)"' $tmpfile | sed 's/"//g' | sort


