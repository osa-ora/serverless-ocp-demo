#!/bin/sh
echo "Please Login to OCP using oc login ..... "  
echo "Press [Enter] key to resume..." 
read

echo "Create working folder .. "
mkdir internet-banking
cd internet-banking
echo "============================================="

echo "Deploy the Loan Micro-Service as Serverless"
curl https://raw.githubusercontent.com/osa-ora/LoanValService/master/configs/init-serverless.sh > init-loan-service.sh
chmod +x init-loan-service.sh
./init-loan-service.sh
echo "============================================="

echo "Deploy the Banking Micro-Service as Serverless"
curl https://raw.githubusercontent.com/osa-ora/BankingService/master/configs/init-serverless.sh > init-banking.sh
chmod +x init-banking.sh
./init-banking.sh
echo "============================================="

echo "Install the DB tables and test data by following the console output of the shell script..... "  
echo "Press [Enter] key to resume..." 
read

echo "Deploy Customer Data Micro-Service as Serverless"
curl https://raw.githubusercontent.com/osa-ora/CustomerDataService/master/configs/init-serverless.sh > init-customer-service.sh
chmod +x init-customer-service.sh
./init-customer-service.sh 
echo "============================================="

echo "Install the DB tables and test data by following the console output of the shell script..... "  
echo "Press [Enter] key to resume..." 
read

echo "Deploy User Accounts Micro-Services as Serverless"
curl https://raw.githubusercontent.com/osa-ora/UserAccountService/master/configs/init-serverless.sh > init-user-service.sh
chmod +x init-user-service.sh
./init-user-service.sh 
echo "============================================="

echo "Install the DB tables and test data by following the console output of the shell script..... "  
echo "Press [Enter] key to resume..." 
read

echo "Deploy Exchange Rate Micro-Services as Serverless"
curl https://raw.githubusercontent.com/osa-ora/ExchangeRateService/master/configs/init-serverless.sh > init-exchange.sh
chmod +x init-exchange.sh 
./init-exchange.sh 
echo "============================================="

echo "Deploy the front-end mico-services"
curl https://raw.githubusercontent.com/osa-ora/AcmeInternetBankingApp/master/configs/init-deployment.sh > init-gui.sh
chmod +x init-gui.sh
./init-gui.sh 
echo "============================================="

echo "Get the front end route and access it using the ROUTE_URL/MyInternetBankingApp-1.0-SNAPSHOT/"
echo "Completed!"
