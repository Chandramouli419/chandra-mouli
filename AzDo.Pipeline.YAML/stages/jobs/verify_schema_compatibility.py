import argparse, sys
import json
import base64
import requests
from requests.structures import CaseInsensitiveDict
import urllib3

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

parser=argparse.ArgumentParser()

parser.add_argument('--token', help='Azure devops token')
parser.add_argument('--apikey', help='Schema Registry Api Key')
parser.add_argument('--apisecret', help='Schema Registry Api Secret')
parser.add_argument('--url', help='Schema Registry Url')
parser.add_argument('--schemas', help='Repository url location where schema files are stored')
parser.add_argument('--prefix', help='Prefix corresponds to your projects namespace')
args = parser.parse_args()

credentials = 'ABC:'+ args.token
azdo_auth_token = 'Basic ' + base64.b64encode(credentials.encode('utf-8')).decode('utf-8')

repo = requests.get(args.schemas, headers={'Authorization': azdo_auth_token})
response = json.loads(repo.text)

schema_files = requests.get(response['_links']['tree']['href'], headers={'Authorization': azdo_auth_token}).text
schema_data = json.loads(schema_files)

ccloud_credentials = '%s:%s' % (args.apikey, args.apisecret)
ccloud_auth_token = 'Basic ' + base64.b64encode(ccloud_credentials.encode('utf-8')).decode('utf-8')
ccloud_schema_registry = '%s/compatibility/subjects/%s/versions/latest?verbose=true'
headers = CaseInsensitiveDict()
headers['Authorization'] = ccloud_auth_token
headers["Accept"] = "application/json"
headers["Content-Type"] = "application/vnd.schemaregistry.v1+json"

incompatibles = []
for item in schema_data['treeEntries']:
    if item['relativePath'].startswith(args.prefix):
        subject = item['relativePath'].replace('.avsc', '')
        schema_definition = requests.get(item['url'], headers={'Authorization': azdo_auth_token}).text
        payload = { 'schema': schema_definition }
        json_response = json.loads(requests.post(ccloud_schema_registry % (args.url, subject), verify=False, headers=headers, data=json.dumps(payload)).text)
        is_compatible = json_response['is_compatible']
        if not is_compatible:
            print(json_response)
            incompatibles.append(subject)
        elif is_compatible:
            print(subject + ' is compatible')

if len(incompatibles) > 0:
    raise Exception("Incompatible schemas found: \n" + '\n'.join(incompatibles))
