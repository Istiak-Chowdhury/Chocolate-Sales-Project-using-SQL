use `awesome chocolates`;

-- Q1. Print details of shipments (sales) where amounts are > 2,000 and boxes are <100? --
select p.salesperson, count(*) as Total_Shipment 
from sales as s
join people as p on s.spid = p.spid 
where year(saledate) = 2022
group by 1
order by 2;


-- Q2. How many shipments (sales) each of the sales persons had in the month of January 2022? --
SELECT 
    p.Salesperson, 
    COUNT(*) AS "Shipment Count"
FROM 
    sales s
JOIN 
    people p 
ON 
    s.spid = p.spid
WHERE 
    s.SaleDate BETWEEN '2022-01-01' AND '2022-01-31'
GROUP BY 
    p.Salesperson;
    
-- Q3. Which product sells more boxes? Milk Bars or Eclairs? --
SELECT 
    pr.product,
    SUM(s.boxes) AS total_boxes
FROM 
    sales AS s
INNER JOIN 
    products AS pr 
ON 
    pr.pid = s.pid
WHERE 
    pr.product IN ('Milk Bars', 'Eclairs')
GROUP BY 
    pr.product
ORDER BY 
    total_boxes DESC;

-- Q4. Which product sold more boxes in the first 7 days of February 2022? Milk Bars or Eclairs? --
select 
pr.product,
sum(s.boxes) as Total_Boxes
from sales as s
inner join products as pr on pr.pid = s.pid
where 
	s.SaleDate BETWEEN '2022-02-01' AND '2022-02-7'
		AND
    pr.product IN ('Milk Bars', 'Eclairs')
group by pr.product
ORDER BY total_boxes DESC;


-- Q5. Which shipments had under 100 customers & under 100 boxes? Did any of them occur on Wednesday? --
SELECT *,
    CASE 
        WHEN WEEKDAY(saledate) = 2 THEN 'Wednesday Shipment'
        ELSE ''
    END AS 'W Shipment'
FROM sales
WHERE customers < 100 AND boxes < 100;



-- Q6. What are the names of salespersons who had at least one shipment (sale) in the first 7 days of January 2022? --
SELECT DISTINCT 
	p.Salesperson,
	s.amount,
    S.BOXES
FROM people AS p
INNER JOIN sales AS s
ON p.spid = s.spid
WHERE s.SaleDate BETWEEN '2022-01-01' AND '2022-01-07' AND S.AMOUNT > 0
ORDER BY 3 ASC;



-- Q7. Which salespersons did not make any shipments in the first 7 days of January 2022? --
SELECT 
    p.Salesperson,
    s.amount,
    s.boxes
FROM 
    people AS p
LEFT JOIN 
    sales AS s
ON 
    p.spid = s.spid AND s.SaleDate BETWEEN '2022-01-01' AND '2022-01-07'
WHERE 
    s.spid IS NULL;


-- Q8. How many times we shipped more than 1,000 boxes in each month?--
SELECT 
    YEAR(SaleDate) AS Year,
    MONTH(SaleDate) AS Month,
    COUNT(*) AS Shipments_Over_1000
FROM 
    sales
WHERE 
    boxes > 1000
GROUP BY 
    YEAR(SaleDate), MONTH(SaleDate)
ORDER BY 
    YEAR;


-- Q9. Did we ship at least one box of ‘After Nines’ to ‘New Zealand’ on all the months? --
SELECT 
    YEAR(SaleDate) AS Year,
    MONTH(SaleDate) AS Month,
    COUNT(*) AS Shipments,
    p.product,
    g.geo
FROM 
    sales AS s
INNER JOIN products AS p ON s.pid = p.pid
INNER JOIN geo AS g ON s.GeoID = g.GeoID
WHERE 
    p.product = 'After Nines' 
    AND g.geo = 'New Zealand'
GROUP BY 
    YEAR(SaleDate), MONTH(SaleDate)
HAVING COUNT(*) > 0
order by year, month;


-- Q10. India or Australia? Who buys more chocolate boxes on a monthly basis? --
SELECT 
    g.geo,
    pe.salesperson,
    YEAR(s.SaleDate) AS Year,
    MONTH(s.SaleDate) AS Month,
    sum(s.boxes) AS Total_Boxes
FROM 
    sales AS s
INNER JOIN products AS p ON s.pid = p.pid
INNER JOIN people AS pe ON s.spid = pe.spid
INNER JOIN geo AS g ON s.geoid = g.geoid
WHERE 
	g.geo IN ('India','Australia')
GROUP BY 
	g.geo, YEAR(s.SaleDate), MONTH(s.SaleDate), pe.salesperson
ORDER BY 
	1,5 desc limit 5;
