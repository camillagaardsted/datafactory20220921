--Microsoft SQL Azure (RTM) - 12.0.2000.8   Sep  6 2022 01:25:29   Copyright (C) 2022 Microsoft Corporation 
SELECT @@VERSION

USE serverlessdatabase2

-- vi kan ikke læse fra tabel og view her- vi har kun et sql login
SELECT		*
FROM		ext.raspdata

SELECT		*
FROM		dbo.vAggRaspdata

--sqladmin
select suser_name()


SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'https://datalakesu20220919.dfs.core.windows.net/raspdata/sensor=1984/year=2022/month=09/data2022_09_19_11_48_42.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW = TRUE
    ) AS [result]


CREATE CREDENTIAL [https://datalakesu20220919.dfs.core.windows.net]
WITH IDENTITY='Managed Identity'

select *
from sys.credentials

