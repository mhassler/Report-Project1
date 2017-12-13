USE [SygmaODS]
GO

DECLARE @fyperiod1 VARCHAR(6) = '201706'
DECLARE @fyperiod2 VARCHAR(6) = '201709'

SELECT * FROM [dbo].[getDSOPeriodChange_DC] (
   @fyperiod1, @fyperiod2  )
GO


