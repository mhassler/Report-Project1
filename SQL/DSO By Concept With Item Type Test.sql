USE SygmaODS 
DECLARE @EvaluationDate AS date = CONVERT(date, '07-24-2017')

SELECT ParentConcept.ParentConceptName
    ,DCName
	,APTYPE
	,ItemUPC, ItemName
	,SUM(ConceptAllocatedQuantityOnHand) AS ConceptAllocatedQuantityOnHand
	,AVG(ValuePerCase) AS ValuePerCase
	,AVG( AverageWeight ) AS AverageWeight
	,SUM(TotalInventoryValuation) AS TotalInventoryValuation
	,SUM(AverageDailySales) AS AverageDailySales
	--,CASE WHEN AverageDailySales = 0 THEN 0 ELSE SUM(TotalInventoryValuation)/SUM(AverageDailySales) END AS DSO
	,SUM(TotalInventoryValuation)/SUM(NULLIF(AverageDailySales,0)) AS DSO
	--,SUM(TotalInventoryValuation)/SUM(AverageDailySales) AS DSO
	--EvaluationDate, DCId, DCCode, 
	--ParentConcept.Id AS ParentConceptId, ParentConcept.ParentConceptNumber,
	--ConceptId, [DSOFactorsHistory].ConceptNumber, [DSOFactorsHistory].ConceptName, 
	--ItemId, 
	--ConceptDCPercentSales, ItemQuantityOnHand, 
FROM [dso].[DSOFactorsHistory]
JOIN erp.Concept ON DSOFactorsHistory.ConceptId = Concept.Id
JOIN erp.ParentConcept ON Concept.ParentConceptId = ParentConcept.Id
JOIN [Center00].[AP1PMNX0] ON [AP1PMNX0].APSUPC# = DSOFactorsHistory.ItemUPC
WHERE TotalInventoryValuation <> 0
    --AND AverageDailySales <> 0
	AND EvaluationDate = @EvaluationDate
--	AND ParentConcept.Id IN ( @ParentConceptId)
GROUP BY 
  GROUPING SETS((ParentConcept.ParentConceptName,DCName,APTYPE,ItemUPC, ItemName),())--, AverageDailySales
--WITH ROLLUP