# Data processing
The processing was as follows in the figure shown.
<img src=https://github.com/LeoLee-Xiaohu/IMBA-AWS/blob/main/imgs/solution_design_aws2.0.drawio.png width = 80% />

# 1. Extract data to s3

Create s3 bucket, and upload the Raw Data of IMBA.

# 2. Using Glue Crawler to scan the raw data and using Athena to do auditing 

Scan raw data and create catalog. 
Check the data quality of raw data from the aspects of integrity, consistency and accuracy. For example, checking the null value, total number of records, data type, coding format, and so on. 


# 3. Using EventBridge, Lambda, and Glue job to schedule and do ETL 

EventBridge schedule data pipeline, here, run data pipeline per day UTC23:35.
<div align="center">
<img src=https://github.com/LeoLee-Xiaohu/IMBA-AWS/blob/main/imgs/eventbridge_scheduler.png width=20% />
</div>
In the project of IMBA, the following features transformations were completed by Glue Job. Please see GLue Job codes in scripts/glue_job.

## step 1. create features - order_product_prior 

This step outputs table "order_product_prior", parquet files.

## step 2. create 4 features - user features, up features, product features   

This step outputs 4 tables, parquet files.

# 4. Get final CSV data

Glue version: 
``` 
Spark 3.1 python3 (glue version 3.0 )
``` 
Glue Job python code is in the folder named 'scripts'. Please see the file create_results(csv).py.

# 5. Experiment - Check whether run successfully automatically
As we set UTC23:00 to start (you can also set it at 3:00 am in producing environment. Here the time is convenient for experiment observation.), the data pipeline will run automatically, from extracting raw data to transformation to generate the final data. 

After the data was pushed into S3 bucket, the Glue Crawler would scan the raw data folder regularly, such as scanning at 23:00 per day here. 
Then, at UTC23:35, EventBridge triggers lambda and starts to run the pipeline automatically.

From the glue job monitor, we could know when and how the jobs were run.
In the experiment, we can see the first job started at Sydney time 9:35, which is UTC23:35, and the last job ended at Sydney time 10:08.
<div align="center">
<img src=https://github.com/LeoLee-Xiaohu/IMBA-AWS/blob/aws-v3/imgs/jobMonitor.png  />
</div>

We can also see the results data in the s3 bucket was generated successfully.
The following picture shows a part of the result data.
![output](https://github.com/LeoLee-Xiaohu/IMBA-AWS/blob/aws-v0/imgs/reasults.png)

#### See, the automatic big data pipeline can be run successfully day by day. We just need one action -- push raw data into IMBA S3 bucket. Then the data pipeline will finish all ETL works and get clean and valued results data.
