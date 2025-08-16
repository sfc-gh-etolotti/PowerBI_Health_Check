USE DATABASE PBIHealthCheck;
USE SCHEMA JobData;
USE WAREHOUSE pbi_healthcheck;

Insert into PBIHealthCheck.JobData.POWERBI_CUSTOMER_HEALTH_CHECKS
SELECT 
  a.start_time
  ,a.end_time
  ,'Power BI'
  ,TO_VARIANT(client_environment)
  ,null --Client
  ,client_application_id
  ,s.session_id
  ,q.query_id
  ,QUERY_TEXT
  ,Execution_status
  ,TOTAL_ELAPSED_TIME
  ,error_code
  ,error_message
  ,role_name
  ,rows_produced
  ,a.user_name
  ,a.warehouse_id
  ,a.warehouse_name
  ,compilation_time
  ,queued_provisioning_time
  ,null --'DUR_WORKER_GROUP_WAIT'
  ,null --'DUR_XP_EXECUTING'
  ,null --'DUR_ABORTING'
  ,bytes_spilled_to_remote_storage
  ,partitions_scanned
  ,partitions_total
  ,bytes_spilled_to_local_storage
  ,null --'Partition_scan_ratio' 
  ,bytes_scanned
  ,percentage_scanned_from_cache
  ,q.query_hash
  ,null --'compilation_ratio'
  ,query_type
  ,q.query_tag
FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ATTRIBUTION_HISTORY a
INNER JOIN SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY q
    on a.query_id = q.query_id
INNER JOIN SNOWFLAKE.ACCOUNT_USAGE.SESSIONS s
   ON q.session_id = s.session_id
WHERE a.start_time >= DATE_TRUNC('MONTH', ADD_MONTHS(CURRENT_DATE,-3))
  AND a.start_time < CURRENT_DATE
  AND (   // modify as needed to search for other client tools connecting to Snowflake
        PARSE_JSON(s.CLIENT_ENVIRONMENT):APPLICATION::string ilike '%Power%BI%' or
        PARSE_JSON(s.CLIENT_ENVIRONMENT):APPLICATION::string ilike '%PBI%' or
        PARSE_JSON(s.CLIENT_ENVIRONMENT):APPLICATION::string ilike '%MashupEngine%' or
        PARSE_JSON(s.CLIENT_ENVIRONMENT):APPLICATION::string ilike '%data gateway%'
    )
GROUP BY ALL;


select * from PBIHealthCheck.JobData.POWERBI_CUSTOMER_HEALTH_CHECKS;