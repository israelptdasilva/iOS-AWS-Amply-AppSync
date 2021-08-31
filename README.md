[![Build Status](https://app.bitrise.io/app/709e892214e29a0b/status.svg?token=ED-l14v_4i6nwXj60rpYwg&branch=master)](https://app.bitrise.io/app/709e892214e29a0b)

# Amplify & AppSync iOS Integration

*© Israel Pereira Tavares da Silva*

> AWS Amplify is a set of tools and services that can be used together or on their own, to help front-end web and mobile developers build scalable full stack applications, powered by AWS. With Amplify, you can configure app backends and connect your app in minutes, deploy static web apps in a few clicks, and easily manage app content outside the AWS console.

> AWS AppSync provides a robust, scalable GraphQL interface for application developers to combine data from multiple sources, including Amazon DynamoDB, AWS Lambda, and HTTP APIs.

* [Amplify](https://aws.amazon.com/amplify/)
* [AppSync](https://docs.aws.amazon.com/appsync/latest/devguide/what-is-appsync.html)
* [Getting Started](https://docs.amplify.aws/start/getting-started/setup/q/integration/ios/)

The primary goal of this project is to make an assessment of the use of AWS Amplify API for mobile development. In this assessment iOS is used, however Amplify is available for Android and Flutter technologies as well.

### Setup

* **An account on AWS is required to create and managed services created by Amplify**

Clone the project:

```bash
git clone https://github.com/israelptdasilva/iOS-AWS-Amply-AppSync
```
```bash
cd iOS-AWS-Amply-AppSync
```

### Conda *(Optional)*
Follow these steps only if you wish to use [conda](https://docs.conda.io/en/latest/miniconda.html). You can use another environment manager or install dependencies in your user space. Also, if you want to start a Amplify project from scratch you can follow the After cloning the project it is best to follow the steps in the [official documentation](https://docs.amplify.aws/start/getting-started/setup/q/integration/ios/), however some of the steps in the documentation don't apply to this project anymore and repeating some steps may cause conflicts.

```bash
$ conda create -n amplify
$ conda activate amplify
$ conda install nodejs
$ npm install -g @aws-amplify/cli
$ amplify configure
$ amplify init
```
Note: You may need to resolve Xcode package dependencies in File -> Swift Packages. For reference see this [step](https://docs.amplify.aws/start/getting-started/setup/q/integration/ios/).

### Run The Project
By now it should be possible to run the project either by using `CMD+R or using the play button in Xcode.

### Unit & UITests
To run the both unit and UI tests use `CMD+U`. In both cases the calls to GraphQL data store is mocked by the class `AWSMockPublisher`.

### Conclusion

#### Pros:
* Model Schema can be changed locally and pushed the changes to the remote store via command line.
* Changes to the schema can be pulled via command line.
* Use of configuration files to connect to AWS services - `awsconfiguration.json` and `amplifyconfiguration.json`
* Offline storage and syncing of local data with remote store and vice versa.
* Use of pub/sub interfaces to subscribe to data changes on the remote store.

#### Cons:
* Relies on the AWS platform.
* Need to investigate if data uses encryption when saved locally.
* Amplify uses the Combine framework to provide the APIs for data management. This may be changed if Swift asyc and wait features become more relevant than Combine.

> Numa folha qualquer eu desenho um sol amarelo 
E com cinco ou seis retas é fácil fazer um castelo
Corro o lápis em torno da mão e me dou uma luva 
E se faço chover, com dois riscos tenho um guarda-chuva. [(Toquinho - Aquarela)](https://www.youtube.com/watch?v=xT8HIiFQ8Y0)
