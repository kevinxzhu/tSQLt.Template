CREATE PROCEDURE [testFinancialApp].[test that SalesReport calls HistoricalReport instead of CurrentReport when @showHistory = 1]
AS
BEGIN
-------Assemble
    EXEC tSQLt.SpyProcedure 'FinancialApp.HistoricalReport';
    EXEC tSQLt.SpyProcedure 'FinancialApp.CurrentReport';

-------Act
    EXEC FinancialApp.SalesReport 'USD', @showHistory = 1;

	DECLARE @txt NVARCHAR(MAX);
	SELECT @txt = (
	SELECT * from FinancialApp.HistoricalReport_SpyProcedureLog 
	FOR XML PATH(''),TYPE
	).value('.','NVARCHAR(MAX)');
	PRINT @txt;

    SELECT currency
      INTO [actual]
      FROM FinancialApp.HistoricalReport_SpyProcedureLog;

-------Assert HistoricalReport got called with right parameter
    SELECT currency
      INTO [expected]
      FROM (SELECT 'USD') ex(currency);

    EXEC tSQLt.AssertEqualsTable 'expected', 'actual';
    
-------Assert CurrentReport did not get called
    IF EXISTS (SELECT 1 FROM FinancialApp.CurrentReport_SpyProcedureLog)
       EXEC tSQLt.Fail 'SalesReport should not have called CurrentReport when @showHistory = 1';
END;