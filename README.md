# template-designer

This is a simple bash script to produce a result file out of a
* template and a
* data file

The template file contains just any text you want to see repeating several times. It includes as well variables you want to replace. 

The data file contains pairs of variable and text definitions you want to replace in the template.

For any line in the data file the result file will contain the entire contents of the template with the variables being replaced.

## Example

Given the input data.txt and template.txt

### data.txt

```
TPL_ALERTNAME="BackupOperator",TPL_METRICSNAME="backup-operator-metrics",TPL_ENDPOINT="cr-metrics",TPL_MESSAGE="failure in backup operator"
TPL_ALERTNAME="HealthOperator",TPL_METRICSNAME="health-operator-metrics",TPL_ENDPOINT="http-metrics",TPL_MESSAGE="failure in health operator"
TPL_ALERTNAME="HiveOperator",TPL_METRICSNAME="hive-operator-metrics",TPL_ENDPOINT="cr-metrics",TPL_MESSAGE="failure in hive operator"
```

### template.txt

```
  - alert: TPL_ALERTNAME
    expr: absent(up{job="TPL_METRICSNAME",endpoint="TPL_ENDPOINT"} == 1)
    for: 15m
    annotations:
      message: TPL_MESSAGE

```

will result in the output file by calling

`./template-designer.sh`

### out.txt

```
  - alert: BackupOperator
    expr: absent(up{job="backup-operator-metrics",endpoint="cr-metrics"} == 1)
    for: 15m
    annotations:
      message: failure in backup operator

  - alert: HealthOperator
    expr: absent(up{job="health-operator-metrics",endpoint="http-metrics"} == 1)
    for: 15m
    annotations:
      message: failure in health operator

  - alert: HiveOperator
    expr: absent(up{job="hive-operator-metrics",endpoint="cr-metrics"} == 1)
    for: 15m
    annotations:
      message: failure in hive operator

```

You may change the filename of the output file by the option -o

`./template-designer.sh -o myfile.txt`
