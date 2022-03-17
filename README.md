# Simple Demo of Deploying Serverless-based Application Architecture over OpenShift
In this toturial, we will be deploying the sample internet banking demo into a serverless micro-services over OpenShift 4.x

This Serverless demo is using Knative Serving, which is one mode of using Knative Serverless, the other way is to use the Eventing which invoke the serverless based on recieving a message/event to wake up the serverless service.

Knative Serving provides components that enable:

- Rapid deployment of serverless containers.
- Autoscaling, including scaling pods down to zero.
- Support for multiple networking layers, such as Contour, Kourier, and Istio, for integration into existing environments.
- Point-in-time snapshots of deployed code and configurations.

Knative Serving supports both HTTP and HTTPS networking protocols.

The following diagram shows the serverless service and its different revisions where the traffic will be routes from the router:

![serverless-serving](https://user-images.githubusercontent.com/18471537/158854473-9631fff1-3fb2-412c-b92c-6c2fa7acc10f.png)


For more info: https://knative.dev/docs/serving/

This demo is built using the original demo: https://github.com/osa-ora/AcmeInternetBankingApp

This is the Application Architecture components:

<img width="915" alt="Solution_Architecture" src="https://user-images.githubusercontent.com/18471537/72225660-0a761280-3599-11ea-843b-f5155f6674d0.png">

The application contains a GUI application that connect to different micro-services, potentially these micro-services can be exposed over API gatway, but to keep it simple we will not deploy any API gateway.

## Deployment steps
Before we start, make sure the OpenShift Serverless operator is installed and an instance of knative-serving is deployed in the knative-serving namespace which will enable the serverless capability in OpenShift, so we can deploy the serverless components in this demo. We will use the 'dev' namespace/project to deploy the whole solution.

Before we start, make sure to login to Openshift cluster using OC command and create a working folder:
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

Deploy Customer Data Micro-Service as Serverless
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

Finally, deploy the front-end Micro-Services
```
curl https://raw.githubusercontent.com/osa-ora/AcmeInternetBankingApp/master/configs/init-deployment.sh > init-gui.sh
chmod +x init-gui.sh
./init-gui.sh 
```

In OpenShfit console, the result will looks like:

<img width="1263" alt="Screen Shot 2022-03-17 at 12 16 46" src="https://user-images.githubusercontent.com/18471537/158852873-0427971b-feef-43bf-bae2-6f9535191347.png">

Note: In our deployment, we used Ephemeral MySql datastores, and Ephemeral Redis and we didn't deploy AMQ so we can focus on the demo rather than actual deployment of the demo application.

Testing the application  

Get the front end route and access it using the ROUTE_URL/MyInternetBankingApp-1.0-SNAPSHOT/
  
  
Login using Osama/123 to test the application, then try to use the loan, exchange and transfer services, all should work except the transder cause we didnt' deploy the AMQ, but this is a good example of how Micro-service based-Architecture applications will not break if some services are not working or down.

<img width="1787" alt="Screen Shot 2022-03-17 at 12 12 49" src="https://user-images.githubusercontent.com/18471537/158855486-6bf9ab2e-2363-49f8-b0e8-92d9b910a772.png">



Some Take Aways:  

1) It is easy to deploy any existing application as a serverless deployment using OpenShift capabilities, where services like source2Image (we provide the source code to OpenShift, it will be build the application, create container image, store it inside the embeded image registery) will make this smooth deployment, the alternative is to deploy the images as serverless directly using YAML files such as

```
apiVersion: serving.knative.dev/v1
kind: Service
metadata:
  name: serverless-services
  namespace: dev
spec:
  template:
    spec:
      containers:
        - image: {IMAGE_URL}        
```

2) Building a portable serverless applications that utilize some OpenShift capabilities, make it easy to move your application across different deployment models e.g. private or public cloud or acorss different public cloud providers. This portability across cloud providers is achieved by the abstraction layer provided by Kubernetes or OpenShift in our example.

3) The selection of the micro-services that need to be deployed as a serverless components needs to be taken based on the expectations/actual consumption rate of the services, so for frequently-used services, it is better to avoid serverless deployment, while in low-frequently used services, it will be good to use serverless. This is not the main driver but could be potential driver for the selection criteria. 

In our demo, we just converted all the micro-services into serverless to build the demo, but we can consider services such as "exchange rate service" and "loan service" as very good candidates for serverless while the other micro-services need to be deployed with auto-scaling to accomodate the expected high traffic/demands. 

4) The selection of the technology to build the micro-servces is very important, for example, technology like Quarkus is recommended to build serverless applications, as it ignites fast (start in milliseconds) and consumes low memory and low cpu in compare to other Java frameworks, all this makes it very good fit for building serverless applications.
For more info about Quarkus: https://quarkus.io/

5) The portability and loose coupling come at a cost, if we compare it to the attractive public cloud serverless offerings where you will be only charged based on the consumption e.g. service invokations, which is a great advantage of using serverless in the public cloud providers inspite of the potential lock-in which can mitigated by different work-arounds.


