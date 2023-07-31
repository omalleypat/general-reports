WITH RECURSIVE rentalcategories(categid, categname, parentid) AS 
(SELECT a.categid, a.categname, a.parentid FROM category_v1 a WHERE categid = 26 
UNION ALL 
SELECT c.categid, r.categname || ':' || c.categname, c.parentid 
FROM rentalcategories r, category_v1 c 
WHERE r.categid = c.parentid) 

SELECT ID, TransactionType, Date, Category, Subcategory, Amount, AccountName, ToAccountName, Splitted, Payee, TransactionNumber, Status, Notes 
FROM alldata 
WHERE CATEGID in (SELECT categid FROM rentalcategories)
ORDER BY Date