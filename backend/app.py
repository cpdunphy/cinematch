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
    if request.method == 'GET':
        if session_name is None:
            # TODO: Return all sessions
            return 'You have arrived at the sessions page'
        else:
            # TODO: Return the session with the id
            return 'You have arrived at he session page for the session ' + session_name
    elif request.method == 'POST':
        json = request.get_json()
        if json is None:

            return 'No JSON data provided'
        doc_ref = db.collection('session').document(json['session'])
        doc_ref.set(json)
        return jsonify(message='Session {} created'.format(json['session']), status = 201)
    elif request.method == 'PUT':
        return 'You have put to the session page'
    elif request.method == 'DELETE':
        return 'You have deleted from the session page'

@app.route('/sessions/<session_id>/<user_id>', methods=['GET', 'POST', 'PUT', 'DELETE'])
def user(session_id, user_id):
    if request.method == 'GET':
        # TODO: Get user session participation data from database
        return 'You have arrived at the user page for the user ' + user_id
    elif request.method == 'POST':
        # TODO: Add user to session
        return 'You have posted to the user page'
    elif request.method == 'PUT':
        # TODO: Edit user participation in session (update titles swiped on)
        return 'You have put to the user page'
    elif request.method == 'DELETE':
        # TODO: Remove user from session
        return 'You have deleted from the user page'

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
        if json is None:
            return 'No JSON data provided'
        doc_ref = db.collection('users').document(json['username'])
        doc_ref.set(json)
        return jsonify(message='User {} created'.format(json['username']), status=201)
    elif request.method == 'PUT':
        return 'You have put to the users page'
    elif request.method == 'DELETE':
        return 'You have deleted to the users page'
