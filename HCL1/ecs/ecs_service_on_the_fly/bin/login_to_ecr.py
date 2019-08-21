#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import json
import uuid
import argparse
import subprocess


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Script to login in ECR.')
    parser.add_argument('-r', dest='region', help='AWS Region', metavar='REGION')
    parser.add_argument('-a', dest='access', help='AWS Access Key', metavar='ACCESS')
    parser.add_argument('-s', dest='secret', help='AWS Secret Key', metavar='SECRET')
    args = parser.parse_args()

    if not args.region or not args.access or not args.secret:
        print("Usage:")
        print(str(os.path.basename(__file__)) + " -r <aws_region> -a <aws_access_key> -s <aws_secret_key>")
        exit(1)

    os.environ["AWS_ACCESS_KEY_ID"] = args.access
    os.environ["AWS_SECRET_ACCESS_KEY"] = args.secret
    get_login_result = subprocess.run(
        ["aws", "--region", args.region, "ecr", "get-login", "--no-include-email"],
        stdout=subprocess.PIPE, encoding='utf-8')
    login_string = list(get_login_result.stdout.splitlines()[0].split())
    login_result = subprocess.run(login_string, stdout=subprocess.PIPE, encoding='utf-8')

    print(json.dumps({'result': str(uuid.uuid4())}))
    exit(login_result.returncode)
