DECLARE @EvaluationDate char(10) = '07/05/2017'
USE SygmaODS

SELECT 
 EvaluationDate, DCId, DCCode, DCName, 
    ConceptId, [DSOFactorsHistory].ConceptNumber, [DSOFactorsHistory].ConceptName, 
	APTYPE AS ItemType, 
	ItemId, ItemUPC, ItemName, ConceptDCPercentSales, ItemQuantityOnHand, 
	ConceptAllocatedQuantityOnHand, ValuePerCase, AverageWeight, TotalInventoryValuation, AverageDailySales
FROM [dso].[DSOFactorsHistory]
JOIN erp.Concept
ON DSOFactorsHistory.ConceptId = Concept.Id
JOIN erp.ParentConcept ON Concept.ParentConceptId = ParentConcept.Id
JOIN [Center00].[AP1PMNX0] ON [AP1PMNX0].APSUPC# = DSOFactorsHistory.ItemUPC
WHERE EvaluationDate = CAST(@EvaluationDate AS Date)
	--AND ParentConcept.Id IN ( @ParentConceptId)
--AND ItemUPC = ISNULL(@ItemUPC, ItemUPC)
ORDER BY DCCode, ConceptName, APTYPE