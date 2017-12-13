SELECT 
  [DCID] 
  ,CONVERT(char(4), YEAR(ScheduledDate)) +  RIGHT('0' + RTrim(CONVERT(varchar(3), MONTH(ScheduledDate))),2) AS Month
  ,CONVERT(decimal(6,2),SUM(ISNULL([ScanQuantity],0)) /
  SUM(ISNULL([LoadedQuantity],0)))  AS scan_percent
  FROM [DriverPro].[driverpro].[Route] r
  WHERE r.RouteStatus = 'C'
  GROUP BY DCID, r.ScheduledDate
  Order by DCID, Month