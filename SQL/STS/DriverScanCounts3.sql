DECLARE @ReportStartDate date = CONVERT( date, GETDATE()-5 )
DECLARE @ReportEndDate date = CONVERT( date, GETDATE()-3 )
DECLARE @MinScanPercent int = 95
DECLARE @UseAggregate bit = 1

IF @UseAggregate = 0
 SELECT d.DriverName
    ,[DCName]
    ,r.[RouteID]
    ,r.[ScheduledDate]
    ,r.RouteStatus
	,drv_scan_percent
	,SUM(ISNULL(b.ScanCount,0)) AS scans_executed
    ,COUNT(*)  AS scans_expected
    ,(SUM(ISNULL(b.ScanCount,0)) / COUNT(*) * 100) AS scan_percent
  FROM [DriverPro].[driverpro].[Route] r
  LEFT OUTER JOIN [DriverPro].[driverpro].[Barcode] b ON b.ScheduledDate = r.ScheduledDate
     AND b.DCID = r.DCID AND b.RouteID = r.RouteID
  INNER JOIN [DriverPro].[driverpro].[DC] dc ON dc.DCID = r.DCID
  INNER JOIN [DriverPro].[driverpro].[Driver] d ON d.DriverID = r.DriverID
  INNER JOIN (
    SELECT r.DriverID 
	  ,(SUM(ISNULL(b.ScanCount,0)) / COUNT(*)) * 100  AS drv_scan_percent
  FROM [DriverPro].[driverpro].[Route] r
  LEFT OUTER JOIN [DriverPro].[driverpro].[Barcode] b ON b.ScheduledDate = r.ScheduledDate
     AND b.DCID = r.DCID AND b.RouteID = r.RouteID
  WHERE r.ScheduledDate BETWEEN @ReportStartDate AND @ReportEndDate 
      AND r.RouteStatus = 'C'
      --AND d.DriverName IN (@DriverName)
  GROUP BY r.DriverID
  HAVING (SUM(ISNULL(b.ScanCount,0)) / Count(*)*100 )  < @MinScanPercent
  ) ds ON ds.DriverID = r.DriverID 
  WHERE r.ScheduledDate BETWEEN @ReportStartDate AND @ReportEndDate 
      AND r.RouteStatus = 'C'
	  AND drv_scan_percent < @MinScanPercent
  GROUP BY d.DriverName, DCName, r.RouteId, r.ScheduledDate, r.RouteStatus,drv_scan_percent
  --HAVING (SUM(ISNULL(b.ScanCount,0)) / Count(*)*100 )  < @MinScanPercent
  ORDER BY d.DriverName, DCName, r.RouteId, r.ScheduledDate, r.RouteStatus   
ELSE

SELECT d.DriverName
   ,[DCName]
   ,r.[RouteID]
   ,r.[ScheduledDate]
   ,r.RouteStatus
   ,0 AS drv_scan_percent
   ,COUNT(*)  AS scans_expected
   ,SUM(ISNULL(b.ScanCount,0)) AS scans_executed
   ,(SUM(ISNULL(b.ScanCount,0)) / COUNT(*) *100) AS Scan_Percent
  FROM [DriverPro].[driverpro].[Route] r
  LEFT OUTER JOIN [DriverPro].[driverpro].[Barcode] b ON b.ScheduledDate = r.ScheduledDate
     AND b.DCID = r.DCID AND b.RouteID = r.RouteID
  INNER JOIN [DriverPro].[driverpro].[DC] dc ON dc.DCID = r.DCID
  INNER JOIN [DriverPro].[driverpro].[Driver] d ON d.DriverID = r.DriverID
  WHERE r.ScheduledDate BETWEEN @ReportStartDate AND @ReportEndDate 
      AND r.RouteStatus = 'C'
      --AND d.DriverName IN (@DriverName)
  GROUP BY d.DriverName, DCName, r.RouteId, r.ScheduledDate, r.RouteStatus  
  HAVING (SUM(ISNULL(b.ScanCount,0)) / Count(*)*100 )  < @MinScanPercent
  ORDER BY d.DriverName, DCName, r.RouteId, r.ScheduledDate, r.RouteStatus
