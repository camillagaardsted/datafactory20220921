-- som loader useren!!!
-- load data 
COPY INTO [dbo].[Date]
FROM 'https://nytaxiblob.blob.core.windows.net/2013/Date'
WITH
(
    FILE_TYPE = 'CSV',
	FIELDTERMINATOR = ',',
	FIELDQUOTE = ''
)
OPTION (LABEL = 'COPY DEMO: Load [dbo].[Date] - Taxi dataset');


COPY INTO [dbo].[Geography]
FROM 'https://nytaxiblob.blob.core.windows.net/2013/Geography'
WITH
(
    FILE_TYPE = 'CSV',
	FIELDTERMINATOR = ',',
	FIELDQUOTE = ''
)
OPTION (LABEL = 'COPY DEMO: Load [dbo].[Geography] - Taxi dataset');

COPY INTO [dbo].[HackneyLicense]
FROM 'https://nytaxiblob.blob.core.windows.net/2013/HackneyLicense'
WITH
(
    FILE_TYPE = 'CSV',
	FIELDTERMINATOR = ',',
	FIELDQUOTE = ''
)
OPTION (LABEL = 'COPY DEMO: Load [dbo].[HackneyLicense] - Taxi dataset');

COPY INTO [dbo].[Medallion]
FROM 'https://nytaxiblob.blob.core.windows.net/2013/Medallion'
WITH
(
    FILE_TYPE = 'CSV',
	FIELDTERMINATOR = ',',
	FIELDQUOTE = ''
)
OPTION (LABEL = 'COPY DEMO: Load [dbo].[Medallion] - Taxi dataset');

COPY INTO [dbo].[Time]
FROM 'https://nytaxiblob.blob.core.windows.net/2013/Time'
WITH
(
    FILE_TYPE = 'CSV',
	FIELDTERMINATOR = ',',
	FIELDQUOTE = ''
)
OPTION (LABEL = 'COPY DEMO: Load [dbo].[Time] - Taxi dataset');

COPY INTO [dbo].[Weather]
FROM 'https://nytaxiblob.blob.core.windows.net/2013/Weather'
WITH
(
    FILE_TYPE = 'CSV',
	FIELDTERMINATOR = ',',
	FIELDQUOTE = '',
	ROWTERMINATOR='0X0A'
)
OPTION (LABEL = 'COPY DEMO: Load [dbo].[Weather] - Taxi dataset');

COPY INTO [dbo].[Trip]
FROM 'https://nytaxiblob.blob.core.windows.net/2013/Trip2013'
WITH
(
    FILE_TYPE = 'CSV',
	FIELDTERMINATOR = '|',
	FIELDQUOTE = '',
	ROWTERMINATOR='0X0A',
	COMPRESSION = 'GZIP'
)
OPTION (LABEL = 'COPY DEMO: Load [dbo].[Trip] - Taxi dataset');


-- hashed!!!!

COPY INTO [dbo].[Trip_hashed]
FROM 'https://nytaxiblob.blob.core.windows.net/2013/Trip2013'
WITH
(
    FILE_TYPE = 'CSV',
	FIELDTERMINATOR = '|',
	FIELDQUOTE = '',
	ROWTERMINATOR='0X0A',
	COMPRESSION = 'GZIP'
)
OPTION (LABEL = 'COPY DEMO: Load [dbo].[Trip_hashed] - Taxi dataset');

-- copy into direkte via CTAS:
select top 10 * from dbo.trip

------------------------------------
-- CTAS -- dvs CREATE TABLE AS SELECT
CREATE TABLE [dbo].[Trip_hashed]
WITH
(
    DISTRIBUTION = HASH(DateID),
    CLUSTERED COLUMNSTORE INDEX
)
AS SELECT * FROM dbo.trip
;




-- hashed table
SELECT  dateid
		,COUNT(*)				AS AntalTure
		, Max(tripdurationseconds)	AS LongestDuration
		, MAX(TripdistanceMiles) AS LongestTrip
FROM dbo.trip_hashed
GROUP BY dateid


-- AAA roundrobin trip tabel
SELECT  dateid
		,COUNT(*)				AS AntalTure
		, Max(tripdurationseconds)	AS LongestDuration
		, MAX(TripdistanceMiles) AS LongestTrip
FROM dbo.trip
GROUP BY dateid


