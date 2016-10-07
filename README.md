# Data Pipeline hh-viwership  


You must upload hh-viewership artifacts to daap-pipeline/hh-viewership S3 bucket.
  Use _build-data-pipeline.sh_ under _hh-viewership_ project
You must upload aggregator-viewership artifacts to daap-pipeline/viewership-aggregator S3 bucket.
  Use _build-data-pipeline.sh_ under _viewership-aggregator_ project

## Run this pipeline using the AWS CLI

```sh 
  $> aws datapipeline create-pipeline --name raw_cdw_data_pipeline --unique-id raw_cdw_data_pipeline
  $> aws datapipeline create-pipeline --name viewership_aggrg_data_pipeline --unique-id viewership_aggrg_data_pipeline
```

You receive a pipelineId like this. 
```sh
  #   -----------------------------------------
  #   |             CreatePipeline             |
  #   +-------------+--------------------------+
  #   |  pipelineId |  <Your Pipeline ID>      |
  #   +-------------+--------------------------+
```
pay attention to these values in below command:
myCdwAwsKey=[CDW-AWS-ACCESS-KEY-VALUE] myCdwAwsSecret=[CDW-AWS-SECRET-VALUE]

- HH-VIEWERSHIP --
```sh
  $> aws datapipeline put-pipeline-definition --pipeline-definition file://daap-data-pipeline-raw-cdw-viewership.json --parameter-values myCdwAwsKey=[CDW-AWS-ACCESS-KEY-VALUE] myCdwAwsSecret=[CDW-AWS-SECRET-VALUE] myShellCmd="cp \${INPUT1_STAGING_DIR}/* .\nchmod u+x ./loop.sh\nchmod u+x ./run.sh\nchmod u+x ./aws-s3-uploader\nchmod u+x ./cdwdatagetter\nchmod u+x ./precondition\n./loop.sh #{myCdwAwsKey} #{myCdwAwsSecret}" myS3InputLoc=s3://daap-pipeline/cdw-raw-data/ myS3OutputLoc=s3://daap-pipeline/ --pipeline-id <Your Pipeline ID>

```
  with RAM monitoring:
  ```sh
    $ aws datapipeline put-pipeline-definition --pipeline-definition file://daap-data-pipeline-raw-cdw-viewership.json --parameter-values myCdwAwsKey=[CDW-AWS-ACCESS-KEY-VALUE] myCdwAwsSecret=[CDW-AWS-SECRET-VALUE] myShellCmd="sudo yum install -y perl-Switch perl-DateTime perl-Sys-Syslog perl-LWP-Protocol-https\n curl http://aws-cloudwatch.s3.amazonaws.com/downloads/CloudWatchMonitoringScripts-1.2.1.zip -O\n unzip CloudWatchMonitoringScripts-1.2.1.zip \n rm CloudWatchMonitoringScripts-1.2.1.zip \ncp \${INPUT1_STAGING_DIR}/* .\nchmod u+x ./loop.sh\nchmod u+x ./run.sh\nchmod u+x ./aws-s3-uploader\nchmod u+x ./cdwdatagetter\nchmod u+x ./precondition\n(crontab -l ; echo '*/5 * * * * ~/aws-scripts-mon/mon-put-instance-data.pl --mem-util --mem-used --mem-avail --disk-space-util --disk-path=/ --from-cron') | crontab -\n./loop.sh #{myCdwAwsKey} #{myCdwAwsSecret}\ncd aws-scripts-mon\n./mon-put-instance-data.pl --mem-util --mem-used --mem-avail\n"  myS3InputLoc=s3://daap-pipeline/cdw-raw-data/ myS3OutputLoc=s3://daap-pipeline/ --pipeline-id <Your Pipeline ID> 
  ```

-- VIEVEWERHIP-AGGREGATOR --
--- 2 days:
```
  sh
  $> aws datapipeline put-pipeline-definition --pipeline-definition file://daap-data-pipeline-viewership-aggregator.json --pipeline-id <Your Pipeline ID> 

  $> aws datapipeline put-pipeline-definition --pipeline-definition file://daap-data-pipeline-viewership-aggregator.json --parameter-values myDaysAggregate="2" myShellCmd="cp \${INPUT1_STAGING_DIR}/* .\nchmod u+x ./loop.sh\nchmod u+x ./run.sh\nchmod u+x ./viewership-aggregator\nchmod u+x ./precondition\n./loop.sh 2" myS3InputLoc=s3://daap-pipeline/viewership-aggregator myS3OutputLoc=s3://daap-pipeline/ --pipeline-id <Your Pipeline ID> 
```

with RAM monitoring:
    $ aws datapipeline put-pipeline-definition --pipeline-definition file://daap-data-pipeline-viewership-aggregator.json --parameter-values myDaysAggregate="2" myShellCmd="sudo yum install -y perl-Switch perl-DateTime perl-Sys-Syslog perl-LWP-Protocol-https\ncurl http://aws-cloudwatch.s3.amazonaws.com/downloads/CloudWatchMonitoringScripts-1.2.1.zip -O\nunzip CloudWatchMonitoringScripts-1.2.1.zip\nrm CloudWatchMonitoringScripts-1.2.1.zip\ncp \${INPUT1_STAGING_DIR}/* .\nchmod u+x ./loop.sh\nchmod u+x ./run.sh\nchmod u+x ./viewership-aggregator\nchmod u+x ./precondition\n(crontab -l ; echo '*/5 * * * * ~/aws-scripts-mon/mon-put-instance-data.pl --mem-util --mem-used --mem-avail --disk-space-util --disk-path=/ --from-cron') | crontab -\n./loop.sh #{myDaysAggregate}\ncd aws-scripts-mon\n./mon-put-instance-data.pl --mem-util --mem-used --mem-avail\n" myS3InputLoc=s3://daap-pipeline/viewership-aggregator myS3OutputLoc=s3://daap-pipeline/ --pipeline-id <Your Pipeline ID> 


--- 3 days:
```
  sh
  $> aws datapipeline put-pipeline-definition --pipeline-definition file://daap-data-pipeline-viewership-aggregator.json --pipeline-id <Your Pipeline ID> 

  $> aws datapipeline put-pipeline-definition --pipeline-definition file://daap-data-pipeline-viewership-aggregator.json --parameter-values myDaysAggregate="3" myShellCmd="cp \${INPUT1_STAGING_DIR}/* .\nchmod u+x ./loop.sh\nchmod u+x ./run.sh\nchmod u+x ./viewership-aggregator\nchmod u+x ./precondition\n./loop.sh 3" myS3InputLoc=s3://daap-pipeline/viewership-aggregator myS3OutputLoc=s3://daap-pipeline/ --pipeline-id <Your Pipeline ID> 

with RAM monitoring:
  $ aws datapipeline put-pipeline-definition --pipeline-definition file://daap-data-pipeline-viewership-aggregator.json --parameter-values myDaysAggregate="3" myShellCmd="sudo yum install -y perl-Switch perl-DateTime perl-Sys-Syslog perl-LWP-Protocol-https\ncurl http://aws-cloudwatch.s3.amazonaws.com/downloads/CloudWatchMonitoringScripts-1.2.1.zip -O\nunzip CloudWatchMonitoringScripts-1.2.1.zip\nrm CloudWatchMonitoringScripts-1.2.1.zip\ncp \${INPUT1_STAGING_DIR}/* .\nchmod u+x ./loop.sh\nchmod u+x ./run.sh\nchmod u+x ./viewership-aggregator\nchmod u+x ./precondition\n(crontab -l ; echo '*/5 * * * * ~/aws-scripts-mon/mon-put-instance-data.pl --mem-util --mem-used --mem-avail --disk-space-util --disk-path=/ --from-cron') | crontab -\n./loop.sh #{myDaysAggregate}\ncd aws-scripts-mon\n./mon-put-instance-data.pl --mem-util --mem-used --mem-avail\n" myS3InputLoc=s3://daap-pipeline/viewership-aggregator myS3OutputLoc=s3://daap-pipeline/ --pipeline-id <Your Pipeline ID> 


You receive a validation messages like this
```sh
  #   ----------------------- 
  #   |PutPipelineDefinition|
  #   +-----------+---------+
  #   |  errored  |  False  |
  #   +-----------+---------+
```
Tagging the pipeline:
Raw data:
  $> aws datapipeline add-tags --pipeline-id <Your Pipeline ID> --tags key=name,value=rawdata 

2d/3d:
  $> aws datapipeline add-tags --pipeline-id <Your Pipeline ID> --tags key=name,value=aggregated key=type,value=3d

  $> aws datapipeline add-tags --pipeline-id <Your Pipeline ID> --tags key=name,value=aggregated key=type,value=2d



Now activate the pipeline
```sh
  $> aws datapipeline activate-pipeline --pipeline-id <Your Pipeline ID>
```

Check the status of your pipeline 
```
  >$ aws datapipeline list-runs --pipeline-id <Your Pipeline ID>
```

You will receive status information on the pipeline.  
```sh
  #       Name                                                Scheduled Start      Status
  #       ID                                                  Started              Ended
  #---------------------------------------------------------------------------------------------------
  #   1.  ActivityId_6OGtu                                    2015-07-29T01:06:17  WAITING_ON_DEPENDENCIES
  #       @ActivityId_6OGtu_2015-07-29T01:06:17               2015-07-29T01:06:20
  #
  #   2.  ResourceId_z9RNH                                    2015-07-29T01:06:17  CREATING
  #       @ResourceId_z9RNH_2015-07-29T01:06:17               2015-07-29T01:06:20
  #
  #       @ActivityId_wQhxe_2015-07-29T01:06:17               2015-07-29T01:06:20
```
