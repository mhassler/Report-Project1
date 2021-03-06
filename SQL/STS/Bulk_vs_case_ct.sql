DECLARE @startdate datetime = CONVERT(date,GETDATE()-7)
DECLARE @enddate datetime = CONVERT(date,GETDATE()-5)

SELECT
    dcid
	,routeid 
    ,scheduleddate
   ,SUM(pallets) as pallets
   ,SUM(bulk_cases) AS bulk_cases
   ,CONVERT( numeric(10,0), SUM(bulk_scans)) AS bulk_scans
   ,CONVERT( numeric(10,0), (SUM(bulk_scans)/SUM(NULLIF(bulk_cases, 0)))*100) AS bulk_scan_percentage
   ,CONVERT( numeric(10,0), SUM(reg_cases) ) AS reg_cases
   ,CONVERT( numeric(10,0), SUM(reg_scans) ) AS reg_scans
   ,CONVERT( numeric(10,0), (SUM(reg_scans)/SUM(NULLIF(reg_cases,0)))*100 ) AS reg_scan_percentage
   ,SUM(Total_Cases) AS Total_Cases
   ,SUM(Scanned_Cases) AS Scanned_Cases
   ,SUM(total_possible_scans) AS total_possible_scans
   FROM
   (
   SELECT 
        RouteID 
       ,DCID  
       ,scheduleddate
       ,SUM(CASE WHEN [MultiStopBulkIndicator] = 1 THEN 1 ELSE 0 END) AS pallets
	   ,SUM(CASE WHEN [MultiStopBulkIndicator] = 1 THEN [SelectedQuantity] ELSE 0 END) AS bulk_cases
	   ,SUM(CASE WHEN [MultiStopBulkIndicator] = 1 THEN [ScanCount] ELSE 0 END) AS bulk_scans
	   ,SUM(CASE WHEN [MultiStopBulkIndicator] = 0 THEN [SelectedQuantity] ELSE 0 END) AS reg_cases
	   ,SUM(CASE WHEN [MultiStopBulkIndicator] = 0 THEN [ScanCount] ELSE 0 END) AS reg_scans
	   ,SUM([SelectedQuantity]) AS Total_Cases
	   ,SUM([ScanCount]) AS Scanned_Cases
	   ,COUNT(*) AS total_possible_scans 
  FROM [DriverPro].[driverpro].[Barcode]
  where scheduleddate between @startdate and @enddate	
  GROUP BY  dcid, routeid, scheduleddate, MultiStopBulkIndicator
  ) t1
  GROUP BY dcid, routeid, scheduleddate
  ORDER BY dcid, routeid, scheduleddate