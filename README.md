# Blueprint/Boilerplate For Python Projects

[![Build, Test and Lint Action](https://github.com/MartinHeinz/python-project-blueprint/workflows/Build,%20Test,%20Lint/badge.svg)](https://github.com/MartinHeinz/python-project-blueprint/workflows/Build,%20Test,%20Lint/badge.svg)
[![Push Action](https://github.com/MartinHeinz/python-project-blueprint/workflows/Push/badge.svg)](https://github.com/https://github.com/MartinHeinz/python-project-blueprint/workflows/Push/badge.svg)
[![Test Coverage](https://api.codeclimate.com/v1/badges/05c44c881bc10a706cbc/test_coverage)](https://codeclimate.com/github/MartinHeinz/python-project-blueprint/test_coverage)
[![Maintainability](https://api.codeclimate.com/v1/badges/05c44c881bc10a706cbc/maintainability)](https://codeclimate.com/github/MartinHeinz/python-project-blueprint/maintainability)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=MartinHeinz_python-project-blueprint&metric=alert_status)](https://sonarcloud.io/dashboard?id=MartinHeinz_python-project-blueprint)

## Blog Posts - More Information About This Repo

You can find more information about this project/repository and how to use it in following blog post:

- [Ultimate Setup for Your Next Python Project](https://towardsdatascience.com/ultimate-setup-for-your-next-python-project-179bda8a7c2c)

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


### Resources
- <https://realpython.com/python-application-layouts/>
- <https://dev.to/codemouse92/dead-simple-python-project-structure-and-imports-38c6>
- <https://github.com/navdeep-G/samplemod/blob/master/setup.py>
- <https://github.com/GoogleContainerTools/distroless/blob/master/examples/python3/Dockerfile>