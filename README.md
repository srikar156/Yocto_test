# README #

### What is this repository for? ###

* This is a copy of the Avenger Yocto build, that runs in a bitbucket pipeline in the same way as our other Yocto builds to support the BlueBinaries work.

## Setup

The project is configured to use the `kas` setup tool ([Source](https://github.com/siemens/kas) and [Documentation](https://kas.readthedocs.io/en/latest/intro.html)) as part of a CI pipeline to download, configure and build the system.

### Automated Building

The `./scripts` directory contains the shell scripts used to maintain the project.

#### Build Script

`./scripts/build.sh`

Build the entire system for the selected build type.

The arguments to the script are:

**Required**

-   -f= or --kasfile=
    - The name of the kas configuration file, **_without_** the `.yaml` extension.
    - This will be something like `kas-prod.yaml`

-   -k= or --priv-key=
    - The path to the private key

-   -p= or --pub-key=
    - The path to the public key

-   -s= or --signing-passwd=
    - The signing password

**Optional**

-   -b= or --repo-slug=
    - Used by the Bitbucket CI

-   -n= or --build-number=
    - Used by the Bitbucket CI

-   --sdk
    - Builds the SDK for the image.
    - Defaults to not building it.

-   -u= or --user=
    - The user name used for the build. The default (which is needed for the CI is `skrladmin`)
    - This is to allow local builds to specify an existing user and not have to create a new one for builds.

## Kas Configuration

The top level kas files define which system to build by the kas system (used in the builds above).

This then `includes` the additional configuration files under the directory `kas`.

## Docker Image

Uses the seakeeper/ridebuilder:1.9 image built from the dockerfile in the /docker directory of uis-cicd-yocto-avenger.

## Access Tokens

Pipeline Build: Allows the pipeline to upload files to the repository downloads page. This token is exposed to the pipeline via the DOWNLOADS_UPLOAD_TOKEN repository variable.

## Repository Variables

DOCKER_HUB_USERNAME:
DOCKER_HUB_PASSWORD:
DOCKER_HUB_EMAIL: Allows the pipeline runner to access SeaKeeper images on DockerHub.
DOWNLOADS_UPLOAD_TOKEN: The filesystem builder Pipeline Build access token.

As well as signing keys and password in the are repository variables in CI, these include PRIV_KEY_SIGNING, PUB_KEY_SIGNING, SIGNING_PASSWD.

### Who do I talk to? ###

* Speak to Stuart for more details
