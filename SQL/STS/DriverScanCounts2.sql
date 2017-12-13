DECLARE @ReportStartDate date = CONVERT( date, GETDATE() -7 )
DECLARE @ReportEndDate date = @ReportStartDate
DECLARE @MinScanPercent int = 80

SELECT d.DriverName
      ,[DCName]
      ,r.[RouteID]
      ,r.[ScheduledDate]
    ,r.RouteStatus
      --,[ScanQuantity]
      --,[PalletQuantity]
	  ,COUNT(*)  AS scans_expected
	  ,SUM(b.ScanCount) AS scans_executed
    ,(SUM(b.ScanCount) / COUNT(*) ) AS Scan_Percent
	,SUM(b.ScanCount) / COUNT(*)  OVER (partition BY drivername) AS Drvr_Scan_Percent
  FROM [DriverPro].[driverpro].[Route] r
  LEFT OUTER JOIN [DriverPro].[driverpro].[Barcode] b ON b.ScheduledDate = r.ScheduledDate
     AND b.DCID = r.DCID AND b.RouteID = r.RouteID
  INNER JOIN [DriverPro].[driverpro].[DC] dc ON dc.DCID = r.DCID
  INNER JOIN [DriverPro].[driverpro].[Driver] d ON d.DriverID = r.DriverID
  WHERE r.ScheduledDate BETWEEN @ReportStartDate AND @ReportEndDate 
      AND r.RouteStatus = 'C'
      --AND d.DriverName IN (@DriverName)
      ---AND Scan_Percent < @MinScanPercent
  GROUP BY d.DriverName, DCName, r.RouteId, r.ScheduledDate, r.RouteStatus  
 --HAVING CASE WHEN @MinScanPercent Is Null THEN  1 ELSE (SUM(ISNULL--(b.ScanCount,0)) / Count(*) ) END
--HAVING (SUM(ISNULL(b.ScanCount,0)) / Count(*)*100 )  < @MinScanPercent
--HAVING SUM(ScanCount) / COUNT(*)  OVER (partition BY drivername) <  @MinScanPercent
  ORDER BY d.DriverName, DCName, r.RouteId, r.ScheduledDate, r.RouteStatus  
  

























































































  