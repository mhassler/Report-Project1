DECLARE @FiscalYearPeriod_1 VARCHAR(6) = '201706'
DECLARE @FiscalYearPeriod_2 VARCHAR(6) = '201709'

SELECT *
  ,CASE WHEN DSO_Period1_AverageDailySales = 0 THEN 0 ELSE Round(DSO_Period1_TotalInventoryValuation / DSO_Period1_AverageDailySales,2) END AS DSO_Period1
  ,CASE WHEN DSO_Period2_AverageDailySales = 0 THEN 0 ELSE Round(DSO_Period2_TotalInventoryValuation / DSO_Period2_AverageDailySales,2) END AS DSO_Period2
  ,(CASE WHEN DSO_Period2_AverageDailySales = 0 THEN 0 ELSE Round(DSO_Period2_TotalInventoryValuation / DSO_Period2_AverageDailySales,2) END - 
   CASE WHEN DSO_Period1_AverageDailySales = 0 THEN 0 ELSE Round(DSO_Period1_TotalInventoryValuation / DSO_Period1_AverageDailySales,2) END ) /
  FROM f
  (
  SELECT TOP 1000000 
		ParentConcept.Id AS ConceptId, 
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
	ORDER BY ConceptNumber
	) f