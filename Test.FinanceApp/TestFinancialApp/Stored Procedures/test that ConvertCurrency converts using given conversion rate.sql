CREATE PROCEDURE testFinancialApp.[test that ConvertCurrency converts using given conversion rate]
AS
BEGIN
    DECLARE @actual MONEY;
    DECLARE @rate DECIMAL(10,4); SET @rate = 1.2;
    DECLARE @amount MONEY; SET @amount = 2.00;

    SELECT @actual = FinancialApp.ConvertCurrency(@rate, @amount);

    DECLARE @expected MONEY; SET @expected = 2.4;   --(rate * amount)
    EXEC tSQLt.AssertEquals @expected, @actual;

END;