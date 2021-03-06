DECLARE @today datetime = CONVERT(datetime, CONVERT( date, GETDATE() -1) );

--SELECT [DCID]
--      ,[RouteID] 
--      ,[ScheduledDate]
--	  ,COUNT(*) AS barcodes
--  FROM [DriverPro].[driverpro].[Barcode]
--  WHERE ScheduledDate = CONVERT(date, GETDATE() -1)
--  GROUP BY [DCID] ,[RouteID] ,[ScheduledDate]
--  --HAVING COUNT(*) = 0
--  --WITH ROLLUP 

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
  WHERE ScheduledDate = CONVERT(date, GETDATE() )
  and DCID = 183