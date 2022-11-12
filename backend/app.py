from flask import Flask, request, jsonify
import firebase_admin
from firebase_admin import firestore, credentials

app = Flask(__name__)

cred = credentials.Certificate('env/serviceAccountKey.json')
firebase_admin.initialize_app(cred)
db = firestore.client()

@app.route('/')
def index():
    return 'You have arrived at the root of the app'

@app.route('/titles')
@app.route('/titles/<title_id>')
def titles(title_id=None):
    if title_id is None:
        return 'You have arrived at the titles page'
    else:
        return 'You have arrived at the page for title {}'.format(title_id)

@app.route('/sessions')
@app.route('/sessions/<session_id>')
def sessions(session_id=None):
    if session_id is None:
        return 'You have arrived at the sessions page'
    else:
        return 'You have arrived at the page for session ' + session_id

@app.route('/users', methods=['GET', 'POST'])
@app.route('/users/<user_id>', methods=['GET', 'PUT', 'DELETE'])
def users(user_id=None):
    if request.method == 'GET':
        if user_id is None:
            return 'You have arrived at the users page'
        else:
            return 'You have arrived at the page for user ' + user_id
    elif request.method == 'POST':
        json = request.get_json()
        doc_ref = db.collection('users').document(json['username'])
        doc_ref.set(json)
        return jsonify(message='User {} created'.format(json['username']), status=201)
    elif request.method == 'PUT':
        return 'You have put to the users page'
    elif request.method == 'DELETE':
        return 'You have deleted to the users page'
