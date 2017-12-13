USE [SygmaODS]
GO
DECLARE @fyperiod1 VARCHAR(6) = '201706'
DECLARE @fyperiod2 VARCHAR(6) = '201709'


SELECT TOP 1000 * FROM [dbo].[getDSOPeriodChange_Concept] (
   @fyperiod1,  @fyperiod2 )
  ORDER BY ConceptName 
GO


