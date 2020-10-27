CREATE   PROCEDURE testFinancialApp.[test that CurrencyConversion table does not allow invalid user id]
AS
BEGIN
    DECLARE @errorThrown bit; SET @errorThrown = 0;

    EXEC tSQLt.FakeTable 'FinancialApp', 'CurrencyConversion';
    EXEC tSQLt.ApplyConstraint 'FinancialApp', 'CurrencyConversion', 'FK_CurrencyC_lastM';

    BEGIN TRY
        INSERT INTO FinancialApp.CurrencyConversion (id, SourceCurrency, DestCurrency, ConversionRate, lastModifiedUserId)
                                         VALUES (1, 'EUR', 'USD', 1.6, 1);
    END TRY
    BEGIN CATCH
        SET @errorThrown = 1;
--		SELECT  
			--ERROR_NUMBER() AS ErrorNumber  
			--,ERROR_SEVERITY() AS ErrorSeverity  
			--,ERROR_STATE() AS ErrorState  
			--,ERROR_PROCEDURE() AS ErrorProcedure  
			--,ERROR_LINE() AS ErrorLine  
			--,ERROR_MESSAGE() AS ErrorMessage;  

    END CATCH;
	
    IF (@errorThrown = 0 OR (EXISTS (SELECT 1 FROM FinancialApp.CurrencyConversion)))
    BEGIN
        EXEC tSQLt.Fail 'CurrencyConversion table should not allow invalid currency';
    END;

    IF EXISTS (SELECT 1 FROM FinancialApp.CurrencyConversion)
        EXEC tSQLt.Fail 'CurrencyConversion table should not allow invalid currency';
	
END;