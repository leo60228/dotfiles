#!/usr/bin/env python3

from base64 import b64encode
import urllib.request
import json
import hashlib

with open("fonts.txt", "r") as f:
    fonts = f.readlines()

with urllib.request.urlopen(
    "https://fs.microsoft.com/fs/DesignerFonts/1.7/listAll.json"
) as resp:
    data = json.load(resp)

sources = {}

for name in fonts:
    name = name.strip()
    print(name)
    entries = {}
    family = next(family for family in data["Fonts"] if family["f"] == name)
    for font in family["sf"]:
        url = f"https://fs.microsoft.com/fs/DesignerFonts/1.7/rawguids/{font['id']}"
        with urllib.request.urlopen(url) as resp:
            hash = hashlib.file_digest(resp, "sha256").digest()
            sri = "sha256-" + b64encode(hash).decode()
            print(f"{family['f']} {font['id']} = {sri}")
            entries[font["id"]] = {"name": f"{font['dn']}.{font['t']}", "hash": sri}
    sources[name] = entries

with open("sources.json", "w") as f:
    json.dump(sources, f, indent=2)
    f.write('\n')
