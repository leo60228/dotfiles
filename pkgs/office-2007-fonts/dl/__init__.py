import libarchive
import requests
import pycdlib
import sys

old_version = sys.version_info
sys.version_info = (3, 5)
import httpio
sys.version_info = old_version

def dl():
    print('querying redirect')
    url = "https://archive.org/download/microsoft-office-professional-plus-2007/Microsoft%20Office%20Professional%20Plus%202007.iso"
    target = requests.head(url).headers['Location']

    print('making request')
    iso_fp = httpio.open(target, block_size=4*1024*1024)

    print('opening iso')
    iso = pycdlib.PyCdlib()
    iso.open_fp(iso_fp)

    print('opening file')
    with iso.open_file_from_iso(iso_path='/PROPLUSW/PROPLSWW.CAB') as cab_fp:
        print('reading archive')
        with libarchive.stream_reader(cab_fp) as archive:
            print('archive loaded')
            for entry in archive:
                if entry.name.endswith('.TTF'):
                    print(entry.name)
                    with open(entry.name, 'wb') as out:
                        for block in entry.get_blocks():
                            out.write(block)
                    if entry.name == "WINGDNG3.TTF":
                        break
