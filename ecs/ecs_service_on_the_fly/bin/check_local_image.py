#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import json
import uuid
import argparse
import subprocess


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Script for checking local docker image.')
    parser.add_argument('-i', dest='image', help='Docker image to check', metavar='IMAGE')
    parser.add_argument('-t', dest='tag', help='Docker tag to check', metavar='TAG')
    args = parser.parse_args()

    if not args.image or not args.tag:
        print("Error: Docker image wasn't provided.")
        print("Usage: " + str(os.path.basename(__file__)) + " -i <docker image> -t <docker image tag>")
        exit(1)

    full_image = args.image + ':' + args.tag

    result = subprocess.run(['docker', 'images', '-q', full_image], stdout=subprocess.PIPE, encoding='utf-8')

    if result.stdout is '':
        image_id = [str(uuid.uuid4())]
    else:
        image_id = result.stdout.splitlines()

    print(json.dumps({'id': image_id[0]}))
    exit(0)
