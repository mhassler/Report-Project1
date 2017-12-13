DECLARE @EvaluationDate datetime = CONVERT(date, GETDATE() )
USE [SygmaODS]

SELECT d.EvaluationDate, d.DCId, d.DCCode, d.DCName, 
	d.ConceptId, d.ConceptNumber, d.ConceptName, 
	i.CICSIT,
	d.ItemId, d.ItemUPC, d.ItemName , d.ConceptDCPercentSales, d.ItemQuantityOnHand, 
	d.ConceptAllocatedQuantityOnHand, d.ValuePerCase, d.AverageWeight, d.TotalInventoryValuation, d.AverageDailySales
From dso.DSOFactorsHistory d
INNER JOIN  [SygmaODS].[erp].[Concept] c ON c.Id = d.ConceptID
INNER JOIN  [SygmaODS].[erp].[ParentConcept] p ON p.[Id] = c.ParentConceptId
LEFT OUTER JOIN [COLUMBUS].[IASP_SYGMA].[QS36F].[PUCSIT] i ON i.CISUPC# = d.ItemUPC
WHERE d.EvaluationDate = CAST(@EvaluationDate AS Date)
	--AND ParentConcept.Id IN ( @ParentConceptId)
--AND ItemUPC = ISNULL(@ItemUPC, ItemUPC)
ORDER BY d.DCCode, d.ConceptName 

--[IASP_SYGMA]
--CICSTY = customer type / compartment# and CICSIT = customer part #
