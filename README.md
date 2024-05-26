```bash
$ python3 --version
Python 3.8.3

$ python3 -m venv venv
$ source venv/bin/activate
(venv) $ pip install --upgrade pip
(venv) $ pip install -r requirements.txt
```

```bash
$ podman build \
   --file Containerfile \
   --tag image-msdocs-python-flask-azure-container-apps-3 \
   .

$ podman run \
    --name container-msdocs-python-flask-azure-container-apps-3 \
    --publish 5000:5000 \
    image-msdocs-python-flask-azure-container-apps-3
```
