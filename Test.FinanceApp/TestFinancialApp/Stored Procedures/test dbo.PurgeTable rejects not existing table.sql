CREATE   PROCEDURE testFinancialApp.[test dbo.PurgeTable rejects not existing table]
AS
BEGIN
  EXEC tSQLt.ExpectException @Message = 'Table dbo.DoesNotExist not found.', @ExpectedSeverity = 16, @ExpectedState = 62, @ExpectedErrorNumber=NULL, @ExpectedMessage=NULL;
  EXEC dbo.PurgeTable @TableName='dbo.DoesNotExist';
END;