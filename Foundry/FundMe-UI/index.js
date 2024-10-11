import { ethers } from "./ethers-6.7.esm.min.js"
import { abi, contractAddress } from "./constants.js"

const connectButton = document.getElementById("connectButton")
const withdrawButton = document.getElementById("withdrawButton")
const fundButton = document.getElementById("fundButton")
const balanceButton = document.getElementById("balanceButton")
const accountInfo = document.getElementById("accountInfo")
const walletBalance = document.getElementById("walletBalance")
const contractBalance = document.getElementById("contractBalance")
const transactionStatus = document.getElementById("transactionStatus")
const errorMessage = document.getElementById("errorMessage")

connectButton.onclick = connect
withdrawButton.onclick = withdraw
fundButton.onclick = fund
balanceButton.onclick = getBalance

async function connect() {
  if (typeof window.ethereum !== "undefined") {
    try {
      await ethereum.request({ method: "eth_requestAccounts" })
      connectButton.innerHTML = "Connected"
      const accounts = await ethereum.request({ method: "eth_accounts" })
      accountInfo.innerHTML = `Connected Wallet: ${accounts[0]}`
      await updateWalletBalance(accounts[0])
    } catch (error) {
      console.error(error)
      errorMessage.innerHTML = `Error: ${error.message}`
    }
  } else {
    connectButton.innerHTML = "Please install MetaMask"
    errorMessage.innerHTML = "MetaMask is not installed"
  }
}

async function updateWalletBalance(address) {
  const provider = new ethers.BrowserProvider(window.ethereum)
  const balance = await provider.getBalance(address)
  walletBalance.innerHTML = `Wallet Balance: ${ethers.formatEther(balance)} ETH`
}

async function withdraw() {
  errorMessage.innerHTML = ""
  transactionStatus.innerHTML = ""
  if (typeof window.ethereum !== "undefined") {
    const provider = new ethers.BrowserProvider(window.ethereum)
    await provider.send("eth_requestAccounts", [])
    const signer = await provider.getSigner()
    const contract = new ethers.Contract(contractAddress, abi, signer)
    const owner = await contract.get_owner();
    const signer_address = await signer.getAddress();

    try {
      console.log("owner address", owner);
      console.log("signer address", signer.getAddress());

      if (owner !== signer_address) {
        errorMessage.innerHTML = "You are not the owner of this contract. Cannot withdraw";
        return
      }
    } catch (error) {
      console.log("owner error");
    }

    try {
      const transactionResponse = await contract.withdraw()
      transactionStatus.innerHTML = "Transaction Sent: Waiting for confirmation..."
      await transactionResponse.wait(1)
      transactionStatus.innerHTML = "Withdrawal successful!"
    } catch (error) {
      errorMessage.innerHTML = `Error: ${error.message}`
    }
  } else {
    withdrawButton.innerHTML = "Please install MetaMask"
  }
}

async function fund() {
  const ethAmount = document.getElementById("ethAmount").value
  errorMessage.innerHTML = ""
  transactionStatus.innerHTML = ""
  if (ethAmount === "" || isNaN(ethAmount)) {
    errorMessage.innerHTML = "Please enter a valid ETH amount"
    return
  }
  if (typeof window.ethereum !== "undefined") {
    const provider = new ethers.BrowserProvider(window.ethereum)
    await provider.send("eth_requestAccounts", [])
    const signer = await provider.getSigner()
    const contract = new ethers.Contract(contractAddress, abi, signer)
    try {
      const transactionResponse = await contract.fund({
        value: ethers.parseEther(ethAmount),
      })
      transactionStatus.innerHTML = "Funding transaction sent..."
      await transactionResponse.wait(1)
      transactionStatus.innerHTML = "Funding successful!"
    } catch (error) {
      errorMessage.innerHTML = `Error: ${error.message}`
    }
  } else {
    fundButton.innerHTML = "Please install MetaMask"
  }
}

async function getBalance() {
  if (typeof window.ethereum !== "undefined") {
    const provider = new ethers.BrowserProvider(window.ethereum)
    try {
      const balance = await provider.getBalance(contractAddress)
      contractBalance.innerHTML = `Contract Balance: ${ethers.formatEther(balance)} ETH`
    } catch (error) {
      errorMessage.innerHTML = `Error: ${error.message}`
    }
  } else {
    balanceButton.innerHTML = "Please install MetaMask"
  }
}
