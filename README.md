# Simple Demo of Serverless Architecture Deployment over OpenShift
Deploying the sample internet banking demo into serverless micro-services over OpenShift 4.x

This demo is built using the original demo: https://github.com/osa-ora/AcmeInternetBankingApp

This is the Application Architecture components:

<img width="915" alt="Solution_Architecture" src="https://user-images.githubusercontent.com/18471537/72225660-0a761280-3599-11ea-843b-f5155f6674d0.png">

The application contains a GUI application that connect to different micro-services, potentially these micro-services can be exposed over API gatway, but to keep it simple we will not deploy any API gateway.

## Deployment steps
Run the following steps to login to Openshift cluster and create a working folder:
```
//login to OpenShift cluster
oc login ...
mkdir internet-banking
cd internet-banking
```

Deploy the Loan Micro-Service as Serverless

```
//Deploy Loan Services
curl https://raw.githubusercontent.com/osa-ora/LoanValService/master/configs/init-serverless.sh > init-loan-service.sh
chmod +x init-loan-service.sh
./init-loan-service.sh
```
Deploy the Banking Micro-Service as Serverless

```
curl https://raw.githubusercontent.com/osa-ora/BankingService/master/configs/init-serverless.sh > init-banking.sh
chmod +x init-banking.sh
./init-banking.sh
```
Install the DB tables and test data by following the console output of the shell script.

Now, proceed to Deploy Customer Data Micro-Service as Serverless
```
curl https://raw.githubusercontent.com/osa-ora/CustomerDataService/master/configs/init-serverless.sh > init-customer-service.sh
chmod +x init-customer-service.sh
./init-customer-service.sh 
```
Install the DB tables and test data by following the console output of the shell script.

Deploy User Accounts Micro-Services as Serverless
```
curl https://raw.githubusercontent.com/osa-ora/UserAccountService/master/configs/init-serverless.sh > init-user-service.sh
chmod +x init-user-service.sh
./init-user-service.sh 
```
Install the DB tables and test data by following the console output of the shell script.

Deploy Exchange Rate Micro-Services as Serverless

```
curl https://raw.githubusercontent.com/osa-ora/ExchangeRateService/master/configs/init-serverless.sh > init-exchange.sh
chmod +x init-exchange.sh 
./init-exchange.sh 
```

Finally, deploy the front-end mico-services:
```
curl https://raw.githubusercontent.com/osa-ora/AcmeInternetBankingApp/master/configs/init-deployment.sh > init-gui.sh
chmod +x init-gui.sh
./init-gui.sh 
```

In OpenShfit console, the result will looks like:

<img width="1263" alt="Screen Shot 2022-03-17 at 12 16 46" src="https://user-images.githubusercontent.com/18471537/158852873-0427971b-feef-43bf-bae2-6f9535191347.png">

Note: in out deployment, we used Ephemeral datastores, and Redis and we didn't deploy AMQ to focus on the demo rather than actual deployment of the demo application.

Test the application:  

Get the front end route and access it using the ROUTE_URL/MyInternetBankingApp-1.0-SNAPSHOT/
  
  
Login using Osama/123 to test the application, then try to use the loan, exchange and transfer services, all should work except the transder cause we didnt' deploy the AMQ, but this is a good example of how Micro-service based-Architecture applications will not break if some services are not working or down.

<img width="1787" alt="Screen Shot 2022-03-17 at 12 12 49" src="https://user-images.githubusercontent.com/18471537/158855486-6bf9ab2e-2363-49f8-b0e8-92d9b910a772.png">


The Serverless is using Knative Serving, which is one mode of using Serverless, the other way is to use the Eventing which invoke the serverless based on recieving a message or event to wake up the serverless deployment.

Knative Serving provides components that enable:

- Rapid deployment of serverless containers.
- Autoscaling, including scaling pods down to zero.
- Support for multiple networking layers, such as Contour, Kourier, and Istio, for integration into existing environments.
- Point-in-time snapshots of deployed code and configurations.

Knative Serving supports both HTTP and HTTPS networking protocols.

The following diagram shows the serverless service and its different revisions where the traffic will be routes from the router:

![serverless-serving](https://user-images.githubusercontent.com/18471537/158854473-9631fff1-3fb2-412c-b92c-6c2fa7acc10f.png)


For more info: https://knative.dev/docs/serving/

Conclusion:   
Building a portable serverless applications that utilize some OpenShift capabilities such as Source2Image where we provide the source code to OpenShift, it will be build the application, create container image, store it inside the embeded image registery and finally we can use this image to create either server-based or serverless deployment.
This provide portability across cloud providers using the abstracted layer of Kubernetes or OpenShift in our example.

