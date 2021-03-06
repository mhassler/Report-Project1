DECLARE @dt date = CONVERT( VARCHAR(10), GETDATE() -30, 120)

--SELECT @dt

SELECT TOP (1000) 
      DATENAME(dw,[EvaluationDate]) AS Day
      ,[EvaluationDate] AS Date
      ,SUM([TotalInventoryValuation]) AS Inv_Value
      ,SUM([AverageDailySales]) AS Sales
	  ,CONVERT( numeric(30,2), ROUND(SUM([TotalInventoryValuation])/SUM([AverageDailySales]),2)) AS DSO 
	  --,SUM([TotalInventoryValuation]) + SUM([AverageDailySales]) - SUM([PREV_TotalInventoryValuation])
	  ,SUM(LAG([TotalInventoryValuation],1,0) OVER (ORDER BY [EvaluationDate])) AS Prev_INv
  FROM [SygmaODS].[dso].[DSOFactorsHistory]
  WHERE [EvaluationDate] >= @dt
    AND [AverageDailySales] <> 0
  GROUP BY  [EvaluationDate]
  







