# CloudDevOps Capstone Project - Deploy kdb+ HDB Instance to AWS -

## Overview

In financial area institutions have to handle massive amount of data on daily basis. This means the institutions have to find a way to store the loads of data somewhere with sufficient capacity but still keeps availability for anaysis to make a strategy or audit purpose. In this trend users are starting to migrate their database onto cloud storage as the service provided with kdb+ on cloud expands.

This project addressed such a trend and provided a small example of deploying kdb+ historical database instance on AWS with kubernets ([Amazon Elastic Kubernetes Service](https://aws.amazon.com/jp/eks/)). Here the historical data is stored on Amazon S3 bucket and kdb+ loads the data by mounting the bucket. As a nature of cloud users do not have much control of infrastructures and so users must use a way of deploying which is highly reproducable and parameterized. From this point of view, this project uses one of matured continuous development tools of old, [Jenkins](https://www.jenkins.io/).

## Workflow

The deployment workflow is as follws:

- Check linting of a Docker build script.
- Build a docker container and upload the image to Docker hub. The container has kdb+ program and a script to mount S3.
- Deploying an infrastruture with [AWS Cloudformation](https://aws.amazon.com/jp/cloudformation/).
- Deploying kdb+ application with Amazon EKS.
- Conduct a smoke test.
- Clean up a previous deployment.

## Deploying Application

**Requirements:**

- AWS account and IAM user for AWS CLI
- AWS CLI (version 2)[^1]
- Docker [^2]
- Account of Docker Hub
- kubernets [^3]
- S3 Bucket storing kdb+ HDB. [^4]

[^1] For installation of AWS CLI, follow [this link](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html).

[^2] For installation of Docker engine, follow [this link](https://docs.docker.com/engine/install/).

[^3] For installation of kubernets, follow [this link](https://v1-18.docs.kubernetes.io/docs/tasks/tools/install-minikube/).

[^4] If you don't have a handy HDB data, you can create simple HDB directory with `buildhdb.q` of [this repository](https://github.com/KxSystems/cookbook/tree/master/start) and then upload `hdb` directory to S3 bucket. The commmand to create the HDB is:

    $ q buildhdb.q

You should be able to see a structure like this (rename `db/` to `hdb/`):

```tree

hdb
├── 2013.05.01
├── 2013.05.02
├── 2013.05.03
├── 2013.05.06
├── 2013.05.07
:
├── 2013.05.28
├── 2013.05.29
├── 2013.05.30
├── 2013.05.31
├── daily
├── depth
├── mas
└── sym

```

In order to deploy the application, you need to follow the simple two steps below:

1. Build docker image of kdb+ and upload to Docker hub.
2. Deploy infrastructure stack
3. Deploy the application with kubernets

### 1. Build Docker Image

We will build an image named `kdb-hdb`. You are assumed to be in the source directory.

```bash

$ docker login
$ docker build --tag kdb-hdb .
$ docker tag kdb-hdb [your account name of Docker Hub]/kdb-hdb
$ docker push [your account name of Docker Hub]/kdb-hdb

```

### 2. Deploy Infrastructure Stack

This step sounds horrable since we don't have servers on hand. Fear not, all you have to do is to execute a script.

```bash

$ cd IAC
IAC] ./launch_eks.sh
IAC]$ cd ../

```

That's all!! You came riding on the wings of an eagle!! 🦅🦅🦅

### 3. Deploy Application

Now you have working kubernets cluster on AWS. Let's deploy the container we built above.

```bash

$ cd manifest
manifest]$ ./deploy_app.sh
manifest]$ cd ../

```

### 4. Play Around

It takes a few minutes until the HDB service becomes ready to hit via HTTP ⚙️⚙️⚙️. Once it becomes ready you can send a query to the HDBs with `query.sh` providing a query as a text.

```bash

$ cd userscript
userscript]$ ./query.sh "select from daily"

```

*Note: the response is returned in JSON format.*

