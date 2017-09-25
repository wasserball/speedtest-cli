#!/bin/sh

# seconds
seconds=3600 # every hour --> default value


echo ""
echo "-------------------------------------------------------------------------"
echo ""

# read env
if [ -n "$RUNEVERYNMINUTES" ]; then
    seconds=$RUNEVERYNMINUTES
else
    echo "env 'RUNEVERYNMINUTES' not set --> using default value: $seconds"
fi

echo "intervall set to $seconds seconds"
echo "values are in bits (bit/s)"
echo ""
echo "-------------------------------------------------------------------------"
echo ""

# Print CSV Header
speedtest-cli --csv-header

# Run every n seconds
# log as CSV
while true
do 
    speedtest-cli --csv

    sleep $seconds
done


