---
---
--- URL: https://dune.xyz/queries/243188/454830
with agg as 
    (with transfers as 
        ((SELECT 
        "to" as wallet,
        "tokenId" as token_id,
        'mint' as action,
        1 as value
        FROM erc721."ERC721_evt_Transfer"
        where contract_address = '\xbc4ca0eda7647a8ab7c2061c2e118a18a936f13d'
        and "from" = '\x0000000000000000000000000000000000000000')
        
        union all
        
        (SELECT 
        "to" as wallet,
        "tokenId" as token_id,
        'gain' as action,
        1 as value
        FROM erc721."ERC721_evt_Transfer"
        where contract_address = '\xbc4ca0eda7647a8ab7c2061c2e118a18a936f13d'
        and "from" != '\x0000000000000000000000000000000000000000')
        
        union all 
        
        (SELECT 
        "from" as wallet,
        "tokenId" as token_id,
        'lose' as action,
        -1 as value
        FROM erc721."ERC721_evt_Transfer"
        where contract_address = '\xbc4ca0eda7647a8ab7c2061c2e118a18a936f13d'
        and "from" != '\x0000000000000000000000000000000000000000')
        
        union all
        (SELECT 
        "from" as wallet,
        "tokenId" as token_id,
        'burn' as action,
        -1 as value
        FROM erc721."ERC721_evt_Transfer"
        where contract_address = '\xbc4ca0eda7647a8ab7c2061c2e118a18a936f13d'
        and "to" = '\x0000000000000000000000000000000000000000')
        )
        
    select 
    wallet,
    sum(value) as num_apes
    from 
    transfers
    group by wallet
    order by num_apes desc),

ts_agg as 
    (with transfers as 
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
        and "from" != '\x0000000000000000000000000000000000000000')
        
        union all
        (SELECT 
        "from" as wallet,
        'burn' as action,
        -1 as value
        FROM erc1155."ERC1155_evt_TransferSingle"
        where contract_address = '\x7eef591a6cc0403b9652e98e88476fe1bf31ddeb'
        and "to" = '\x0000000000000000000000000000000000000000')
        )
        
    select 
    wallet,
    sum(value) as num_ts
    from 
    transfers
    group by wallet
    order by num_ts desc)


SELECT 
count(agg.wallet) as wallets_holding_both
FROM ts_agg
inner join agg on agg.wallet = ts_agg.wallet 
where num_apes > 0 and num_ts > 0 