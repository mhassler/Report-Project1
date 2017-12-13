DECLARE @today datetime = CONVERT(datetime, CONVERT( date, GETDATE() -1) )

SELECT r.[DCID]
      ,r.[RouteID]
      ,r.[ScheduledDate]
	  ,r.RouteStatus
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
	  ,COUNT(*)  AS scans_expected
	  ,SUM(ISNULL(b.ScanCount,0)) AS scans_executed
  FROM [DriverPro].[driverpro].[Route] r
  LEFT OUTER JOIN [DriverPro].[driverpro].[Barcode] b ON b.ScheduledDate = r.ScheduledDate
     AND b.DCID = r.DCID AND b.RouteID = r.RouteID
  WHERE r.ScheduledDate = @today
    --AND RouteStatus = 'C'
  GROUP BY r.ScheduledDate, r.RouteId, r.DCID, RouteStatus  
  --WITH ROLLUP
  --HAVING SUM(ISNULL(b.ScanCount,0)) = 0 
  Order by r.RouteStatus , r.ScheduledDate, r.RouteId, r.DCID
  
  
