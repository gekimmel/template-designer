#!/bin/sh
#
# purpose: 
#   - process file data.txt and read value pairs
#   - process template.txt and replace value placeholders 
#   - generate resultfile
#
# example data.txt:
# TPL_ALERTNAME="McsBackupOperator",TPL_METRICSNAME="mcs-backup-operator-metrics",TPL_ENDPOINT="cr-metrics",TPL_MESSAGE="failure in backup oerator"
# TPL_ALERTNAME="McsHealthOperator",TPL_METRICSNAME="mcs-health-operator-metrics",TPL_ENDPOINT="http-metrics",TPL_MESSAGE="failure in health oerator"
# TPL_ALERTNAME="McsHiveOperator",TPL_METRICSNAME="mcs-hive-operator-metrics",TPL_ENDPOINT="cr-metrics",TPL_MESSAGE="failure in hive oerator"
#
# example template.txt:
#         - alert: TPL_ALERTNAME
#          expr: absent(up{job="TPL_METRICSNAME",endpoint="TPL_ENDPOINT"} == 1)
#          for: 15m
#          annotations:
#            message: TPL_MESSAGE
#

DATAFILE="data.txt"
TEMPLATEFILE="template.txt"
OUTFILE="out.txt"

while getopts ho: opt; do

 case "${opt}" in
     h) echo "usage: $(basename $0) -o <outputfile>"
        echo "purpose: replace items defined in data.txt from contents in template.txt and generate output in new file"
        exit 1
        ;;
     o) OUTFILE="$OPTARG"
        ;;
  esac

done

cat /dev/null >$OUTFILE

while read -r DATALINE; do 

   SEDPARAM=$(echo $DATALINE | awk -F, '{ for(i=1; i<NF; i++) printf "s/%s/g;", $i } END { printf "s/%s/g", $NF }')
   SEDPARAM=${SEDPARAM//\"/}
   SEDPARAM=${SEDPARAM//\=/\/}
   sed "$SEDPARAM" $TEMPLATEFILE >> $OUTFILE

done < $DATAFILE

echo "Output written to file $OUTFILE"
