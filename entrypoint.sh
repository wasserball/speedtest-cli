#!/bin/sh

rm -rf /tmp/.X1-lock

Xvfb :1 -dpi 72 -deferglyphs all -screen scrn 1920x1080x24 > /dev/null 2>&1 &
export DISPLAY=:1

echo "--------------------------------------------------------------------------------------------------------"
echo "Timezone:"
timezone="Europe/Vienna"
if [ -n "$TIMEZONE" ]; then
  timezone=$TIMEZONE
else
	    echo "use default timezone: $timezone"
fi
echo "$timezone" > /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata

echo ""
echo "------------------------------------- `date` -------------------------------------"
echo ""

# seconds
seconds=3600 # every hour --> default value

# read interval env
if [ -n "$RUNEVERYNMINUTES" ]; then
  seconds=$RUNEVERYNMINUTES
else
  echo "env 'RUNEVERYNMINUTES' not set --> using default value: $seconds"
fi

echo "intervall set to $seconds seconds"
echo "values are in bits (bit/s)"
echo ""
echo "--------------------------------------------------------------------------------------------------------"
echo ""

# Print CSV Header
header="$(speedtest-cli --csv-header)"
echo "${header}"

# the to store the data
csvFile="/data/output.csv"

# Remove blank lines in csv (fix /plot.py error index out of range)
sed '/^$/d' $csvFile > $csvFile.out 
mv  $csvFile.out $csvFile

# add header to .csv file
numberOfLines=$(cat $csvFile | wc -l)
if [ "$numberOfLines" -eq "0" ]; then
  #echo "$numberOfLines"
  echo "${header}" >> /data/output.csv
fi

# Run every n seconds
# log as CSV
while true
do 
  #speedtest-cli --csv
  output="$(speedtest-cli --csv)"
  echo "${output}"
  # if there is a cli error, the output is "", so do not append it to the csv
  lengthOfString=${#output}
  # echo "lengthOfString: ${lengthOfString}"

  if [ "$lengthOfString" -gt "1" ]; then   
    echo "${output}" >> $csvFile
    echo "--------------------------------------------------------------------------------------------------------"
    echo "update plot"
    python /plot.py
    echo "done :-)"
  fi

  sleep $seconds
done


