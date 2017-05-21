USE [DB]
GO
/****** Object:  StoredProcedure [dbo].[GET_COUNTRIES]    Script Date: 21/05/2017 16:02:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author, Fabian Rosales Esquivel>
-- Create date: <Create Date, 14/05/2017>
-- Description:	<Description, Get countries for rest api service>
-- =============================================
--EXEC [dbo].[GET_COUNTRIES] NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
--EXEC [dbo].[GET_COUNTRIES] 'Cos',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
--EXEC [dbo].[GET_COUNTRIES] NULL,NULL,NULL,NULL,'Oceania',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
--EXEC [dbo].[GET_COUNTRIES] NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,3,14
CREATE PROCEDURE [dbo].[GET_COUNTRIES]
	(@pName AS NVARCHAR(200),
	 @pAlpha2Code AS NVARCHAR(20),
	 @pAlpha3Code AS NVARCHAR(20),
	 @pNativeName AS NVARCHAR(200),
	 @pRegion AS NVARCHAR(100),
	 @pSubRegion AS NVARCHAR(200),
	 @pAreaFrom AS BIGINT,
	 @pAreaTo AS BIGINT,
	 @pNumericCode AS INT,
	 @pNativeLanguage AS NVARCHAR(200),
	 @pCurrencyCode AS NVARCHAR(100),
	 @pCurrencyName AS NVARCHAR(150),
	 @pPage AS INT,
	 @pLimit AS INT
	)
AS
BEGIN

SELECT	[name],
		[alpha2Code],
		[alpha3Code],
		[nativeName],
		[region],
		[subRegion],
		[latitude],
		[longitude],
		[area],
		[numericCode],
		[nativeLanguage],
		[currencyCode],
		[currencyName],
		[currencySymbol],
		[flag]
FROM (
    SELECT [name],
			[alpha2Code],
			[alpha3Code],
			[nativeName],
			[region],
			[subRegion],
			[latitude],
			[longitude],
			[area],
			[numericCode],
			[nativeLanguage],
			[currencyCode],
			[currencyName],
			[currencySymbol], 
			[flag],
			--OBTAIN THE ROW NUM FOR SIMULATE OFFSET AND LIMIT
			ROW_NUMBER() OVER (ORDER BY [name]) AS RowNum
    FROM [dbo].[Country]
	WHERE [name] LIKE '%'+COALESCE(@pName, [name])+'%' AND
		[alpha2Code] = COALESCE(@pAlpha2Code,[alpha2Code]) AND
		[alpha3Code] = COALESCE(@pAlpha3Code,[alpha3Code]) AND
		[nativeName] LIKE '%'+COALESCE(@pNativeName, [nativeName])+'%' AND
		[region] LIKE '%'+COALESCE(@pRegion, [region])+'%' AND
		[subRegion] LIKE '%'+COALESCE(@pSubRegion, [subRegion])+'%' AND
		COALESCE([area],0) BETWEEN COALESCE(@pAreaFrom, [area], 0) AND COALESCE(@pAreaTo, [area], 0) AND
		COALESCE([numericCode],0) = COALESCE(@pNumericCode, [numericCode], 0) AND
		[nativeLanguage] = COALESCE(@pNativeLanguage,[nativeLanguage]) AND
		[currencyCode] = COALESCE(@pCurrencyCode,[currencyCode]) AND 
		[currencyName] LIKE '%'+COALESCE(@pCurrencyName, [currencyName])+'%'

) AS CountryLimit
WHERE CountryLimit.RowNum 
--CREATE A OFFSET AND LIMIT SIMULATE
BETWEEN (COALESCE(@pPage,1) - 1) * COALESCE(@pLimit,CountryLimit.RowNum) + 1
AND COALESCE(@pLimit,CountryLimit.RowNum) * COALESCE(@pPage,1)
ORDER BY [name]

END

GO
/****** Object:  Table [dbo].[Country]    Script Date: 21/05/2017 16:02:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Country](
	[name] [nvarchar](200) NULL,
	[alpha2Code] [nvarchar](20) NULL,
	[alpha3Code] [nvarchar](20) NULL,
	[nativeName] [nvarchar](200) NULL,
	[region] [nvarchar](100) NULL,
	[subRegion] [nvarchar](200) NULL,
	[latitude] [nvarchar](200) NULL,
	[longitude] [nvarchar](200) NULL,
	[area] [bigint] NULL,
	[numericCode] [int] NULL,
	[nativeLanguage] [nvarchar](200) NULL,
	[currencyCode] [nvarchar](100) NULL,
	[currencyName] [nvarchar](150) NULL,
	[currencySymbol] [nvarchar](50) NULL,
	[flag] [nvarchar](500) NULL
) ON [PRIMARY]

GO
