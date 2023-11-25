-- Thay ??i ki?u d? li?u c?a c?t và c?p nh?t giá tr? r?ng thành NULL; thay ??i c?t null thành not null và t?o khóa chính cho nó
ALTER TABLE [dbo].[bill]
ALTER COLUMN master_id VARCHAR(MAX) NULL;

UPDATE [dbo].[bill]
SET master_id = NULL
WHERE master_id = '';

UPDATE [dbo].[bill]
SET [_id] = 'DefaultValue'
WHERE [_id] IS NULL;

ALTER TABLE [dbo].[bill]
ALTER COLUMN [_id] varchar(24) NOT NULL;


ALTER TABLE [dbo].[bill]
ADD CONSTRAINT PK_YourTable PRIMARY KEY ([_id]);


USE [B&B_Platform]
GO
WITH occasion_count as (SELECT b.*
							, o.name as occassion_name
							, m.name as product_name
FROM bill b
LEFT JOIN occasions o
ON b.to_user_occasion_id = o.id
LEFT JOIN masters m
ON b.master_id = m.id
WHERE to_user_occasion_id IS NOT NULL)
SELECT occassion_name
	, product_name
	, COUNT(*) as num_bill
	, SUM([ summary_grand_total ]) as sum_total
	, SUM(summary_discount_money) as sum_dis_total
	, SUM(summary_commission) as sum_com_total
FROM occasion_count
GROUP BY occassion_name, product_name
ORDER BY occassion_name, product_name;


WITH occasion_count as (
SELECT b.*
							, o.name as occassion_name
							, m.name as product_name
FROM bill b
LEFT JOIN occasions o
ON b.to_user_occasion_id = o.id
LEFT JOIN masters m
ON b.master_id = m.id
WHERE to_user_occasion_id IS NOT NULL)
SELECT occassion_name, product_name,
		CAST(SUM(CAST( [ summary_grand_total ] AS bigint)) AS bigint) AS sum_total,
		CAST(SUM(CAST(summary_discount_money AS bigint)) AS bigint) as sum_dis_total,
	    CAST(SUM(CAST([ summary_commission ] AS bigint)) AS bigint) as sum_com_total
FROM occasion_count
GROUP BY occassion_name, product_name
order by occassion_name