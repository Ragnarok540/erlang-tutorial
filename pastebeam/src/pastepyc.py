from hashlib import sha256
from random import randbytes, randint
from base64 import b64encode

with open('challenge.txt', encoding='utf-8') as f:
    content = f.read()

counter = 0

while counter < 50_000_000:
    suffix = b64encode(randbytes(randint(1, 100))).decode('utf-8')
    s = content + suffix + '\n'
    h = sha256(str.encode(s)).hexdigest()
    c = 0

    while c < len(h) and h[c] == '0':
        c += 1

    if c > 4:
        print(f'suffix => {suffix}, hash => {h}, c => {c}')
        break

    counter += 1
