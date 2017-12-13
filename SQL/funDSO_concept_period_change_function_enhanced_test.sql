USE [SygmaODS]
GO
/****** Object:  UserDefinedFunction [dbo].[getDSOPeriodChange_Concept_CTE]    Script Date: 4/17/2017 3:21:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[getDSOPeriodChange_Concept_CTE] (@FiscalYearPeriod_1 varchar(6), @FiscalYearPeriod_2 varchar(6))
RETURNS TABLE 
AS
RETURN 
(

--DECLARE @FiscalYearPeriod_1 VARCHAR(6) = '201708'
--DECLARE @FiscalYearPeriod_2 VARCHAR(6) = '201709';

WITH cte_dso AS
  (
  SELECT ParentConcept.Id AS ConceptId, 
		ParentConcept.ParentConceptNumber AS ConceptNumber, 
		ParentConcept.ParentConceptName	 AS ConceptName,
		@FiscalYearPeriod_1 AS Column1_Label,
		@FiscalYearPeriod_2 AS Column2_Label,
		SUM(CASE WHEN CAST(FiscalPeriods.FiscalYear AS varchar) + RIGHT('0' + CAST(FiscalPeriods.FiscalPeriod AS varchar), 2) = @FiscalYearPeriod_1
			THEN TotalInventoryValuation
			ELSE 0 END) AS DSO_Period1_TotalInventoryValuation,
		SUM(CASE WHEN CAST(FiscalPeriods.FiscalYear AS varchar) + RIGHT('0' + CAST(FiscalPeriods.FiscalPeriod AS varchar), 2) = @FiscalYearPeriod_1
			THEN AverageDailySales
			ELSE 0 END) AS DSO_Period1_AverageDailySales,
		SUM(CASE WHEN CAST(FiscalPeriods.FiscalYear AS varchar) + RIGHT('0' + CAST(FiscalPeriods.FiscalPeriod AS varchar), 2) = @FiscalYearPeriod_2
			THEN TotalInventoryValuation
			ELSE 0 END) AS DSO_Period2_TotalInventoryValuation,
		SUM(CASE WHEN CAST(FiscalPeriods.FiscalYear AS varchar) + RIGHT('0' + CAST(FiscalPeriods.FiscalPeriod AS varchar), 2) = @FiscalYearPeriod_2
			THEN AverageDailySales
			ELSE 0 END) AS DSO_Period2_AverageDailySales
	FROM [dso].[DSOFactorsHistory] 
	JOIN erp.FiscalPeriods
	ON [DSOFactorsHistory].EvaluationDate = FiscalPeriods.EndDate
	JOIN erp.Concept
	ON DSOFactorsHistory.ConceptId = Concept.Id
	JOIN erp.ParentConcept
	ON Concept.ParentConceptId = ParentConcept.Id
	WHERE TotalInventoryValuation <> 0
	GROUP BY ParentConcept.Id,ParentConcept.ParentConceptNumber, ParentConcept.ParentConceptName
	) 
SELECT TOP 10000 *
  ,CASE WHEN DSO_Period1_AverageDailySales = 0 THEN 0 ELSE Round(DSO_Period1_TotalInventoryValuation / DSO_Period1_AverageDailySales,2) END AS DSO_Period1
  ,CASE WHEN DSO_Period2_AverageDailySales = 0 THEN 0 ELSE Round(DSO_Period2_TotalInventoryValuation / DSO_Period2_AverageDailySales,2) END AS DSO_Period2
  ,(CASE WHEN DSO_Period2_AverageDailySales = 0 THEN 0 ELSE Round(DSO_Period2_TotalInventoryValuation / DSO_Period2_AverageDailySales,2) END - 
    CASE WHEN DSO_Period1_AverageDailySales = 0 THEN 0 ELSE Round(DSO_Period1_TotalInventoryValuation / DSO_Period1_AverageDailySales,2) END )/
    CASE WHEN DSO_Period1_AverageDailySales = 0 THEN 1 ELSE Round(DSO_Period1_TotalInventoryValuation / DSO_Period1_AverageDailySales,2) END AS DSO_CHANGE
  FROM cte_dso
  ORDER BY ConceptNumber
 )