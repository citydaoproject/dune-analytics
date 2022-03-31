---
---
--- URL: https://dune.xyz/queries/242931/454383
with days AS
    (SELECT generate_series('2021-11-03'::TIMESTAMP, date_trunc('day', NOW()), '1 day') AS DAY),

sales_data as 
    (select 
    date_trunc('day',evt_block_time) as day,
    sum(price/1e18) as price_eth,
    -count(distinct maker) as unique_sellers,
    count(distinct taker) as unique_buyers
    FROM opensea."WyvernExchange_evt_OrdersMatched"
    where opensea."WyvernExchange_evt_OrdersMatched".evt_tx_hash in 
        (select 
        call_tx_hash
        FROM opensea."WyvernExchange_call_atomicMatch_"
        LEFT JOIN erc721."ERC721_evt_Transfer" nft ON nft.evt_tx_hash = call_tx_hash
        WHERE (addrs[5] = '\x7eef591a6cc0403b9652e98e88476fe1bf31ddeb')
        and call_success is true)
    group by day)
    
select 
days.day,
sales_data.price_eth,
unique_sellers,
unique_buyers
from 
days 
left join sales_data on days.day = sales_data.day