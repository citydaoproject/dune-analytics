---
---
--- URL: https://dune.xyz/queries/242760/454047
SELECT
    DATE_TRUNC('hour', evt_block_time) AS "hour",
    ROUND((PERCENTILE_CONT(.05) WITHIN GROUP (ORDER BY price / 1e18))::numeric, 3) AS "approx_floor"
FROM opensea."WyvernExchange_evt_OrdersMatched"
WHERE evt_tx_hash IN (
    SELECT call_tx_hash
    FROM opensea."WyvernExchange_call_atomicMatch_"
    WHERE addrs[5] = '\x7eef591a6cc0403b9652e98e88476fe1bf31ddeb'
        AND call_success is true
)
AND evt_block_time > '2021-11-11'
GROUP BY "hour"
ORDER BY "hour" DESC