DECLARE @Startdt date = CONVERT( VARCHAR(10), GETDATE() -60, 120)
DECLARE @EndDt date = CONVERT( VARCHAR(10), GETDATE() , 120)

;WITH cte_inv AS
(
SELECT ROW_NUMBER() OVER (ORDER BY [EvaluationDate]) as rn
      ,[EvaluationDate] AS Date
      ,CONVERT( numeric(30,2),SUM([TotalInventoryValuation])) AS Inv_Value
      ,CONVERT( numeric(30,2),SUM([AverageDailySales])) AS Sales
	  ,CONVERT( numeric(30,2), ROUND(SUM([TotalInventoryValuation])/SUM([AverageDailySales]),2)) AS DSO 
  FROM [SygmaODS].[dso].[DSOFactorsHistory]
  WHERE [EvaluationDate] BETWEEN DATEADD(d,-7,@StartDt) AND @EndDt   AND [AverageDailySales] <> 0
  GROUP BY  [EvaluationDate]
)
 SELECT *
   ,DATENAME(dw,date) AS Day
   ,Inv_Value-LAG( Inv_Value,1,0) OVER (ORDER BY date) + Sales AS Receipts
   ,DSO - LAG( DSO,7,0) OVER (ORDER BY date) AS LastWeek_DSO
   ,Inv_Value - LAG(Inv_Value,7,0) OVER (ORDER BY date)  AS [Rcv$ vs LastWeek]
     FROM cte_inv
   ORDER BY [Date]

--Rcv$_vs_LastWeek
--/Will calculate Adjust DSO so a parameter can be user to override the 7 Mil ($7,000,000) Pipeline Inventory Value
 --,CONVERT( numeric(30,2),(Inv_Value+70000) /Sales) AS Adjusted_DSO
