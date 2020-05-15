# Blueprint/Boilerplate For Python Projects

[![Build, Test and Lint Action](https://github.com/MartinHeinz/python-project-blueprint/workflows/Build,%20Test,%20Lint/badge.svg)](https://github.com/MartinHeinz/python-project-blueprint/workflows/Build,%20Test,%20Lint/badge.svg)
[![Push Action](https://github.com/MartinHeinz/python-project-blueprint/workflows/Push/badge.svg)](https://github.com/https://github.com/MartinHeinz/python-project-blueprint/workflows/Push/badge.svg)
[![Test Coverage](https://api.codeclimate.com/v1/badges/05c44c881bc10a706cbc/test_coverage)](https://codeclimate.com/github/MartinHeinz/python-project-blueprint/test_coverage)
[![Maintainability](https://api.codeclimate.com/v1/badges/05c44c881bc10a706cbc/maintainability)](https://codeclimate.com/github/MartinHeinz/python-project-blueprint/maintainability)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=MartinHeinz_python-project-blueprint&metric=alert_status)](https://sonarcloud.io/dashboard?id=MartinHeinz_python-project-blueprint)

## Blog Posts - More Information About This Repo

You can find more information about this project/repository and how to use it in following blog post:

- [Ultimate Setup for Your Next Python Project](https://towardsdatascience.com/ultimate-setup-for-your-next-python-project-179bda8a7c2c)
- [Automating Every Aspect of Your Python Project](https://towardsdatascience.com/automating-every-aspect-of-your-python-project-6517336af9da)
- [Deploy Any Python Project to Kubernetes](https://towardsdatascience.com/deploy-any-python-project-to-kubernetes-2c6ad4d41f14)
- [Implementing gRPC server using Python](https://towardsdatascience.com/implementing-grpc-server-using-python-9dc42e8daea0)

## Quick Start
To use this repository as starter for your project you can run `configure_project.sh` script, which sets up all variables and file names. This way you can avoid configuring and renaming things yourself:

```shell
./configure_project.sh MODULE="coolproject" REGISTRY="docker.pkg.github.com/martinheinz/repo-name"
```

## Running

### Using Python Interpreter
```shell
~ $ make run
```

### Using Docker

Development image:
```console
~ $ make build-dev
~ $ docker images --filter "label=name=blueprint"
REPOSITORY                                                             TAG                 IMAGE ID            CREATED             SIZE
docker.pkg.github.com/martinheinz/python-project-blueprint/blueprint   3492a40-dirty       acf8d09acce4        28 seconds ago      967MB
~ $ docker run acf8d09acce4
Hello World...
```

Production (Distroless) image:
```console
~ $ make build-prod VERSION=0.0.5
~ $ docker images --filter "label=version=0.0.5"
REPOSITORY                                                             TAG                 IMAGE ID            CREATED             SIZE
docker.pkg.github.com/martinheinz/python-project-blueprint/blueprint   0.0.5               65e6690d9edd        5 seconds ago       86.1MB
~ $ docker run 65e6690d9edd
Hello World...
```

## Testing

Test are ran every time you build _dev_ or _prod_ image. You can also run tests using:

```console
~ $ make test
```

## Pushing to GitHub Package Registry

```console
~ $ docker login docker.pkg.github.com --username MartinHeinz
Password: ...
...
Login Succeeded
~ $ make push VERSION=0.0.5
```

## Cleaning

Clean _Pytest_ and coverage cache/files:

```console
~ $ make clean
```

Clean _Docker_ images:

```console
~ $ make docker-clean
```

## Kubernetes

Application can be easily deployed on _k8s_ using _KinD_.

To create cluster and/or view status:

```console
~ $ make cluster
```

To deploy application to local cluster:

```console
~ $ make deploy-local
```

To get debugging information of running application:

```console
~ $ make cluster-debug
```

To get remote shell into application pod:

```console
~ $ make cluster-rsh
```

To apply/update _Kubernetes_ manifest stored in `k8s` directory:

```console
~ $ make manifest-update
```

## Setting Up Sonar Cloud
- Navigate to <https://sonarcloud.io/projects>
- Click _plus_ in top right corner -> analyze new project
- Setup with _other CI tool_ -> _other_ -> _Linux_
- Copy `-Dsonar.projectKey=` and `-Dsonar.organization=`
    - These 2 values go to `sonar-project.properties` file
- Click pencil at bottom of `sonar-scanner` command
- Generate token and save it
- Go to repo -> _Settings_ tab -> _Secrets_ -> _Add a new secret_
    - name: `SONAR_TOKEN`
    - value: _Previously copied token_
    
## Creating Secret Tokens
Token is needed for example for _GitHub Package Registry_. To create one:

- Go to _Settings_ tab
- Click _Secrets_
- Click _Add a new secret_
    - _Name_: _name that will be accessible in GitHub Actions as `secrets.NAME`_
    - _Value_: _value_

### Resources
- <https://realpython.com/python-application-layouts/>
- <https://dev.to/codemouse92/dead-simple-python-project-structure-and-imports-38c6>
- <https://github.com/navdeep-G/samplemod/blob/master/setup.py>
- <https://github.com/GoogleContainerTools/distroless/blob/master/examples/python3/Dockerfile>
