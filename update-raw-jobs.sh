#!/bin/bash
set -x

if [ "$#" -ne 2 ]; then
    echo "Error: Missing parameters:"
    echo "  AWS_access_key"
    echo "  AWS_access_secret"
    exit -1
fi

AWS_KEY=$1
AWS_SECRET=$2

aws datapipeline put-pipeline-definition --pipeline-definition file://daap-data-pipeline-raw-cdw-viewership.json \
   --parameter-values myCdwAwsKey=$AWS_KEY \
     myCdwAwsSecret=$AWS_SECRET \
     myShellCmd="sudo yum install -y perl-Switch perl-DateTime perl-Sys-Syslog perl-LWP-Protocol-https\n curl http://aws-cloudwatch.s3.amazonaws.com/downloads/CloudWatchMonitoringScripts-1.2.1.zip -O\n unzip CloudWatchMonitoringScripts-1.2.1.zip \n rm CloudWatchMonitoringScripts-1.2.1.zip \ncp \${INPUT1_STAGING_DIR}/* .\nchmod u+x ./loop.sh\nchmod u+x ./run.sh\nchmod u+x ./aws-s3-uploader\nchmod u+x ./cdwdatagetter\nchmod u+x ./precondition\n(crontab -l ; echo '*/1 * * * * ~/aws-scripts-mon/mon-put-instance-data.pl --mem-util --mem-used --mem-avail --disk-space-util --disk-path=/ --from-cron') | crontab -\n./loop.sh #{myCdwAwsKey} #{myCdwAwsSecret}\ncd aws-scripts-mon\n./mon-put-instance-data.pl --mem-util --mem-used --mem-avail" \
     myS3InputLoc=s3://daap-pipeline/cdw-raw-data/ \
     myS3OutputLoc=s3://daap-pipeline/ \
   --pipeline-id df-0196714TN139WHK7OZQ

aws datapipeline activate-pipeline --pipeline-id df-0196714TN139WHK7OZQ
