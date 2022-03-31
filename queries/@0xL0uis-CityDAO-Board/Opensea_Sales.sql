---
---
--- URL: https://dune.xyz/queries/242881/454282
SELECT
    min(price/1e18),
    percentile_disc(0.25) within GROUP (
        ORDER BY price/1e18
    ) AS "25th",
    percentile_disc(0.50) within GROUP (
        ORDER BY price/1e18
    ) AS "Median",
    avg(price/1e18),
    percentile_disc(0.75) within GROUP (
        ORDER BY price/1e18
        ) AS "75th",
    max(price/1e18),
    sum(price/1e18) AS ETH,
    count(evt_tx_hash) AS sales,
    sum(price/1e18) filter (WHERE (now() - evt_block_time) <= interval '24 hours') AS vol_24,
    count(evt_tx_hash) filter (WHERE (now() - evt_block_time) <= interval '24 hours') AS sales_24,
    sum(price/1e18) filter (WHERE (now() - evt_block_time) <= interval '1 week') AS vol_7d,
    count(evt_tx_hash) filter (WHERE (now() - evt_block_time) <= interval '1 week') AS sales_7d
FROM opensea."WyvernExchange_evt_OrdersMatched" om
INNER JOIN opensea."WyvernExchange_call_atomicMatch_" a 
ON a.call_tx_hash = om.evt_tx_hash
INNER JOIN erc20.tokens erc ON a.addrs[7] = erc.contract_address
AND a.addrs[5] = '\x7eef591a6cc0403b9652e98e88476fe1bf31ddeb'
AND price > 0
AND price < 5.5e18