---
---
--- URL: https://dune.xyz/queries/242696/453949
select 
date_trunc('hour',block_time) as timespan,
count(*)
from 
nft.trades 
where original_currency = 'ETH'
and nft_contract_address = ('\x7eef591a6cc0403b9652e98e88476fe1bf31ddeb')::bytea
group by timespan 
order by timespan desc;
