

select * from Customer

select * from Prod_cat_info

select * from Transactions



--Q1 
select 'TBL_Customer' TBL_NAME, count(*)   as No_of_row from [dbo].[Customer]
union all 
select 'TBL_TRANSACTIONS' TBL_NAME,count(*)  as No_of_row from [dbo].Prod_cat_info
union all 
select 'TBL_PRODUCTION' TBL_NAME, count(*)   as No_of_row from[dbo].[Transactions]

--Q2
select count(qty)  AS TOT_TRAN_RETURNS from Transactions 
where 
qty<0

--Q3
SELECT (convert(date,DOB,105)) AS TRAN_DATE FROM customer
SELECT (convert(date,tran_date,105)) AS TRAN_DATE FROM transactions

--Q4
select datediff(YEAR,min(convert(date,tran_date,105)),max(convert(date,tran_date,105))) as year,
datediff(month,min(convert(date,tran_date,105)),max(convert(date,tran_date,105))) as month,
datediff(day,min(convert(date,tran_date,105)),max(convert(date,tran_date,105))) as day 
from Transactions
 
--Q5
select prod_cat,prod_subcat 
from Prod_cat_info
where 
prod_subcat='DIY'                  


 -------------------------------------------------------------------------------
 analysis 

-- Q1
select top 1 store_type, count(*) as tot_channel
from transactions
group by
store_type 
order by
tot_channel desc

--Q2

select gender, count(*) as tot_gen
from Customer
where
gender in ( 'M', 'F')
group by
gender


SELECT SUM(CASE WHEN UPPER(gender) = 'M' THEN 1 ELSE 0 END) AS Male,
SUM(CASE WHEN UPPER(gender) = 'F' THEN 1 ELSE 0 END) AS Female,
SUM(CASE WHEN gender IS NULL  THEN 1 ELSE 0 END) AS 'Not Assigned',
COUNT(customer_id) AS 'Total Employee'  FROM Customer
--Q3
select  top 1 city_code,count(customer_Id) as tot_cust
from customer
group by
city_code
order by 
tot_cust desc

--Q4
select prod_cat,count(prod_subcat)as cnt_sub_cat
from Prod_cat_info
where prod_cat ='books'
group by
prod_cat

--Q5

select top 1 prod_cat, count(Qty) as max_Qty from Prod_cat_info as a  
inner join Transactions as b on a.prod_sub_cat_code=b.prod_subcat_code
where
Qty>0
group by
prod_cat
order by 
count(Qty) desc


--Q6
select  prod_cat,sum(convert(float,total_amt)) as tot_revenue from Transactions as T1  
inner join Prod_cat_info as P1 on T1.prod_cat_code = P1.prod_cat_code
 and T1.prod_subcat_code=P1.prod_sub_cat_code
where prod_cat in ('electronics','books')
group by
prod_cat

--Q7
select cust_id,count(Qty) as [no of trans] from Transactions as T1
inner join Prod_cat_info as P1 on T1.prod_cat_code = P1.prod_cat_code
 and T1.prod_subcat_code=P1.prod_sub_cat_code
where qty>0
group by 
cust_id
having
count(Qty)>10
	
--Q8  
select prod_cat, store_type,round(sum(cast(total_amt as float)),2) as rev_amt from Transactions as T1
inner join Prod_cat_info as P1 on T1.prod_cat_code = P1.prod_cat_code
 and T1.prod_subcat_code=P1.prod_sub_cat_code
where prod_cat in ('electronics','clothing') and store_type ='flagship store'
group by
prod_cat,store_type

--Q9
select Prod_cat,prod_subcat,gender,sum(cast(total_amt as float)) as rev_amt from Transactions as T1
inner join customer AS T2 on T1.cust_id=T2.customer_Id
inner join Prod_cat_info AS T3 ON T1.prod_cat_code=T3.prod_cat_code
and T1.prod_subcat_code=T3.prod_sub_cat_code
WHERE 
PROD_CAT = 'ELECTRONICS' and gender='M'
group by
PROD_CAT,gender,prod_subcat


--Q10
 select top 5
     P.prod_subcat [Subcategory] ,
      Round(SUM(cast( case when T.Qty > 0 then T.Qty else 0 end as float)),2)[Sales]  , 
     Round(SUM(cast( case when T.Qty < 0 then T.Qty   else 0 end as float)),2) [Returns] ,
    Round(SUM(cast( case when T.Qty > 0 then T.Qty else 0 end as float)),2)
                 - Round(SUM(cast( case when T.Qty < 0 then T.Qty   else 0 end as float)),2)[total_qty],
    ((Round(SUM(cast( case when T.Qty < 0 then T.Qty  else 0 end as float)),2))/
                  (Round(SUM(cast( case when T.Qty > 0 then T.Qty else 0 end as float)),2)
                 - Round(SUM(cast( case when T.Qty < 0 then T.Qty   else 0 end as float)),2)))*100[%_Returs],
    ((Round(SUM(cast( case when T.Qty > 0 then T.Qty  else 0 end as float)),2))/
                  (Round(SUM(cast( case when T.Qty > 0 then T.Qty else 0 end as float)),2)
                 - Round(SUM(cast( case when T.Qty < 0 then T.Qty   else 0 end as float)),2)))*100[%_sales]
    from Transactions as T
    INNER JOIN prod_cat_info as P ON T.prod_subcat_code = P.prod_sub_cat_code
    group by P.prod_subcat
    order by [%_sales] desc

--Q11 

SELECT ROUND(SUM(CAST(TOTAL_AMT AS FLOAT)),2) NET_TOT_REVENUE FROM Transactions as T1
inner join customer AS T2 on T1.cust_id=T2.customer_Id
inner join Prod_cat_info AS T3 ON T1.prod_cat_code=T3.prod_cat_code
and T1.prod_subcat_code=T3.prod_sub_cat_code
WHERE
DATEDIFF(YEAR,CONVERT(date,DOB,105), GETDATE()) BETWEEN 25 AND 35
AND
CONVERT(date,tran_date,105) BETWEEN (SELECT DATEADD(DAY,-30,MAX(CONVERT(date,tran_date,105))) FROM Transactions) 
AND 
(SELECT MAX(CONVERT(date,tran_date,105)) FROM Transactions)

--Q12 
SELECT TOP 1 prod_cat, SUM(CAST(TOTAL_AMT AS FLOAT)) AS NET_RETRN FROM Transactions as T1
inner join customer AS T2 on T1.cust_id=T2.customer_Id
inner join Prod_cat_info AS T3 ON T1.prod_cat_code=T3.prod_cat_code
and T1.prod_subcat_code=T3.prod_sub_cat_code
WHERE
CAST(TOTAL_AMT AS FLOAT) < 0 
AND CONVERT(date,tran_date,105) BETWEEN (SELECT DATEADD(MONTH,-3,MAX(CONVERT(date,tran_date,105))) FROM Transactions) 
AND (SELECT MAX(CONVERT(date,tran_date,105)) FROM Transactions)
GROUP BY
prod_cat
ORDER BY
NET_RETRN

--Q13
select top 1  store_type,round(sum(cast(total_amt as float)),2) as sum_sale,count(qty) as tot_qty from Transactions as T1
inner join Prod_cat_info AS T2 ON T1.prod_cat_code=T2.prod_cat_code
and T1.prod_subcat_code=T2.prod_sub_cat_code
group by
store_type
order by
 tot_qty desc,sum_sale desc 
 


 --Q14
select prod_cat, avg(CAST(TOTAL_AMT AS float)) as fn_avg from Transactions as T1
inner join Prod_cat_info AS T2 ON T1.prod_cat_code=T2.prod_cat_code
and T1.prod_subcat_code=T2.prod_sub_cat_code
where total_amt>(select avg(cast(total_amt as float)) from transactions)
group by 
prod_cat


--Q15

SELECT top 5 prod_subcat, ROUND(AVG(CAST(TOTAL_AMT AS FLOAT)),2) AS AVRG_SALES, 
ROUND(SUM(CAST(TOTAL_AMT AS FLOAT)),2) AS TOT_SALES FROM Transactions as T1
INNER JOIN prod_cat_info as T2 ON T1.prod_subcat_code = T2.prod_sub_cat_code
AND T1.prod_cat_code = T2.prod_cat_code
WHERE prod_cat IN (SELECT TOP 5 prod_cat FROM TRANSACTIONS 
INNER JOIN prod_cat_info ON Transactions.prod_cat_code = prod_cat_info.prod_cat_code
WHERE QTY > 0 
GROUP BY prod_cat
ORDER BY 
COUNT(QTY)  DESC)
GROUP BY prod_subcat
ORDER BY TOT_SALES DESC, AVRG_SALES DESC

