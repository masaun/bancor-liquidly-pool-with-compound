# Bancor Liquidly Pool with Compound

***
## 【Introduction of Bancor Liquidly Pool with Compound】
- This is the "Bancor Liquidly Pool with Compound".
- This is one of system of "new bancor pool design" that integrate Compound (cToken) with Bancor Pool by using bancor and compound protocol.
- I try to integrate Compound with Bancor Pool
  - Both of token (cToken and BNT) are conbined and published as `SmartToken`  (i.e. `cDAIBNT` )
  - Currently, I have implemented them on ropsten 

&nbsp;


***

## 【Setup for testing system behavior in frontend】
### Setup wallet by using Metamask
1. Add MetaMask to browser (Chrome or FireFox or Opera or Brave)    
https://metamask.io/  


2. Adjust appropriate newwork below 
```
Ropsten Test Network
```

&nbsp;


### Setup backend
1. Deploy contracts to Ropsten Test Network
```
(root directory)

$ npm run migrate:ropsten
```

&nbsp;


### Setup frontend
1. Execute command below in root directory.
```

$ npm run client
```

2. Access to browser by using link 
```
http://127.0.0.1:3000
```

&nbsp;

***


## 【Work flow】

&nbsp;

***

## 【References】  
- Gitcoin / Sustain Web3  
  - Bancor Challenge 2 — New Liquidity Pool Designs  
    https://gitcoin.co/issue/bancorprotocol/contracts/337/3948  

- Document of bancor protocol    
  - How to Create a Bancor Liquidity Pool
    https://docs.bancor.network/user-guides/token-integration/how-to-create-a-bancor-liquidity-pool    
  - ContractAddress on Ropsten Network  
    https://support.bancor.network/hc/en-us/articles/360010410399-Ethereum-Ropsten-Network- 
  - ContractAddress（Called by `addressOf()` ）
    https://docs.bancor.network/user-guides/network-data-and-stats/ethereum-contract-addresses

- Document of compound protocol
  - ContractAddress of cToken on Ropsten 
    https://compound.finance/developers

- Github of bancor protocol 
  - Bancor Protocol Contracts v0.5 (beta)  
    https://github.com/bancorprotocol/contracts  

- Reference dApp
  - Co-Trader：https://bancor.cotrader.com/#/pool
  - Zerion (Invest tab): https://app.zerion.io
