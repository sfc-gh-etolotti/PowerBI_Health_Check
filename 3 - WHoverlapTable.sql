USE DATABASE PBIHealthCheck;
USE SCHEMA JobData;
USE WAREHOUSE pbi_healthcheck;

SHOW WAREHOUSES;

INSERT INTO PBIHealthCheck.JobData.POWERBI_CUSTOMER_WH_OVERLAP

With W as (
SELECT "name", "type", "size", "min_cluster_count", "max_cluster_count", "auto_suspend", "scaling_policy"
FROM table(result_scan(last_query_id()))
)
Select 
Session_ID,
WAREHOUSE_NAME,
null, --Warehouse_size_sort
count(QUERY_ID),
CLIENT, 
CLIENT_ENVIRONMENT,
CLIENT_ENVIRONMENT:APPLICATION::string,
client_app_id, 
TOOL
from PBIHealthCheck.JobData.POWERBI_CUSTOMER_HEALTH_CHECKS PBI
JOIN W on W."name"=PBI.WAREHOUSE_NAME
GROUP BY Session_ID, WAREHOUSE_NAME, CLIENT, CLIENT_ENVIRONMENT, CLIENT_ENVIRONMENT:APPLICATION::string, client_app_id, TOOL
;

select * from PBIHealthCheck.JobData.POWERBI_CUSTOMER_WH_OVERLAP;