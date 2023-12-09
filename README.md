# NFT Minting DApp by <a href="https://www.linkedin.com/in/athika-fatima/"> Athika Fatima</a> - 101502209

**NFT Minting DApp using HardHat, Pinata and Alchemy**

**1. Clone the repository**

      git clone <repo_link>

**2. Install node modules**

      npm i

**3. Connecting with Alchemy**

      On Alchemy's Dashboard:
      1. Create an App
      2. Provide a name and description of your app
      3. For chain, select Ethereum, Network: Sepolia
      4. Click the Create App button5. Click on app's ViewKey button in the dashboard and save the API key in .env file in your project's root directory

**5. Update the .env file**

      ALCHEMY_API_KEY = "<your API key>"
      METAMASK_PRIVATE_KEY = "0x<your MetaMask private key>"

**4. Configuring your image on Pinata**

      On Pinata's Dashboard:
      1. Upload your NFT image
      2. Create your meta data file (similar to nft.json)
      3. Upload your meta data file onto Pinata
      4. Replace the 'baseTokenURI' in the deploy.js with the pinata url for your meta data file.

**5. To start the project, Install hardhat as the dev environment or run it using npx**

      npx hardhat
      npx hardhat compile
      npx hardhat run scripts/deploy.js --network sepolia

**6. You should get a contract code once you run the script**

      Copy the contract code and paste it in the App.js file inside the nft_mint_frontend folder.

**7. The nft_mint_frontend folder contains the frontend side of the Dapp, Now install the node modules**

      cd nft_mint_frontend
      npm install

**8. Run the development server**

      npm start

**9. View your freshly minted NFT on OpenSea**

      https://testnets.opensea.io/<your_account_address>

Note: Feel free to give a follow if this helped, and reach out if you need help :)
