CREATE PROCEDURE testFinancialApp.[test that ConvertCurrencyUsingLookup converts using conversion rate in CurrencyConversion table]
AS
BEGIN
    DECLARE @expected MONEY; SET @expected = 3.2;
    DECLARE @actual MONEY;
    DECLARE @amount MONEY; SET @amount = 2.00;
    DECLARE @sourceCurrency CHAR(3); SET @sourceCurrency = 'EUR';
    DECLARE @destCurrency CHAR(3); SET @destCurrency = 'USD';

------Fake Table
    EXEC tSQLt.FakeTable 'FinancialApp', 'CurrencyConversion';

    INSERT INTO FinancialApp.CurrencyConversion (id, SourceCurrency, DestCurrency, ConversionRate)
                                         VALUES (1, @sourceCurrency, @destCurrency, 1.6);
------Execution
    SELECT @actual = amount FROM FinancialApp.ConvertCurrencyUsingLookup(@sourceCurrency, @destCurrency, @amount);

------Assertion
    EXEC tSQLt.AssertEquals @expected, @actual;
END;