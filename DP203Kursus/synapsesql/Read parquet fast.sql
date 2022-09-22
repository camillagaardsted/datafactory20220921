-- This is auto-generated code
SELECT
    count(*)
FROM
    OPENROWSET(
        BULK 'https://datalakesu20220919.dfs.core.windows.net/raspdata/parquetdata2/**',
        FORMAT = 'PARQUET'
    ) AS [result]
