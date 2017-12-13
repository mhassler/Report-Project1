DECLARE @EvaluationDate char(10) = '07/11/2017'
SELECT EvaluationDate, DCId, DCCode, DCName, 
	ConceptId, [DSOFactorsHistory].ConceptNumber, [DSOFactorsHistory].ConceptName, 
	APTYPE,
	ItemId, ItemUPC, ItemName, ConceptDCPercentSales, ItemQuantityOnHand, 
	ConceptAllocatedQuantityOnHand, ValuePerCase, AverageWeight, TotalInventoryValuation, AverageDailySales,
	CASE WHEN AverageDailySales = 0 THEN 0 ELSE TotalInventoryValuation/AverageDailySales END AS DSO
FROM [dso].[DSOFactorsHistory]
JOIN erp.Concept ON DSOFactorsHistory.ConceptId = Concept.Id
JOIN erp.ParentConcept ON Concept.ParentConceptId = ParentConcept.Id
JOIN [Center00].[AP1PMNX0] ON [AP1PMNX0].APSUPC# = DSOFactorsHistory.ItemUPC
WHERE TotalInventoryValuation <> 0
	AND EvaluationDate = CAST(@EvaluationDate AS Date)
--	AND ParentConcept.Id IN ( @ParentConceptId)