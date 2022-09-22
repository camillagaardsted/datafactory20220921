

SELECT      * 
FROM        sys.workload_management_workload_groups

SELECT		*
FROM		sys.database_principals



-- master
CREATE LOGIN DataLoadUser_RC70 WITH PASSWORD = 'SuperUsers1234!!';
CREATE USER DataLoadUser_RC70 FOR LOGIN DataLoadUser_RC70;

select *
from	sys.database_principals

-- user p� sqlpool01
CREATE USER DataLoadUser_RC70 FOR LOGIN DataLoadUser_RC70;


EXEC sp_addrolemember 'staticrc70', 'DataLoadUser_RC70';


GRANT INSERT ON SCHEMA::dbo TO DataLoadUser_RC70
GRANT ADMINISTER DATABASE BULK OPERATIONS TO DataLoadUser_RC70





-- pool
CREATE USER DataLoadUser_RC70 FOR LOGIN DataLoadUser_RC70;

DROP TABLE dbo.date
DROP TABLE dbo.Geography
DROP TABLE dbo.HackneyLicense
DROP TABLE dbo.Medallion
DROP TABLE dbo.Time
DROP TABLE dbo.Trip
DROP TABLE dbo.Trip_hashed
DROP TABLE dbo.Weather


CREATE TABLE [dbo].[Date]
(
    [DateID] int NOT NULL,
    [Date] datetime NULL,
    [DateBKey] char(10)  NULL,
    [DayOfMonth] varchar(2)  NULL,
    [DaySuffix] varchar(4)  NULL,
    [DayName] varchar(9)  NULL,
    [DayOfWeek] char(1)  NULL,
    [DayOfWeekInMonth] varchar(2)  NULL,
    [DayOfWeekInYear] varchar(2)  NULL,
    [DayOfQuarter] varchar(3)  NULL,
    [DayOfYear] varchar(3)  NULL,
    [WeekOfMonth] varchar(1)  NULL,
    [WeekOfQuarter] varchar(2)  NULL,
    [WeekOfYear] varchar(2)  NULL,
    [Month] varchar(2)  NULL,
    [MonthName] varchar(9)  NULL,
    [MonthOfQuarter] varchar(2)  NULL,
    [Quarter] char(1)  NULL,
    [QuarterName] varchar(9)  NULL,
    [Year] char(4)  NULL,
    [YearName] char(7)  NULL,
    [MonthYear] char(10)  NULL,
    [MMYYYY] char(6)  NULL,
    [FirstDayOfMonth] date NULL,
    [LastDayOfMonth] date NULL,
    [FirstDayOfQuarter] date NULL,
    [LastDayOfQuarter] date NULL,
    [FirstDayOfYear] date NULL,
    [LastDayOfYear] date NULL,
    [IsHolidayUSA] bit NULL,
    [IsWeekday] bit NULL,
    [HolidayUSA] varchar(50)  NULL
)
WITH
(
    DISTRIBUTION = ROUND_ROBIN,
    CLUSTERED COLUMNSTORE INDEX
);

CREATE TABLE [dbo].[Geography]
(
    [GeographyID] int NOT NULL,
    [ZipCodeBKey] varchar(10)  NOT NULL,
    [County] varchar(50)  NULL,
    [City] varchar(50)  NULL,
    [State] varchar(50)  NULL,
    [Country] varchar(50)  NULL,
    [ZipCode] varchar(50)  NULL
)
WITH
(
    DISTRIBUTION = REPLICATE,  -- betyder  alle noder har en kopi af tabellen
    CLUSTERED COLUMNSTORE INDEX
);

CREATE TABLE [dbo].[HackneyLicense]
(
    [HackneyLicenseID] int NOT NULL,
    [HackneyLicenseBKey] varchar(50)  NOT NULL,
    [HackneyLicenseCode] varchar(50)  NULL
)
WITH
(
    DISTRIBUTION = ROUND_ROBIN,
    CLUSTERED COLUMNSTORE INDEX
);

CREATE TABLE [dbo].[Medallion]
(
    [MedallionID] int NOT NULL,
    [MedallionBKey] varchar(50)  NOT NULL,
    [MedallionCode] varchar(50)  NULL
)
WITH
(
    DISTRIBUTION = ROUND_ROBIN,
    CLUSTERED COLUMNSTORE INDEX
);

CREATE TABLE [dbo].[Time]
(
    [TimeID] int NOT NULL,
    [TimeBKey] varchar(8)  NOT NULL,
    [HourNumber] tinyint NOT NULL,
    [MinuteNumber] tinyint NOT NULL,
    [SecondNumber] tinyint NOT NULL,
    [TimeInSecond] int NOT NULL,
    [HourlyBucket] varchar(15)  NOT NULL,
    [DayTimeBucketGroupKey] int NOT NULL,
    [DayTimeBucket] varchar(100)  NOT NULL
)
WITH
(
    DISTRIBUTION = ROUND_ROBIN,
    CLUSTERED COLUMNSTORE INDEX
);

CREATE TABLE [dbo].[Trip]
(
    [DateID] int NOT NULL,
    [MedallionID] int NOT NULL,
    [HackneyLicenseID] int NOT NULL,
    [PickupTimeID] int NOT NULL,
    [DropoffTimeID] int NOT NULL,
    [PickupGeographyID] int NULL,
    [DropoffGeographyID] int NULL,
    [PickupLatitude] float NULL,
    [PickupLongitude] float NULL,
    [PickupLatLong] varchar(50)  NULL,
    [DropoffLatitude] float NULL,
    [DropoffLongitude] float NULL,
    [DropoffLatLong] varchar(50)  NULL,
    [PassengerCount] int NULL,
    [TripDurationSeconds] int NULL,
    [TripDistanceMiles] float NULL,
    [PaymentType] varchar(50)  NULL,
    [FareAmount] money NULL,
    [SurchargeAmount] money NULL,
    [TaxAmount] money NULL,
    [TipAmount] money NULL,
    [TollsAmount] money NULL,
    [TotalAmount] money NULL
)
WITH
(
    DISTRIBUTION = ROUND_ROBIN,
    CLUSTERED COLUMNSTORE INDEX
);

CREATE TABLE [dbo].[Weather]
(
    [DateID] int NOT NULL,
    [GeographyID] int NOT NULL,
    [PrecipitationInches] float NOT NULL,
    [AvgTemperatureFahrenheit] float NOT NULL
)
WITH
(
    DISTRIBUTION = ROUND_ROBIN,
    CLUSTERED COLUMNSTORE INDEX
);


-- antal trips: 170.261.325
--81.118.912
----- overv�g

SELECT  r.[request_id]                           
,       r.[status]                               
,       r.resource_class                         
,       r.command
,       sum(bytes_processed) AS bytes_processed
,       sum(rows_processed) AS rows_processed
FROM    sys.dm_pdw_exec_requests r
              JOIN sys.dm_pdw_dms_workers w
                     ON r.[request_id] = w.request_id
WHERE [label] = 'COPY DEMO: Load [dbo].[Date] - Taxi dataset' OR
    [label] = 'COPY DEMO: Load [dbo].[Geography] - Taxi dataset' OR
    [label] = 'COPY DEMO: Load [dbo].[HackneyLicense] - Taxi dataset' OR
    [label] = 'COPY DEMO: Load [dbo].[Medallion] - Taxi dataset' OR
    [label] = 'COPY DEMO: Load [dbo].[Time] - Taxi dataset' OR
    [label] = 'COPY DEMO: Load [dbo].[Weather] - Taxi dataset' OR
    [label] = 'COPY DEMO: Load [dbo].[Trip] - Taxi dataset' 
and session_id <> session_id() and type = 'WRITER'
GROUP BY r.[request_id]                           
,       r.[status]                               
,       r.resource_class                         
,       r.command;


DBCC PDW_SHOWSPACEUSED('dbo.weather')


SELECT	TOP 100 *
FROM dbo.trip

drop table [dbo].[Trip_hashed]

CREATE TABLE [dbo].[Trip_hashed]
(
    [DateID] int NOT NULL,
    [MedallionID] int NOT NULL,
    [HackneyLicenseID] int NOT NULL,
    [PickupTimeID] int NOT NULL,
    [DropoffTimeID] int NOT NULL,
    [PickupGeographyID] int NULL,
    [DropoffGeographyID] int NULL,
    [PickupLatitude] float NULL,
    [PickupLongitude] float NULL,
    [PickupLatLong] varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [DropoffLatitude] float NULL,
    [DropoffLongitude] float NULL,
    [DropoffLatLong] varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [PassengerCount] int NULL,
    [TripDurationSeconds] int NULL,
    [TripDistanceMiles] float NULL,
    [PaymentType] varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [FareAmount] money NULL,
    [SurchargeAmount] money NULL,
    [TaxAmount] money NULL,
    [TipAmount] money NULL,
    [TollsAmount] money NULL,
    [TotalAmount] money NULL
)
WITH
(
    DISTRIBUTION = HASH(DateID),
    CLUSTERED COLUMNSTORE INDEX
)
AS SELECT * FROM dbo.trip
;


EXEC sp_addrolemember 'db_datareader', 'DataLoadUser_RC70';
EXEC sp_addrolemember 'db_datawriter', 'DataLoadUser_RC70';
EXEC sp_addrolemember 'db_ddladmin', 'DataLoadUser_RC70';

select count(*) from dbo.trip_hashed



GRANT SELECT ON SCHEMA::dbo to  DataLoadUser_RC70



-- replicate

CREATE TABLE [dbo].[DateREP]
(
    [DateID] int NOT NULL,
    [Date] datetime NULL,
    [DateBKey] char(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [DayOfMonth] varchar(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [DaySuffix] varchar(4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [DayName] varchar(9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [DayOfWeek] char(1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [DayOfWeekInMonth] varchar(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [DayOfWeekInYear] varchar(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [DayOfQuarter] varchar(3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [DayOfYear] varchar(3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [WeekOfMonth] varchar(1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [WeekOfQuarter] varchar(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [WeekOfYear] varchar(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Month] varchar(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [MonthName] varchar(9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [MonthOfQuarter] varchar(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Quarter] char(1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [QuarterName] varchar(9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Year] char(4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [YearName] char(7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [MonthYear] char(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [MMYYYY] char(6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [FirstDayOfMonth] date NULL,
    [LastDayOfMonth] date NULL,
    [FirstDayOfQuarter] date NULL,
    [LastDayOfQuarter] date NULL,
    [FirstDayOfYear] date NULL,
    [LastDayOfYear] date NULL,
    [IsHolidayUSA] bit NULL,
    [IsWeekday] bit NULL,
    [HolidayUSA] varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
WITH
(
    DISTRIBUTION = REPLICATE,
    CLUSTERED COLUMNSTORE INDEX
);



DBCC PDW_SHOWSPACEUSED('dbo.Trip')
DBCC PDW_SHOWSPACEUSED('dbo.Trip_hashed')




SELECT   *
FROM     dbo.covid19data
WHERE    antalsmittede > 1000




