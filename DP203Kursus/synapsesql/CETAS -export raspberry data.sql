SELECT      count(*)
            , max(timestamp)
FROM         ext.raspdata


CREATE EXTERNAL FILE FORMAT parquetformat  
WITH (  
		 FORMAT_TYPE = PARQUET 
	)


-- VI vil gemme vores rasp data som parquet i datalaken
-- DVS vi laver en export af data
-- Det kaldes CETAS
-- CREATE EXTERNAL TABLE AS SELECT

CREATE EXTERNAL TABLE dbo.raspdataparquet 
WITH (
        LOCATION = 'parquetdata2',  
        DATA_SOURCE = raspdata_datalakesu20220919_dfs_core_windows_net,
        FILE_FORMAT = parquetformat
)
    AS
SELECT * FROM ext.raspdata	

select *
from sys.external_data_sources




