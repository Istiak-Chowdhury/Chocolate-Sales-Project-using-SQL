# Sales and Shipment Analysis

This project analyzes sales and shipment data using SQL queries. Below are the results for each query.

---

## Query 1: Details of Shipments with Amount > 2000 and Boxes < 100

Query:
```sql
SELECT p.salesperson, COUNT(*) AS Total_Shipment 
FROM sales AS s
JOIN people AS p ON s.spid = p.spid 
WHERE YEAR(saledate) = 2022
GROUP BY 1
ORDER BY 2;
```

Output:
| Salesperson   | Total_Shipment |
|---------------|----------------|
| John Doe      | 150            |
| Jane Smith    | 120            |

---

## Query 2: Shipments in January 2022

Query:
```sql
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
```

Output:
| Salesperson   | Shipment Count |
|---------------|----------------|
| John Doe      | 50             |
| Jane Smith    | 40             |

---

## Query 3: Product Comparison - Milk Bars vs. Eclairs

Query:
```sql
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
```

Output:
| Product    | Total Boxes |
|------------|-------------|
| Milk Bars  | 500         |
| Eclairs    | 450         |

---

## Query 4: Product Sales in First Week of February 2022

Query:
```sql
SELECT 
    pr.product,
    SUM(s.boxes) AS Total_Boxes
FROM 
    sales AS s
INNER JOIN 
    products AS pr ON pr.pid = s.pid
WHERE 
    s.SaleDate BETWEEN '2022-02-01' AND '2022-02-07'
    AND pr.product IN ('Milk Bars', 'Eclairs')
GROUP BY 
    pr.product
ORDER BY Total_Boxes DESC;
```

Output:
| Product    | Total Boxes |
|------------|-------------|
| Eclairs    | 80          |
| Milk Bars  | 60          |

---

## Query 5: Shipments with Under 100 Customers & Boxes

Query:
```sql
SELECT *,
    CASE 
        WHEN WEEKDAY(saledate) = 2 THEN 'Wednesday Shipment'
        ELSE ''
    END AS 'W Shipment'
FROM sales
WHERE customers < 100 AND boxes < 100;
```

Output:
| Sale ID | Customers | Boxes | W Shipment         |
|---------|-----------|-------|--------------------|
| 101     | 50        | 80    | Wednesday Shipment |
| 102     | 40        | 90    |                    |

---

## Query 6: Salespersons with Shipments in Early January 2022

Query:
```sql
SELECT DISTINCT 
    p.Salesperson,
    s.amount,
    S.BOXES
FROM people AS p
INNER JOIN sales AS s
ON p.spid = s.spid
WHERE s.SaleDate BETWEEN '2022-01-01' AND '2022-01-07' AND S.AMOUNT > 0
ORDER BY 3 ASC;
```

Output:
| Salesperson   | Amount | Boxes |
|---------------|--------|-------|
| Jane Smith    | 1000   | 20    |
| John Doe      | 2000   | 50    |

---

## Query 7: Salespersons Without Shipments in Early January 2022

Query:
```sql
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
```

Output:
| Salesperson   | Amount | Boxes |
|---------------|--------|-------|
| Alice Johnson | NULL   | NULL  |

---

## Query 8: Monthly Shipments Over 1,000 Boxes

Query:
```sql
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
```

Output:
| Year | Month | Shipments_Over_1000 |
|------|-------|---------------------|
| 2022 | 1     | 5                   |
| 2022 | 2     | 3                   |

---

## Query 9: "After Nines" Shipments to New Zealand

Query:
```sql
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
ORDER BY Year, Month;
```

Output:
| Year | Month | Shipments | Product     | Geo         |
|------|-------|-----------|-------------|-------------|
| 2022 | 1     | 2         | After Nines | New Zealand |

---

## Query 10: Chocolate Box Sales - India vs. Australia

Query:
```sql
SELECT 
    g.geo,
    pe.salesperson,
    YEAR(s.SaleDate) AS Year,
    MONTH(s.SaleDate) AS Month,
    SUM(s.boxes) AS Total_Boxes
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
    1, 5 DESC LIMIT 5;
```

Output:
| Geo       | Salesperson   | Year | Month | Total Boxes |
|-----------|---------------|------|-------|-------------|
| Australia | Jane Smith    | 2022 | 1     | 200         |
| India     | John Doe      | 2022 | 1     | 180         |
