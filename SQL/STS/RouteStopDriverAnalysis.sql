DECLARE @RptDate datetime = CONVERT(date, GETDATE()-2)
SELECT r.[DCID]
      ,r.[RouteID]08/20/2017
	  ,r.[ScheduledDate]
	  --,d.[DriverID]
	  ,d.[DriverName]
      --,[RouteStatus]
      --,[ResultsExportedIndicator]   --=1
      --,[RouteDownloadTime]
      --,[RouteUploadTime]
      --,[Stops]
      --,s.[StopID]
      ,s.[StopName]
      ,s.[StopSequenceNumber]
	  ,SUM(s.[PlannedQuantity])   AS [StopPlannedQuantity] 
      ,SUM(s.[LoadedQuantity])    AS [StopLoadedQuantity]
      ,SUM(s.[DeliveredQuantity]) AS [StopDeliveredQuantity] 
      ,SUM(s.[InRouteSplitQuantity])  AS [StopInRouteSplitQuantity]
      ,SUM(s.[RejectedQuantity] + s.[ReturnedQuantity]) AS [StopBadQuantity]
      ,SUM(s.[ScanQuantity])  AS  [StopScanQuantity]
      ,SUM(s.[PalletQuantity]) AS [StopPalletQuantity]
	  ,SUM(s.[ScanQuantity]) / SUM(NULLIF(s.[DeliveredQuantity],0))*100 AS [StopScanPercentage]
	  --,r.[LoadedQuantity]
	  --,r.[DeliveredQuantity]
      --,r.[InRouteSplitQuantity]
      --,r.[RejectedQuantity]
      --,r.[ReturnedQuantity]
      --,r.[ScanQuantity]
      ,SUM(r.[PalletQuantity]) AS [RoutePalletQuantity]
      --,[GMTOffset]
  FROM [DriverPro].[driverpro].[Route]  r WITH (NOLOCK)
  JOIN [DriverPro].[driverpro].[Driver] d  WITH (NOLOCK) ON d.driverid = r.Driverid
  LEFT OUTER JOIN [DriverPro].[driverpro].[Stop] s WITH (NOLOCK) ON s.RouteID = r.RouteId AND s.DCID = r.DCID 
     AND s.ScheduledDate = r.ScheduledDate  
  --WHERE CONVERT(date,RouteUploadTime) = @RptDate 
  WHERE CONVERT(date,r.ScheduledDate) = @RptDate 
  --and s.PalletQuantity > 0
  GROUP BY r.[DCID], r.[RouteID], r.[ScheduledDate] ,d.[DriverName], s.[StopSequenceNumber] ,s.[StopName]
  ORDER BY r.DCID, r.RouteID, r.[ScheduledDate] ,d.[DriverName], s.StopSequenceNumber 
  