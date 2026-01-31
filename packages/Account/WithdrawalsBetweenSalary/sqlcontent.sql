WITH base_tx AS (

    /* =========
       Non-split transactions
       ========= */
    SELECT
        c.TRANSID,
        date(c.TRANSDate) AS trans_date,
        ABS(c.TRANSAMOUNT) AS amount,
        c.TRANSCODE,
        c.ACCOUNTID,
        c.TOACCOUNTID,
        c.CATEGID,
        c.PAYEEID,
        c.NOTES
    FROM CHECKINGACCOUNT_V1 c
    WHERE c.STATUS NOT IN ('V','D')
      AND (
            c.ACCOUNTID = 44
         OR c.TOACCOUNTID = 44
      )
      AND c.TRANSID NOT IN (
          SELECT DISTINCT TRANSID FROM SPLITTRANSACTIONS_V1
      )

    UNION ALL

    /* =========
       Split transactions (expanded)
       ========= */
    SELECT
        c.TRANSID,
        date(c.TRANSDate) AS trans_date,
        ABS(s.SPLITTRANSAMOUNT) AS amount,
        c.TRANSCODE,
        c.ACCOUNTID,
        c.TOACCOUNTID,
        s.CATEGID,
        c.PAYEEID,
        c.NOTES
    FROM CHECKINGACCOUNT_V1 c
    JOIN SPLITTRANSACTIONS_V1 s
      ON s.TRANSID = c.TRANSID
    WHERE c.STATUS NOT IN ('V','D')
      AND (
            c.ACCOUNTID = 44
         OR c.TOACCOUNTID = 44
      )
)

SELECT
    TRANSID,
    trans_date,
    amount,
    TRANSCODE,
    ACCOUNTID,
    TOACCOUNTID,
    CATEGID,
    PAYEEID,
    NOTES
FROM base_tx
ORDER BY trans_date, TRANSID;
