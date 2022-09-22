-- vi loader data fra raspberry container direkte til dedicated poly - via COPY INTO

CREATE TABLE dbo.raspdata
	(
	 [sensorid] bigint,
	 [timestamp] datetime2(0),
	 [temperature_from_humidity] float,
	 [temperature_from_pressure] float,
	 [humidity] float,
	 [pressure] float
	)
WITH
	(
	DISTRIBUTION = ROUND_ROBIN, -- fordel data jævnt i ca lige store klumper i 60 distributions
	 CLUSTERED COLUMNSTORE INDEX
	 -- HEAP
	)
GO

SELECT * FROM dbo.raspdata

--Uncomment the 4 lines below to create a stored procedure for data pipeline orchestration​
--CREATE PROC bulk_load_raspdata
--AS
--BEGIN
TRUNCATE TABLE dbo.raspdata

-- Nu hælder vi data direkte ind via COPY:
COPY INTO dbo.raspdata
(sensorid 1, timestamp 2, temperature_from_humidity 3, temperature_from_pressure 4, humidity 5, pressure 6)
FROM 
'https://datalakesu20220919.dfs.core.windows.net/raspdata/sensor=1984/year=2022/month=09/*'
WITH
(
	FILE_TYPE = 'CSV'
	,MAXERRORS = 0
	,FIRSTROW = 2
	,ERRORFILE = 'https://datalakesu20220919.dfs.core.windows.net/reportdata/rasperror/'
)
--END
GO

SELECT TOP 100 * FROM dbo.raspdata

--29082
SELECT count(*) FROM dbo.raspdata


GO


-- Polybase teknik til load af data 
-- er bare at vi anvender external tables


-- 



