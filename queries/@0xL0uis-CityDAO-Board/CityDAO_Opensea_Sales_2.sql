---
---
--- URL: https://dune.xyz/queries/242752/454031
select 
    evt_block_time,
    price/1e18 as price,
    maker as seller,
    taker as buyer, 
    metadata as metadata,
    evt_block_number as evt_block_number
    FROM opensea."WyvernExchange_evt_OrdersMatched"
    where opensea."WyvernExchange_evt_OrdersMatched".evt_tx_hash in 
        (select 
        call_tx_hash
        FROM opensea."WyvernExchange_call_atomicMatch_"
        WHERE addrs[5] = '\x7eef591a6cc0403b9652e98e88476fe1bf31ddeb' 
        
        and call_success is true)
    order by evt_block_number desc;
    
