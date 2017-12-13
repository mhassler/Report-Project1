DECLARE @today datetime = CONVERT(datetime, CONVERT( date, GETDATE() -1) )

SELECT d.DriverName
      ,r.[DCID]
      ,r.[RouteID]
      ,r.[ScheduledDate]
	  --,r.RouteStatus
      --,[ScanQuantity]
      --,[PalletQuantity]
	  ,COUNT(*)  AS scans_expected
	  ,SUM(ISNULL(b.ScanCount,0)) AS scans_executed
  FROM [DriverPro].[driverpro].[Route] r
  LEFT OUTER JOIN [DriverPro].[driverpro].[Barcode] b ON b.ScheduledDate = r.ScheduledDate
     AND b.DCID = r.DCID AND b.RouteID = r.RouteID
  INNER JOIN [DriverPro].[driverpro].[Driver] d ON d.DriverID = r.DriverID
  WHERE r.ScheduledDate = @today AND r.RouteStatus = 'C'
    AND d.DriverName IN (@DriverName)
  GROUP BY d.DriverName, r.DCID, r.RouteId, r.ScheduledDate--, r.RouteStatus  
  ORDER BY d.DriverName, r.DCID, r.RouteId, r.ScheduledDate--, r.RouteStatus  
  
  `
