# Yoctobuilder

## Introduction

This is the configuration for the docker container called by BitBucket.

## Commands to build

For the following example, we're going to build for tag v1.0:

>docker build -t yoctobuilder:v1.0 .
>docker tag yoctobuilder:v1.0 seakeeper/yoctobuilder:v1.0
>docker push seakeeper/yoctobuilder:v1.0
