-- OLTP
USe AdventureWorks2017

SELECT		*
FROM		sales.customer

USE AdventureWorksDW2017

CREATE VIEW dbo.vProduct
AS 
SELECT			P.*
				, SP.EnglishProductSubcategoryName
				, PC.EnglishProductCategoryName
FROM			dbo.DimProduct P
				INNER JOIN dbo.DimProductSubcategory SP ON SP.ProductSubcategoryKey=P.ProductSubcategoryKey
				INNER JOIN dbo.DimProductCategory PC ON SP.ProductCategoryKey=PC.ProductCategoryKey


SELECT		*
FROM		dbo.vProduct


SELECT		*
FROM		dbo.DimProductCategory


-- https://storageaccountsu20220919.blob.core.windows.net/data/mandag/dag1.sql

-- adgang til Azure storage account
-- via Account keys (pas på - det er admin adgang)
-- via SAS 
-- ?sv=2021-06-08&ss=b&srt=sco&sp=rwdlacyx&se=2023-09-19T17:42:08Z&st=2022-09-19T09:42:08Z&spr=https&sig=a4wBCtfIoJnRZelv%2F6qFWi6cyu3WL5%2BvjyypblLpN5M%3D

--https://www.azurespeed.com/Azure/Latency

----------------- DAG 2
USE AdventureWorks2017

USE master
GO
CREATE SCHEMA test;

----------------------------------------------------------------------------------

-- Fra SSI (statens serum Institut)
-- https://covid19.ssi.dk/overvagningsdata/download-fil-med-overvaagningdata

--https://files.ssi.dk/covid19/overvagning/data/overvaagningsdata-covid19-20092022-f3h3

-- format se https://learn.microsoft.com/en-us/dotnet/standard/base-types/custom-numeric-format-strings


-- link til microsoft learn
-- https://learn.microsoft.com/en-us/certifications/exams/dp-203

-- parse i dataflow
-- se https://learn.microsoft.com/en-us/azure/data-factory/data-flow-parse



https://api.powerbi.com/beta/f28e8f25-3766-4ca8-a1ee-c085311bc52a/datasets/82f47e74-ab83-4500-8a2c-840534f9f49f/rows?redirectedFromSignup=1&key=qVGyiEsJI4vElhq%2B2gMXQvj0ML%2BFDSGerk4WczYUtCdjiT7V%2FD7TjsZN81ZgdonAnCJMbh9XnqDWUallPWp2bw%3D%3D
https://api.powerbi.com/beta/f28e8f25-3766-4ca8-a1ee-c085311bc52a/datasets/82f47e74-ab83-4500-8a2c-840534f9f49f/rows?redirectedFromSignup=1&key=qVGyiEsJI4vElhq%2B2gMXQvj0ML%2BFDSGerk4WczYUtCdjiT7V%2FD7TjsZN81ZgdonAnCJMbh9XnqDWUallPWp2bw%3D%3D



SELECT
    System.Timestamp()       As WindowEnd        
    ,topic
    , COUNT(*)      AS Antal
    , AVG(SentimentScore)       AS AvgScore
INTO powerbioutput    
FROM
    twitterinput TIMESTAMP BY CreatedAt    
GROUP BY topic, tumblingwindow(second,30)     


-- noSQL SQL
-- SELECT b.firstName FROM  b  in c.children
-- SELECT c.parents[1] from c

-- til certificering - træning med eksamensspørgsmål:

-- se https://marketplace.measureup.com/login