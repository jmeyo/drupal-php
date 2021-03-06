#!/usr/bin/env bash

set -ex

function checkPhpFpm {
    make start
    make stop rm
}

function checkTools {
    make run -e CMD='pwd' | grep '/var/www/html'
    make run -e CMD='composer --version' ENV="-e COMPOSER_ALLOW_SUPERUSER=1"
    make run -e CMD='ssh -V'
}

function checkSshKeys {
    mkdir -p ./test/ssh.tmp
    ssh-keygen -t dsa -N '' -f ./test/ssh.tmp/id_rsa
    chmod 700 ./test/ssh.tmp
    make run -e CMD='[ -f /home/www-data/.ssh/id_rsa ]' VOLUMES="-v ${PWD}/test/ssh.tmp:/mnt/ssh"
    make run -e CMD='[ -f /home/www-data/.ssh/id_rsa.pub ]' VOLUMES="-v ${PWD}/test/ssh.tmp:/mnt/ssh"
}

function cleanup {
    rm -rf ./test/*.tmp
}

cleanup
checkPhpFpm
checkTools
checkSshKeys
cleanup
