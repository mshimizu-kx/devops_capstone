#!/bin/bash

curl -d "$1" -H "Content-Type:plaintext" -X POST http://192.168.49.2:31600
