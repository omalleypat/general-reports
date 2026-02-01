WITH RECURSIVE subcats AS (
    SELECT CATEGID
    FROM CATEGORY_V1
    WHERE CATEGID = 18   -- Donations

    UNION ALL
    SELECT c.CATEGID
    FROM CATEGORY_V1 c
    JOIN subcats p ON c.PARENTID = p.CATEGID
),

tx AS (
    SELECT
        p.PAYEENAME AS Payee,
        CAST(strftime('%Y', t.TRANSDATE) AS INTEGER) AS Yr,
        CASE
            WHEN s.SPLITTRANSAMOUNT IS NOT NULL THEN s.SPLITTRANSAMOUNT
            ELSE t.TRANSAMOUNT
        END AS Amount
    FROM CHECKINGACCOUNT_V1 t
    LEFT JOIN SPLITTRANSACTIONS_V1 s
           ON s.TRANSID = t.TRANSID
    LEFT JOIN PAYEE_V1 p
           ON p.PAYEEID = t.PAYEEID
    JOIN subcats sc
         ON sc.CATEGID = COALESCE(s.CATEGID, t.CATEGID)
    WHERE t.STATUS <> 'V'
),


pivot AS (
    SELECT
        Payee,

        SUM(CASE WHEN Yr = 2026 THEN Amount ELSE 0 END) AS Y1,
        SUM(CASE WHEN Yr = 2025 THEN Amount ELSE 0 END) AS Y2,
        SUM(CASE WHEN Yr = 2024 THEN Amount ELSE 0 END) AS Y3,
        SUM(CASE WHEN Yr = 2023 THEN Amount ELSE 0 END) AS Y4,
        SUM(CASE WHEN Yr = 2022 THEN Amount ELSE 0 END) AS Y5,

        SUM(Amount) AS TOTAL
    FROM tx
    GROUP BY Payee
    ORDER BY Payee
)

SELECT * FROM pivot

UNION ALL

SELECT
    'TOTAL' AS Payee,
    SUM(Y1), SUM(Y2), SUM(Y3), SUM(Y4), SUM(Y5),
    SUM(TOTAL)
FROM pivot
