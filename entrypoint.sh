#!/bin/sh

rm -rf /tmp/.X1-lock

Xvfb :1 -dpi 72 -deferglyphs all -screen scrn 1920x1080x24 > /dev/null 2>&1 &
export DISPLAY=:1

echo "--------------------------------------------------------------------------------------------------------"
echo "Timezone:"
timezone="Europe/Vienna"
if [ -n "$TIMEZONE" ]; then
  timezone=$TIMEZONE
        echo "$TIMEZONE"

else
	    echo "use default timezone: $TIMEZONE"
fi

ln -sf "/usr/share/zoneinfo/$TIMEZONE"  /etc/localtime

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

speedtestversion="$(speedtest-cli --version)"
echo "${speedtestversion}"
echo ""
echo "--------------------------------------------------------------------------------------------------------"
echo ""

# Print CSV Header
header="$(speedtest-cli --csv-header)"
echo "${header}"

# the to store the data
DATE=`date +%Y-%m`
csvFile="/data/${DATE}.csv"

# create file if it does not exist and add header
if [ ! -f ${csvFile} ]; then
  # echo "create file: " + ${csvFile}
  # add header to .csv file
  echo "${header}" >> $csvFile
fi

# Remove blank lines in csv (fix /plot.py error index out of range)
sed '/^$/d' $csvFile > $csvFile.out 
mv  $csvFile.out $csvFile

# Run every n seconds
# log as CSV
while true
do 
  #speedtest-cli --csv
  output="$(speedtest-cli --timeout 60 --single --secure --no-pre-allocate --csv)"
  # echo "${output}"
  # if there is a cli error, the output is "", so do not append it to the csv
  lengthOfString=${#output}
  # echo "lengthOfString: ${lengthOfString}"

  if [ "$lengthOfString" -gt "1" ]; then 
    # get ISO8601 string from output 
    ISO8601="$(cut -d',' -f4 <<<"$output")"
    # echo "${ISO8601}"
    # local time
    now=`date +%Y-%m-%dT%H:%M:%S`    
    # replace in string
    outputWithLocaltime="${output/${ISO8601}/$now}"
    echo "${outputWithLocaltime}"

    echo "${outputWithLocaltime}" >> $csvFile
    echo "--------------------------------------------------------------------------------------------------------"
    python /plot.py
  fi

  sleep $seconds
done


