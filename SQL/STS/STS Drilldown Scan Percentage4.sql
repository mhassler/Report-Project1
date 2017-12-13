DECLARE @DC varchar(3) = '063' 
DECLARE @ScheduledDate datetime = '2017-10-27 00:00:00.000'
DECLARE @RouteID VARCHAR(20) = '569L'
DECLARE @StopSeq INT = 5
--------DECLARE @ProductID varchar(20) = '6076030'

SELECT d.[DCID]
      ,d.[ScheduledDate]
      ,d.[RouteID]
      ,d.[StopSequenceNumber]
	  ,s.[StopName]
	  ,s.ManifestNumber
      ,d.[ProductID] 
      ,[ItemDescription]
      ,d.[DeliveredQuantity]
	  ,[TimeStamp]
	  ,[Barcode]
  FROM [DriverPro].[driverpro].[Stop] s
  INNER JOIN [DriverPro].[driverpro].[DeliveryItem] d
    ON d.DCID = s.DCID AND s.ScheduledDate = d.ScheduledDate and s.RouteID = d.RouteID  
	   AND s.StopSequenceNumber = d.StopSequenceNumber
  INNER JOIN [DriverPro].[driverpro].[Barcode] b
    ON b.DCID = d.DCID AND b.ScheduledDate = d.ScheduledDate and b.RouteID = d.RouteID  AND b.ItemID = d.ItemID
  WHERE d.DCID = @DC AND d.ScheduledDate = @ScheduledDate
	 AND d.RouteID = @RouteID
	 AND d.StopSequenceNumber = @StopSeq
	 --AND d.ProductID = @ProductID
  --GROUP BY s.DCID ,s.ScheduledDate ,s.RouteID, s.StopSequenceNumber, s.StopName, s.ManifestNumber, d.ProductID , d.[ItemDescription], d.[DeliveredQuantity]
   --, b.TimeStamp, b.Barcode 
  ORDER BY d.DCID ,d.ScheduledDate , b.TimeStamp, d.RouteID, d.StopSequenceNumber, d.ProductID