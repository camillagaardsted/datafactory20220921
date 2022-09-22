
CREATE DATABASE ServerlessDatabase2

-- vi vil oprette en extern tabel

USE serverlessdatabase2


	CREATE EXTERNAL FILE FORMAT [SynapseDelimitedTextFormat] 
	WITH ( FORMAT_TYPE = DELIMITEDTEXT ,
	       FORMAT_OPTIONS (
			 FIELD_TERMINATOR = ',',
			 USE_TYPE_DEFAULT = FALSE,
			 FIRST_ROW =2
			))
GO



	CREATE EXTERNAL DATA SOURCE [raspdata_datalakesu20220919_dfs_core_windows_net] 
	WITH (
		LOCATION = 'abfss://raspdata@datalakesu20220919.dfs.core.windows.net' 
	)
GO

CREATE EXTERNAL TABLE raspdata (
	[sensorid] bigint,
	[timestamp] datetime2(0),
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
GO


DROP EXTERNAL TABLE raspdata


SELECT 		*
FROM 		dbo.raspdata


CREATE SCHEMA ext

CREATE EXTERNAL TABLE ext.raspdata (
	[sensorid] bigint,
	[timestamp] datetime2(0),
	[temperature_from_humidity] float,
	[temperature_from_pressure] float,
	[humidity] float,
	[pressure] float
	)
	WITH (
	LOCATION = 'sensor=1984/year=2022/month=09/*.csv',
	DATA_SOURCE = [raspdata_datalakesu20220919_dfs_core_windows_net],
	FILE_FORMAT = [SynapseDelimitedTextFormat]
	)
GO

SELECT 		*
FROM 		ext.raspdata
WHERE 		[temperature_from_humidity]>43


SELECT 		count(*)
FROM 		ext.raspdata

CREATE VIEW dbo.vAggRaspdata AS 
	SELECT 		COUNT(*) AS Antal
				,MONTH(timestamp)	AS Month
				,DAY(timestamp)		AS Day
				,DATEPART(hour,timestamp)	AS Hour
	FROM 		ext.raspdata
	GROUP BY 	MONTH(timestamp),DAY(timestamp),DATEPART(hour,timestamp)


SELECT 		*
FROM		dbo.vAggRaspdata

SELECT 		*
FROM 		ext.raspdata