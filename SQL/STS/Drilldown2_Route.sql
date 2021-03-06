DECLARE @ReportStartDate datetime = CONVERT(date, GETDATE()-6)
DECLARE @ReportEndDate datetime = CONVERT(date, GETDATE()-3)
DECLARE @DCNAME varchar(75) = 'SYGMA Carolina(081)'

SELECT [DCName] 
      ,[RouteID]
      ,[ScheduledDate]
      ,[RouteStatus]
      ,[DriverID]
      ,[Stops]
	  ,[RouteDownloadTime] ,[RouteUploadTime]
      ,DATEDIFF(hh,[RouteDownloadTime] ,[RouteUploadTime] ) AS RouteCompletionTime
	  ,SUM([ScanQuantity]) As Qty_Scanned
	  ,SUM([DeliveredQuantity])  AS Qty_Delivered
	  ,CONVERT(smallint,ROUND(SUM([ScanQuantity]) / SUM([DeliveredQuantity])*100,0)) AS Scan_Percent
  FROM [DriverPro].[driverpro].[Route] r
  INNER JOIN [DriverPro].[driverpro].[DC] dc ON dc.DCID = r.DCID
  WHERE [ScheduledDate] BETWEEN @ReportStartDate AND DATEADD(d,1,@ReportEndDate)
    AND RouteStatus = 'C'
  GROUP BY DCName , RouteID, ScheduledDate, [RouteStatus], [DriverID],[Stops],[RouteDownloadTime] ,[RouteUploadTime], DATEDIFF(hh ,[RouteDownloadTime] ,[RouteUploadTime] )
  ORDER BY DCName , RouteID, ScheduledDate, [RouteStatus], [DriverID]
