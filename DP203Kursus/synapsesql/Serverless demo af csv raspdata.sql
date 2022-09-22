-- This is auto-generated code
SELECT
    TOP 100 *
FROM
    OPENROWSET(
        BULK 'https://datalakesu20220919.dfs.core.windows.net/raspdata/sensor=1984/year=2022/month=09/data2022_09_19_11_48_42.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW = TRUE
    ) AS [result]


SELECT
    COUNT(*)
    , Max(timestamp)    
    , max(temperature_from_pressure)
FROM
    OPENROWSET(
        BULK 'https://datalakesu20220919.dfs.core.windows.net/raspdata/sensor=1984/year=*/month=*/data*.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW = TRUE
    ) AS [result]



SELECT
    DATEPART(hour,timestamp)   AS Timetal
    ,COUNT(*)                    AS antal
    , Max(timestamp)            AS maxtid
    , max(temperature_from_pressure)    AS maxtemp
FROM
    OPENROWSET(
        BULK 'https://datalakesu20220919.dfs.core.windows.net/raspdata/sensor=1984/year=*/month=*/data*.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW = TRUE
    ) AS [result]
GROUP BY DATEPART(hour,timestamp)



SELECT
    TOP 100    R.filename(),
               R.filepath(),
               R.filepath(1),
               R.filepath(2),
               R.*
FROM
    OPENROWSET(
        BULK 'https://datalakesu20220919.dfs.core.windows.net/raspdata/sensor=1984/year=*/month=09/data*.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW = TRUE
    ) AS R
WHERE R.filepath(1)=2022






