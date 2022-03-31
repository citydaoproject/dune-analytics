---
---
--- URL: https://dune.xyz/queries/243161/454776
with transfers as 
    ((SELECT 
    "to" as wallet,
    'mint' as action,
    1 as value
    FROM erc1155."ERC1155_evt_TransferSingle"
    where contract_address = '\x7eef591a6cc0403b9652e98e88476fe1bf31ddeb'
    and "from" = '\x0000000000000000000000000000000000000000')
    
    union all
    
    (SELECT 
    "to" as wallet,
    'gain' as action,
    1 as value
    FROM erc1155."ERC1155_evt_TransferSingle"
    where contract_address = '\x7eef591a6cc0403b9652e98e88476fe1bf31ddeb'
    and "from" != '\x0000000000000000000000000000000000000000')
    
    union all 
    
    (SELECT 
    "from" as wallet,
    'lose' as action,
    -1 as value
    FROM erc1155."ERC1155_evt_TransferSingle"
    where contract_address = '\x7eef591a6cc0403b9652e98e88476fe1bf31ddeb'
    and "from" != '\x0000000000000000000000000000000000000000'))
    
select 
wallet,
sum(value) as "Tokens"
-- concat(round(sum(value)::numeric/20000*100,2),'%') as ownership
from 
transfers
group by wallet
order by "Tokens" desc 
limit 100
