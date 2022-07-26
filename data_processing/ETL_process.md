# Part 1. Extract data to s3

Create s3 bucket, upload Raw Data of IMBA.

# Part 2. Using Athena to do auditing and ETL 


This step used Athena SQL to auditing data and create a table which represents product features. 

![athena](https://github.com/LeoLee-Xiaohu/IMBA-AWS/blob/aws-v0/imgs/athena.png)



# Part 3. Using AWS Glue Databrew to do ETL 

##### Databrew could complete ETL task by simply clicking in the UI, including creating receipt and jobs. This features could make ETL easily complete by DA or DS. 

In the project of IMBA, following features transformations were completed by Databrew.

## 1. Prd-features

This step outputs product feature table, parquet files, which count product totall orders and caculate the frequency of buying a particular product.

The receipt shows what and how the databrew generate prd-features.
![reciept](https://github.com/LeoLee-Xiaohu/IMBA-AWS/blob/main/imgs/recipe-prd-features.png)

The logic of above receipt is same as the following SQL code. 

``` sql
select 
    product_id,
    Count(*) AS prod_orders,
    Sum(reordered) AS prod_reorders,
    Sum(CASE WHEN product_seq_time = 1 THEN 1 ELSE 0 END) AS prod_first_orders,
    Sum(CASE WHEN product_seq_time = 2 THEN 1 ELSE 0 END) AS prod_second_orders
from 
    (select * , 
        rank() over (partition by user_id , product_id order by order_number ) as product_seq_time 
    from order_products_prior ) a
group by product_id
```

## 2. up_features

product ordered features -- up feature 

The logic of the receipt in this step is same as the following SQL code.

```sql
SELECT user_id, 
    product_id,
    Count(*) AS up_orders,
    Min(order_number) AS up_first_order, 
    Max(order_number) AS up_last_order, 
    Avg(add_to_cart_order) AS up_average_cart_position
FROM order_products_prior GROUP BY user_id,
product_id
``` 

## 3. user_feature_1

The logic of the receipt in this step is same as the following SQL code.

``` sql
SELECT user_id,
    Max(order_number) AS user_orders, 
    Sum(days_since_prior_order) AS user_period, 
    Avg(days_since_prior_order) AS user_mean_days_since_prior
FROM orders GROUP BY user_id
```


## 4. user_feature_2

The recipt steps is slightly different from the process of SQL. Databrew is begining with the CASE WHEN function, then caculate sum by group, then divide. Following figure shown the receipt of this step.
![2](https://github.com/LeoLee-Xiaohu/IMBA-AWS/blob/main/imgs/receipt_user-feature-2.png)
The logic of the receipt in this step is same as the following SQL code.

``` sql
SELECT user_id,
    Count(*) AS user_total_products,
    Count(DISTINCT product_id) AS user_distinct_products ,
    Sum(CASE WHEN reordered = 1 THEN 1 ELSE 0 END) / Cast(Sum(CASE WHEN order_number > 1 THEN 1 ELSE 0 END) AS DOUBLE)AS user_reorder_ratio
FROM order_products_prior GROUP BY user_id
```

# Part 4. Glue Job 

Glue version: 
``` 
Spark 3.1 python3 (glue version 3.0 )
``` 
Glue Job python code is in the same folder named 'data processing'. Please see the file glue_job.py.

The following picture shows a part of the reasult data.
![output](https://github.com/LeoLee-Xiaohu/IMBA-AWS/blob/aws-v0/imgs/reasults.png)