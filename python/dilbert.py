#!/usr/bin/env python3
import requests
# needs to construct urls for comics like so:
# res = requests.get('https://dilbert.com/strip/2021-06-25')
url = 'https://dilbert.com/strip/2021-06-25'
headers = {'user-agent': 'Mozilla/5.0 (Windows NT 10.0; WOW64; rv:89.0) Gecko/20100101 Firefox/89.0'}
r = requests.get(url, headers=headers)
r.status_code
r.status_code == requests.codes.ok