DECLARE @ReportStartDate datetime = CONVERT(date, GETDATE()-6)
DECLARE @ReportEndDate datetime = CONVERT(date, GETDATE()-3)

SELECT [DCName] 
	  ,CONVERT(smallint, (SUM([ScanQuantity]) / SUM([DeliveredQuantity])) * 100) AS Scan_Percent
  FROM [DriverPro].[driverpro].[Route] r
  INNER JOIN [DriverPro].[driverpro].[DC] dc ON dc.DCID = r.DCID
  WHERE [ScheduledDate] BETWEEN @ReportStartDate AND DATEADD('d',1,@ReportEndDate)
     AND RouteStatus = 'C'
  GROUP BY [DCName]
  ORDER BY [DCName]

    