-- Microsoft SQL Azure (RTM) - 12.0.2000.8   Aug 10 2022 15:14:09   Copyright (C) 2022 Microsoft Corporation 
-- vi er altid p� nyeste version
SELECT @@VERSION

SELECT	*
FROM	saleslt.customer

BEGIN TRANSACTION
	UPDATE saleslt.customer
	SET firstname='S�ren'
		, lastname='Pape'
	WHERE customerId =1

SELECT	*
FROM	saleslt.customer

COMMIT TRANSACTION

-- n�r vi skalerer en sql database, s� d�r transaktionen  - den bliver rullet tilbage...
BEGIN TRANSACTION
	UPDATE saleslt.customer
	SET firstname='Mette'
		, lastname='Frederiksen'
	WHERE customerId =1

SELECT	*
FROM	saleslt.customer

--USE statement is not supported to switch between databases
USE Demodb