import React, { Component } from "react";
import getWeb3, { getGanacheWeb3, Web3 } from "../../utils/getWeb3";

import App from "../../App.js";

import { Typography, Grid, TextField } from '@material-ui/core';
import { ThemeProvider } from '@material-ui/styles';
import { theme } from '../../utils/theme';
import { Loader, Button, Card, Input, Heading, Table, Form, Flex, Box, Image, EthAddress } from 'rimble-ui';
import { zeppelinSolidityHotLoaderOptions } from '../../../config/webpack';

import styles from '../../App.module.scss';
//import './App.css';




export default class NewBancorPool extends Component {
  constructor(props) {    
    super(props);

    this.state = {
      /////// Default state
      storageValue: 0,
      web3: null,
      accounts: null,
      route: window.location.pathname.replace("/", "")
    };

    this.getTestData = this.getTestData.bind(this);
  }


  getTestData = async () => {
    const { accounts, new_bancor_pool, web3 } = this.state;

    const response_1 = await new_bancor_pool.methods.testFunc().send({ from: accounts[0] })
    console.log('=== response of testFunc() function ===', response_1);
  }


  testFuncCallBancorNetworkContractAddr = async () => {
    const { accounts, new_bancor_pool, web3 } = this.state;

    const response_1 = await new_bancor_pool.methods.testFuncCallBancorNetworkContractAddr().call()
    console.log('=== response of testFuncCallBancorNetworkContractAddr() function ===', response_1); 
  }

  integratePoolWithLendingProtocol = async () => {
    const { accounts, new_bancor_pool, web3 } = this.state;

    const _contractName1 = '0x62bd9D98d4E188e281D7B78e29334969bbE1053c'
    //string _contractName2,
    const receiverAddr = '0x718E3ea0B8C2911C5e54Cb4b9B2075fdd87B55a7'
    const amountOfSmartToken = 100

    const response_1 = await new_bancor_pool.methods.integratePoolWithLendingProtocol(_contractName1, receiverAddr, amountOfSmartToken).send({ from: accounts[0] })
    console.log('=== response of integratePoolWithLendingProtocol() function ===', response_1);  
  }



  //////////////////////////////////// 
  ///// Refresh Values
  ////////////////////////////////////
  refreshValues = (instanceNewBancorPool) => {
    if (instanceNewBancorPool) {
      console.log('refreshValues of instanceNewBancorPool');
    }
  }


  //////////////////////////////////// 
  ///// Ganache
  ////////////////////////////////////
  getGanacheAddresses = async () => {
    if (!this.ganacheProvider) {
      this.ganacheProvider = getGanacheWeb3();
    }
    if (this.ganacheProvider) {
      return await this.ganacheProvider.eth.getAccounts();
    }
    return [];
  }

  componentDidMount = async () => {
    const hotLoaderDisabled = zeppelinSolidityHotLoaderOptions.disabled;
 
    let NewBancorPool = {};
    try {
      NewBancorPool = require("../../../../build/contracts/NewBancorPool.json"); // Load ABI of contract of NewBancorPool
    } catch (e) {
      console.log(e);
    }

    try {
      const isProd = process.env.NODE_ENV === 'production';
      if (!isProd) {
        // Get network provider and web3 instance.
        const web3 = await getWeb3();
        let ganacheAccounts = [];

        try {
          ganacheAccounts = await this.getGanacheAddresses();
        } catch (e) {
          console.log('Ganache is not running');
        }

        // Use web3 to get the user's accounts.
        const accounts = await web3.eth.getAccounts();
        // Get the contract instance.
        const networkId = await web3.eth.net.getId();
        const networkType = await web3.eth.net.getNetworkType();
        const isMetaMask = web3.currentProvider.isMetaMask;
        let balance = accounts.length > 0 ? await web3.eth.getBalance(accounts[0]): web3.utils.toWei('0');
        balance = web3.utils.fromWei(balance, 'ether');

        let instanceNewBancorPool = null;
        let deployedNetwork = null;

        // Create instance of contracts
        if (NewBancorPool.networks) {
          deployedNetwork = NewBancorPool.networks[networkId.toString()];
          if (deployedNetwork) {
            instanceNewBancorPool = new web3.eth.Contract(
              NewBancorPool.abi,
              deployedNetwork && deployedNetwork.address,
            );
            console.log('=== instanceNewBancorPool ===', instanceNewBancorPool);
          }
        }

        if (NewBancorPool) {
          // Set web3, accounts, and contract to the state, and then proceed with an
          // example of interacting with the contract's methods.
          this.setState({ 
            web3, 
            ganacheAccounts, 
            accounts, 
            balance, 
            networkId, 
            networkType, 
            hotLoaderDisabled,
            isMetaMask, 
            new_bancor_pool: instanceNewBancorPool
          }, () => {
            this.refreshValues(
              instanceNewBancorPool
            );
            setInterval(() => {
              this.refreshValues(instanceNewBancorPool);
            }, 5000);
          });
        }
        else {
          this.setState({ web3, ganacheAccounts, accounts, balance, networkId, networkType, hotLoaderDisabled, isMetaMask });
        }
      }
    } catch (error) {
      // Catch any errors for any of the above operations.
      alert(
        `Failed to load web3, accounts, or contract. Check console for details.`,
      );
      console.error(error);
    }
  }



  render() {
    return (

      <div className={styles.widgets}>
        <Grid container style={{ marginTop: 32 }}>

          <Grid item xs={4}>

            <Card width={"auto"} 
                  maxWidth={"420px"} 
                  mx={"auto"} 
                  my={5} 
                  p={20} 
                  borderColor={"#E8E8E8"}
            >
              <h4>New Bancor Pool</h4>

              <Image
                alt="random unsplash image"
                borderRadius={8}
                height="100%"
                maxWidth='100%'
                src="https://source.unsplash.com/random/1280x720"
              />

              <Button size={'small'} mt={3} mb={2} onClick={this.getTestData}> Get TestData </Button> <br />

              <Button size={'small'} mt={3} mb={2} onClick={this.testFuncCallBancorNetworkContractAddr}> testFuncCallBancorNetworkContractAddr </Button> <br />

              <Button size={'small'} mt={3} mb={2} onClick={this.integratePoolWithLendingProtocol}> Integrate Pool with Lending Protocol </Button> <br />
            </Card>
          </Grid>

          <Grid item xs={4}>
          </Grid>

          <Grid item xs={4}>
          </Grid>
        </Grid>
      </div>
    );
  }

}
