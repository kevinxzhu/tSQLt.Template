CREATE PROCEDURE testFinancialApp.[test that Report gets sales data with converted currency]
AS
BEGIN
    IF OBJECT_ID('actual') IS NOT NULL DROP TABLE actual;
    IF OBJECT_ID('expected') IS NOT NULL DROP TABLE expected;


------Fake Table
    EXEC tSQLt.FakeTable 'FinancialApp', 'CurrencyConversion';
    EXEC tSQLt.FakeTable 'FinancialApp', 'Sales';

    INSERT INTO FinancialApp.CurrencyConversion (id, SourceCurrency, DestCurrency, ConversionRate)
                                         VALUES (1, 'EUR', 'USD', 1.6);
    INSERT INTO FinancialApp.CurrencyConversion (id, SourceCurrency, DestCurrency, ConversionRate)
                                         VALUES (2, 'GBP', 'USD', 1.2);

    INSERT INTO FinancialApp.Sales (id, amount, currency, customerId, employeeId, itemId, date)
                                         VALUES (1, '1050.00', 'GBP', 1000, 7, 34, '1/1/2007');
    INSERT INTO FinancialApp.Sales (id, amount, currency, customerId, employeeId, itemId, date)
                                         VALUES (2, '4500.00', 'EUR', 2000, 19, 24, '1/1/2008');

------Execution
    SELECT amount, currency, customerId, employeeId, itemId, date
      INTO actual
      FROM FinancialApp.Report('USD');

------Assertion
    CREATE TABLE expected (
	    amount MONEY,
	    currency CHAR(3),
	    customerId INT,
	    employeeId INT,
	    itemId INT,
	    date DATETIME
    );

	INSERT INTO expected (amount, currency, customerId, employeeId, itemId, date) SELECT 1260.00, 'USD', 1000, 7, 34, '2007-01-01';
	INSERT INTO expected (amount, currency, customerId, employeeId, itemId, date) SELECT 7200.00, 'USD', 2000, 19, 24, '2008-01-01';

	EXEC tSQLt.AssertEqualsTable 'expected', 'actual';
END;