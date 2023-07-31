WITH RECURSIVE rentalcategories(categid, categname, parentid) AS 
(SELECT a.categid, a.categname, a.parentid FROM category_v1 a WHERE parentid = 26 
UNION ALL 
SELECT c.categid, r.categname || ':' || c.categname, c.parentid 
FROM rentalcategories r, category_v1 c 
WHERE r.categid = c.parentid) 

SELECT * FROM alldata WHERE CATEGID in (SELECT categid FROM rentalcategories) AND AccountID is not 17