CREATE TABLE [FinancialApp].[CurrencyConversion] (
    [id]                 INT             NOT NULL,
    [sourceCurrency]     CHAR (3)        NOT NULL,
    [destCurrency]       CHAR (3)        NOT NULL,
    [conversionRate]     DECIMAL (10, 4) NOT NULL,
    [effectiveDate]      DATETIME        NULL,
    [lastModifiedUserId] INT             NOT NULL,
    PRIMARY KEY CLUSTERED ([id] ASC),
    FOREIGN KEY ([destCurrency]) REFERENCES [FinancialApp].[Currency] ([currencyCode]),
    FOREIGN KEY ([sourceCurrency]) REFERENCES [FinancialApp].[Currency] ([currencyCode]),
    CONSTRAINT [FK_CurrencyC_lastM] FOREIGN KEY ([lastModifiedUserId]) REFERENCES [FinancialApp].[UserInfo] ([userId])
);


GO
CREATE NONCLUSTERED INDEX [IX_CurrencyConversion_Id]
    ON [FinancialApp].[CurrencyConversion]([id] ASC);

