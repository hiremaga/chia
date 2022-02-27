#!/bin/bash

[ -e "$HOME/.ssh/id_rsa" ] || ssh-keygen -t rsa -N ''
