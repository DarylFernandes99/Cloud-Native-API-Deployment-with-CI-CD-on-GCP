#!/bin/bash
packer init .
packer fmt . && exit 1
packer validate .
