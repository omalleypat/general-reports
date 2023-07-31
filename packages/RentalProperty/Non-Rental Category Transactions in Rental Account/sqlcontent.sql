WITH RECURSIVE rentalcategories(categid, categname, parentid) AS 
(SELECT a.categid, a.categname, a.parentid FROM category_v1 a WHERE categid = 26 
UNION ALL 
SELECT c.categid, r.categname || ':' || c.categname, c.parentid 
FROM rentalcategories r, category_v1 c 
WHERE r.categid = c.parentid) 
SELECT * FROM alldata WHERE ACCOUNTID is 17 AND CATEGID NOT in (SELECT categid FROM rentalcategories) AND TransactionType IS NOT "Transfer"