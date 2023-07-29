SELECT Date, Subcategory, Amount, Notes FROM alldata
WHERE CATEGID IS 26
  AND (Subcategory IS 'Plumbing' OR Subcategory IS  'General Repair')
  AND Year IS 2021

ORDER BY Date;