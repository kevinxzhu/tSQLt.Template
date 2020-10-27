CREATE PROCEDURE testFinancialApp.[test that Sales table does not allow invalid currency]
AS
BEGIN
    DECLARE @errorThrown bit; SET @errorThrown = 0;

    EXEC tSQLt.FakeTable 'FinancialApp', 'Sales';
    EXEC tSQLt.ApplyConstraint 'FinancialApp', 'Sales', 'validCurrency';

    BEGIN TRY
        INSERT INTO FinancialApp.Sales (id, currency)
                                VALUES (1, 'XYZ');
    END TRY
    BEGIN CATCH
        SET @errorThrown = 1;
    END CATCH;    

    IF (@errorThrown = 0 OR (EXISTS (SELECT 1 FROM FinancialApp.Sales)))
    BEGIN
        EXEC tSQLt.Fail 'Sales table should not allow invalid currency';
    END;

    IF EXISTS (SELECT 1 FROM FinancialApp.Sales)
        EXEC tSQLt.Fail 'Sales table should not allow invalid currency';
END;