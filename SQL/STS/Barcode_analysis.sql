DECLARE @today datetime = CONVERT(datetime, CONVERT( date, GETDATE() -1) )

SELECT [DCID]
      ,[RouteID]
      ,[ScheduledDate]
      ,[ItemID]
      ,[Barcode]
      ,[ProductID]
      ,[MultiStopBulkIndicator]
      ,[OrderLineState]
      ,[SelectedQuantity]
      ,[Status]
      ,[ScanFlag]
      ,[ScanCount]
      ,[TimeStamp]
  FROM [DriverPro].[driverpro].[Barcode]
  where ScheduledDate  = @today 
  AND MultiStopBulkIndicator = 1
  AND Status is null
  --AND SelectedQuantity <> ScanCount
  --AND ScanCount > 0
  --AND ScanFlag = 'S'
  --AND ScanFlag NOT IN ('M','S') 
  
  
 /* Barcode Record states
 MultiStopBulkIndicator - 0
	SelectedQuantity alway = 1
	Status = U (Uploaded)
		ScanFlag = M (Manual - ScanCount = 0)
		ScanFlag = S (Scanned- ScanCount = 1)	
	Status = R (Rejected - damage or whatever)
		ScanFlag = M (Manual - ScanCount = 0)
		ScanFlag = S (Scanned- ScanCount = 1)
	Status = S (Split)
		ScanFlag = M (Manual - ScanCount = 0)
		ScanFlag = S (Scanned- ScanCount = 1)

 MultiStopBulkIndicator - 1
	Status = U (Uploaded)
		ScanFlag = M (Manual - ScanCount = 0)
		ScanFlag = S (Scanned- ScanCount > 0 even if <> SelectedQuantity)	
	Status is NULL
		ScanFlag = M (Manual - ScanCount = 0)
		ScanFlag = S (Scanned- ScanCount <> SelectedQuantity where ScanCount = 0 OR ScanCount > 0)	
		***** The two status' for the same state is an inconsistency
*/