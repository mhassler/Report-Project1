DECLARE @today datetime = CONVERT(datetime, CONVERT( date, GETDATE() -1) )

SELECT r.[DCID]
      ,r.[RouteID]
      ,r.[ScheduledDate]
      --,[Stops]
      --,[PlannedQuantity]
      --,[LoadedQuantity]
      --,[DeliveredQuantity]
      --,[InRouteSplitQuantity]
      --,[RejectedQuantity]
      --,[ReturnedQuantity]
      --,[OtherPickupQuantity]
      --,[DriverSignature]
      --,[ScanQuantity]
      --,[PalletQuantity]
      --,[SerialNumber]
      --,[Inputs]
      --,[InputResults]
      --,[CheckInAssetsIndicator]
      --,[CheckInAssets]
      --,[GMTOffset]
	  --,COUNT(b.ScanCount) as scans_expected
	  --,SUM(b.ScanCount) as scans_executed
  FROM [DriverPro].[driverpro].[Route] r
  WHERE r.ScheduledDate = @today 
    AND r.DCID + r.RouteID + CONVERT(varchar, r.ScheduledDate,101)
	   NOT IN (SELECT b.DCID + b.RouteID + CONVERT(varchar, b.ScheduledDate,101) 
	          FROM [DriverPro].[driverpro].[Barcode] b WHERE b.ScheduledDate = @today)
  Order by ScheduledDate, DCID, RouteId
  
