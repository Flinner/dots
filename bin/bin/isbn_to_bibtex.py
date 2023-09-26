#!/usr/bin/env python

import requests
import sys
import fileinput

## EXIT CODES:
# 1: Fail in arg parsing
# 2: Network error

def eprint(*args, **kwargs):
    #print(*args, file=sys.stderr, **kwargs)

#isbn can be a csv list
def convert_isbn_to_bibtex(isbn):
    url = "https://api.paperpile.com/api/public/convert"
    payload = {
        "input": isbn,
        "targetFormat": "Bibtex",
        "fromIds": True
    }
    eprint(payload)
    response = requests.post(url, json=payload)
    eprint(response.text)
    if response.status_code == 200 or response.status_code == 201:
        return response.json().get("output")
    else:
        eprint("Failed!, res code: ", response.status_code)
        return None

isbn = None

if not sys.stdin.isatty() :
    stdin_ = list(fileinput.input().splitlines())
    isbn = ",".join(stdin_)
    print("isbn from stdin:", isbn)

# favour stdin over args!
if (not isbn):
    if (len(sys.argv) > 1):
        isbn = sys.argv[1]
        print("isbn from args:", isbn)
    else:
        eprint("No Arguments (or stdin) Provided!")
        sys.exit(1)


bibtex = convert_isbn_to_bibtex(isbn)
if bibtex:
    print(bibtex)
else:
    print("Failed to convert ISBN to BibTeX")
    sys.exit(2)
