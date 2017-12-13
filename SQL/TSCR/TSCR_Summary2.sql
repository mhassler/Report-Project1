USE SygmaODS
DECLARE @ComparisonType int = 0
DECLARE @DCid INT = 6 --Carolina

SELECT * 
FROM [dbo].[getTSCRFullSummary] (@ComparisonType) s
FULL OUTER JOIN [tscr].[TSCRAdjustments] a ON a.DCID = s.DCId
  AND a.ConceptID = s.ConceptId AND a.SupplierID = s.SupplierId
  AND a.ItemUPC = s.ItemUPC	
  WHERE S.DCId IN ( @DcId )
	--AND ItemUPC = ISNULL(@ItemUPC, ItemUPC)
	--AND ConceptId IN (@ConceptId)
	and AdjustmentID is not null
