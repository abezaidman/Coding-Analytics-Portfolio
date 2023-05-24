from google.cloud import firestore
import json
import requests
import tempfile

REDDIT_CREDENTIALS_FILE = 'reddit_stuff.json'

def get_data(request):
    db = firestore.Client()

    rc = json.load(open(REDDIT_CREDENTIALS_FILE))
    auth = requests.auth.HTTPBasicAuth(rc['client_id'], rc['secret_token'])
    data = {
        'grant_type': 'password',
        'username': rc['username'],
        'password': rc['password']
    }
    headers = {'User-Agent': 'scraper/0.0.1'}
    resp = requests.post(
        'https://www.reddit.com/api/v1/access_token',
        auth=auth,
        data=data, 
        headers=headers)
    token = resp.json()['access_token']
    
    headers = {**headers, **{'Authorization': f"bearer {token}"}}
    params = {'limit': 100}
    url = "https://oauth.reddit.com/" + "r/movies" + "/new"
    resp = requests.get(url, headers=headers, params=params)
    
    posts = [p['data'] for p in resp.json()['data']['children'] if p['data']['link_flair_text'] in ['Review', 'Discussion']]

    for post in posts:
        doc_ref = db.collection('movie_reviews').document(post['id'])
        doc_ref.set(post)

    resp = {'posts downloaded': len(posts)}
    return resp
