CREATE PROCEDURE testFinancialApp.[test that SalesReport calls CurrentReport when @showHistory = 0]
AS
BEGIN
-------Assemble
    EXEC tSQLt.SpyProcedure 'FinancialApp.HistoricalReport';
    EXEC tSQLt.SpyProcedure 'FinancialApp.CurrentReport';

-------Act
    EXEC FinancialApp.SalesReport 'USD', @showHistory = 0;

	DECLARE @txt NVARCHAR(MAX);
	SELECT @txt = (
	SELECT * from FinancialApp.CurrentReport_SpyProcedureLog 
	FOR XML PATH(''),TYPE
	).value('.','NVARCHAR(MAX)');
	PRINT '0000';
	PRINT @txt;
	PRINT '1111';
	
    SELECT currency
      INTO actual
      FROM FinancialApp.CurrentReport_SpyProcedureLog;

-------Assert
    SELECT currency
      INTO expected
      FROM (SELECT 'USD') ex(currency);

    EXEC tSQLt.assertEqualsTable 'actual', 'expected';

    IF EXISTS (SELECT 1 FROM FinancialApp.HistoricalReport_SpyProcedureLog)
       EXEC tSQLt.Fail 'SalesReport should not have called HistoricalReport when @showHistory = 0';
END;