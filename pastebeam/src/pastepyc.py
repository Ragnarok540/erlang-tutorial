from hashlib import sha256
from random import randbytes, randint
from base64 import b64encode
import socket

with open('challenge.txt', encoding='utf-8') as f:
    content = [line.strip('\n') for line in f.readlines()]

client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client.connect(('localhost', 6969))
client.send(b'POST\r\n')

for line in content:
    client.send((line + '\r\n').encode())

client.send(b'SUBMIT\r\n')
challenge = client.recv(100).removeprefix(b'CHALLENGE ').strip().decode('utf-8')

# exit(0)

counter = 0

while counter < 50_000_000:
    suffix = b64encode(randbytes(randint(1, 100)))
    s = '\r\n'.join(content + [challenge, suffix.decode('utf-8'), ''])
    h = sha256(str.encode(s)).hexdigest()
    c = 0

    while c < len(h) and h[c] == '0':
        c += 1

    if c > 4:
        print(f'suffix => {suffix}, hash => {h}, c => {c}')
        client.send(b'ACCEPTED ' + suffix + b'\r\n')
        print(client.recv(100))
        break

    counter += 1
