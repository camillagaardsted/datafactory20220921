

	CREATE EXTERNAL FILE FORMAT [SynapseDelimitedTextFormat] 
	WITH ( FORMAT_TYPE = DELIMITEDTEXT ,
	       FORMAT_OPTIONS (
			 FIELD_TERMINATOR = ',',
			 USE_TYPE_DEFAULT = FALSE,
			 FIRST_ROW = 2
			))
GO


	CREATE EXTERNAL DATA SOURCE [raspdata_datalakesu20220919_dfs_core_windows_net] 
	WITH (
		LOCATION = 'abfss://raspdata@datalakesu20220919.dfs.core.windows.net', 
		TYPE = HADOOP 
	)
GO

CREATE SCHEMA ext

DROP EXTERNAL TABLE ext.raspdataPolyBase

-- vi laver en lokal tabel
CREATE TABLE dbo.raspdataPolyBase (
	[sensorid] bigint,
	[timestamp] datetime2(0),
	[temperature_from_humidity] float,
	[temperature_from_pressure] float,
	[humidity] float,
	[pressure] float
	)



CREATE EXTERNAL TABLE ext.raspdataPolyBase (
	[sensorid] bigint,
	--[timestamp] datetime2(0),
	[timestamp] VARCHAR(20),
	[temperature_from_humidity] float,
	[temperature_from_pressure] float,
	[humidity] float,
	[pressure] float
	)
	WITH (
	LOCATION = 'sensor=1984/year=2022/month=09/data2022_09_19_11_48_42.csv',
	DATA_SOURCE = [raspdata_datalakesu20220919_dfs_core_windows_net],
	FILE_FORMAT = [SynapseDelimitedTextFormat]
	)
GO -- afslutter et batch


INSERT INTO dbo.raspdataPolyBase
SELECT  [sensorid]	,
	CAST([timestamp] AS DATETIME2(0)),
	[temperature_from_humidity],
	[temperature_from_pressure],
	[humidity],
	[pressure]
FROM   ext.raspdataPolyBase

SELECT  *
FROM     dbo.raspdataPolyBase

select *
from sys.database_principals


