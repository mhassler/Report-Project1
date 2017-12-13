DECLARE @UseAggregate bit = 0
-- LastWeekStart
DECLARE @ReportStartDate datetime = DATEADD(wk, -1, DATEADD(DAY, 1-DATEPART(WEEKDAY, GETDATE()), DATEDIFF(dd, 2, GETDATE())))
DECLARE @ReportEndDate datetime = CONVERT(date,DATEADD(day, +6, @ReportStartDate))
DECLARE @EndDate datetime = CONVERT(date,DATEADD(day,1,@ReportEndDate))
DECLARE @MinScanPercent int = 200

--SELECT @ReportStartDate , @ReportEndDate, @EndDate

IF @UseAggregate = 1
 SELECT DriverName
    ,[DCName]
    ,r.[RouteID]
    ,r.[ScheduledDate]
    ,r.RouteStatus
    ,drv_scan_percent
   ,SUM(ScanQuantity) AS ScanQuantity
   ,SUM(DeliveredQuantity) AS DeliveredQuantity
   ,ROUND((SUM(ScanQuantity)/SUM(DeliveredQuantity) ) * 100,1) AS Scan_Percent
  FROM [DriverPro].[driverpro].[Route] r  
  INNER JOIN [DriverPro].[driverpro].[DC] dc  
    ON dc.DCID = r.DCID
  INNER JOIN [DriverPro].[driverpro].[Driver] d ON d.DriverID = r.DriverID
  INNER JOIN (
    SELECT r.DriverID 
     ,ROUND((SUM(ScanQuantity)/SUM(DeliveredQuantity) ) * 100,1) AS drv_scan_percent
  FROM [DriverPro].[driverpro].[Route] r 
  WHERE r.ScheduledDate BETWEEN @ReportStartDate AND @EndDate 
      AND r.RouteStatus = 'C'
  GROUP BY r.DriverID ) ds ON ds.DriverID = r.DriverID 
  WHERE r.ScheduledDate BETWEEN @ReportStartDate AND @EndDate 
      AND r.RouteStatus = 'C'
	  --AND d.DriverName IN (@DriverName)
     AND drv_scan_percent < @MinScanPercent
  GROUP BY DriverName, DCName, r.RouteId, r.ScheduledDate, r.RouteStatus,drv_scan_percent
  ORDER BY DriverName, DCName, r.RouteId, r.ScheduledDate, r.RouteStatus   
ELSE
  SELECT d.DriverName
   ,[DCName]
   ,r.[RouteID]
   ,r.[ScheduledDate]
   ,r.RouteStatus
   ,0 AS drv_scan_percent
   ,SUM(ScanQuantity) AS ScanQuantity
   ,SUM(DeliveredQuantity) AS DeliveredQuantity
   ,ROUND((SUM(ScanQuantity)/SUM(DeliveredQuantity) ) * 100,1) AS Scan_Percent
  FROM [DriverPro].[driverpro].[Route] r
  INNER JOIN [DriverPro].[driverpro].[DC] dc ON dc.DCID = r.DCID
  INNER JOIN [DriverPro].[driverpro].[Driver] d ON d.DriverID = r.DriverID
  WHERE r.ScheduledDate BETWEEN @ReportStartDate AND @EndDate 
      AND r.RouteStatus = 'C'
      --AND d.DriverName IN (@DriverName)
  GROUP BY d.DriverName, DCName, r.RouteId, r.ScheduledDate, r.RouteStatus  
  HAVING ROUND((SUM(ScanQuantity)/SUM(DeliveredQuantity) ) * 100,0) < @MinScanPercent
  ORDER BY d.DriverName, DCName, r.RouteId, r.ScheduledDate, r.RouteStatus