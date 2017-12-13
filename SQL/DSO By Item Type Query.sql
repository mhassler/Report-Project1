DECLARE @EvaluationDate date = '07-28-2017'
SELECT f.ConceptId,  f.ConceptNumber ,f.ConceptName    
    ,f.DCId, f.DCCode,  f.DCName    
   ,a.APTYPE    
   ,ItemId, ItemUPC , ItemName    
   , ConceptDCPercentSales, ItemQuantityOnHand    ,ConceptAllocatedQuantityOnHand
   , ValuePerCase, AverageWeight    
   ,TotalInventoryValuation , AverageDailySales    
   ,CASE WHEN AverageDailySales = 0 THEN 0 ELSE         TotalInventoryValuation/AverageDailySales END AS DSO
   --,TotalInventoryValuation/NULLIF(f.AverageDailySales,0) AS DSO    
   ,EvaluationDate  
   FROM [dso].[DSOFactorsHistory] f    
   JOIN erp.Concept ON f.ConceptId = Concept.Id    
   JOIN erp.ParentConcept ON Concept.ParentConceptId = ParentConcept.Id    
   JOIN (SELECT DISTINCT APSUPC#,  APTYPE FROM [Center00].[AP1PMNX0]) a ON a.APSUPC# = f.ItemUPC
   WHERE EvaluationDate = CAST(@EvaluationDate AS Date)         
   AND NOT TotalInventoryValuation = 0       
   --AND ParentConcept.Id IN ( @ParentConceptId)  