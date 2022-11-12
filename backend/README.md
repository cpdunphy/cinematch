# Flask Application - Movies API

## Getting started

Assuming you have python3.x installed, you will want to create a virtual environment and activate it

```
python3 -m virtualenv .venv
. .venv/bin/activate
```

Install the dependencies

```
pip install -r requirements.txt
```

Put your firebase credentials in place

```
cp <path_to_credentials> env/serviceAccountKey.json
```

And run the app
```
flask run
```
