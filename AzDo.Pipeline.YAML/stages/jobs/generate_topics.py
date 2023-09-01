import json
import argparse, sys
import base64
import requests
import csv

parser=argparse.ArgumentParser()

parser.add_argument('--token', help='Azure devops token')
parser.add_argument('--template', help='Template var file')
parser.add_argument('--var', help='Generated var file name')
parser.add_argument('--topicslocation', help='Repository url location where topic files are stored')
parser.add_argument('--topics', help='Repository url location where topic file is stored')
parser.add_argument('--prefix', help='Prefix corresponds to your projects namespace')

args = parser.parse_args()
credentials = 'ABC:'+ args.token
auth_token = 'Basic ' + base64.b64encode(credentials.encode('utf-8')).decode('utf-8')

topics_to_recreate = args.topics.split(',')

repo = requests.get(args.topicslocation, headers={'Authorization': auth_token})
response = json.loads(repo.text)
r = requests.get(response['_links']['tree']['href'], headers={'Authorization': auth_token})

topic_data = json.loads(r.text)
topics = []
for item in topic_data['treeEntries']:
    filename = item['relativePath']
    if filename.startswith(args.prefix) and filename.replace('.json', '') in topics_to_recreate:
        topic = {"name": filename.replace('.json', ''), "file": item['url']}
        topics.append(topic)


with open(args.template, 'r') as f:
    data = json.load(f)
    data['extra_vars']['json_topics'] = topics

with open(args.var, 'w') as f:
    json.dump(data, f, indent=4)