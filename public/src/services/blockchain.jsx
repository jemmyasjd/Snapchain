
import snapchain from '../abis/src/contracts/SnapChain.sol/ChatApp.json'
import { getGlobalState, setGlobalState } from '../store'
import { ethers } from 'ethers'
import { stringify } from 'uuid'    

import { ChechIfWalletConnected, connectWallet, connectingWithContract } from '../utils/APIRoutes'

const { ethereum } = window
const contractAddress = "0xc6a06CB941140f06f390Bc7Da6EB20b2d978E343"
const contractAbi = snapchain.abi

const connectwallet = async () => {
  try {
    const accounts = await ethereum.request({ method: 'eth_requestAccounts' })
    setGlobalState('connectedAccount', accounts[0]?.toLowerCase())
  } catch (error) {
    console.log(error);
  }
}

const sendMessage = async () => {
    try {
      
      const provider = new ethers.providers.JsonRpcProvider(
        "https://rpc-mumbai.maticvigil.com/"
      );
      let network = await provider.getNetwork()
      console.log("provider.getNetwork: ", network)
      
      // const signer=process.env.SIGNER;
      const signer = "1d520c32fee36f054f8c041304b460c9dfc78c14f61a0f76634f859aeead123a";
      // console.log("signer:", signer)
      
      let wallet = new ethers.Wallet(signer, provider);
      console.log("console here");
      let walletSigner = wallet.connect(provider);

      const contractOp = new ethers.Contract(
        "0xc6a06CB941140f06f390Bc7Da6EB20b2d978E343",
        snapchain.abi,
        walletSigner
      );

      const addMessage = await contractOp.sendMessage( "0x65D6f89eF6B02a61D42d8841e3F147F5032EeC9c" , "Hi");
      await addMessage.wait();
      window.location.reload();
    } catch (error) {
      console.log("error:", error);
    }
  };

export {
    connectwallet,
    connectWallet,
    sendMessage,
  }