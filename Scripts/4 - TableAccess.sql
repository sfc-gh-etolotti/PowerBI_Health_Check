USE DATABASE PBIHealthCheck;
USE SCHEMA JobData;
USE WAREHOUSE pbi_healthcheck;

INSERT INTO PBIHealthCheck.JobData.POWERBI_TABLE_ACCESS_HISTORY
select
PBI.SESSION_ID,
PBI.QUERY_ID,
value:"objectName"::string as table_view_name,
PBI.WAREHOUSE_NAME
from PBIHealthCheck.JobData.POWERBI_CUSTOMER_HEALTH_CHECKS PBI
join snowflake.account_usage.access_history ah on ah.QUERY_ID=PBI.QUERY_ID,   lateral flatten(BASE_OBJECTS_ACCESSED);



select * from PBIHealthCheck.JobData.POWERBI_TABLE_ACCESS_HISTORY;