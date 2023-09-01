import json
import argparse, sys
import base64
import requests
import csv

parser=argparse.ArgumentParser()

parser.add_argument('--token', help='Azure devops token')
parser.add_argument('--template', help='Template var file')
parser.add_argument('--var', help='Generated var file name')
parser.add_argument('--schemas', help='Repository url location where schema files are stored')
parser.add_argument('--topics', help='Repository url location where topic files are stored')
parser.add_argument('--csv', help='Repository url location where customized schema mapping file is stored')
parser.add_argument('--prefix', help='Prefix corresponds to your projects namespace')

args = parser.parse_args()

credentials = 'ABC:'+ args.token
auth_token = 'Basic ' + base64.b64encode(credentials.encode('utf-8')).decode('utf-8')

repo = requests.get(args.schemas, headers={'Authorization': auth_token})
response = json.loads(repo.text)

r = requests.get(response['_links']['tree']['href'], headers={'Authorization': auth_token})


schema_data = json.loads(r.text)
schema = []
for item in schema_data['treeEntries']:
    filename = item['relativePath']
    if filename.startswith(args.prefix):
        if filename.endswith('.avsc'):
            sch = {"subject": filename.replace('.avsc', ''), "file": item['url'], "type": "avsc", "cli_type": "AVRO"}
            schema.append(sch)
        if filename.endswith('.proto'):
            sch = {"subject": filename.replace('.proto', ''), "file": item['url'], "type": "proto", "cli_type": "PROTOBUF"}
            schema.append(sch)
        if filename.endswith('.json'):
            sch = {"subject": filename.replace('.json', ''), "file": item['url'], "type": "json", "cli_type": "JSON"}
            schema.append(sch)

# handle customized schema mapping, where same schema is registered across multiple topics
if args.csv != 'none': 
    customized_schema_mapping = requests.get(args.csv, headers={'Authorization': auth_token})
    csv_response = customized_schema_mapping.text
    if csv_response:
        reader = csv.reader(csv_response.strip().splitlines(), delimiter=',')
        for row in reader:
            print(row)
            if len(row) == 2:
                item_key = next(obj for obj in schema_data['treeEntries'] if obj['relativePath'] == row[1]+'-key.avsc')
                sch = {"subject": row[0]+'-key', "file": item_key['url'], "type": "avsc", "cli_type": "AVRO"}
                schema.append(sch)

                item_value = next(obj for obj in schema_data['treeEntries'] if obj['relativePath'] == row[1]+'-value.avsc')
                sch = {"subject": row[0]+'-value', "file": item_value['url'], "type": "avsc", "cli_type": "AVRO"}
                schema.append(sch)
            else:
                raise Exception("Error reading customized schema mappings: "  + row)

topics = []
if args.topics != 'none': 
    repo = requests.get(args.topics, headers={'Authorization': auth_token})
    response = json.loads(repo.text)
    r = requests.get(response['_links']['tree']['href'], headers={'Authorization': auth_token})

    topic_data = json.loads(r.text)
    for item in topic_data['treeEntries']:
        filename = item['relativePath']
        if filename.startswith(args.prefix):
            topic = {"name": filename.replace('.json', ''), "file": item['url']}
            topics.append(topic)


with open(args.template, 'r') as f:
    data = json.load(f)
    data['extra_vars']['schema'] = schema
    data['extra_vars']['json_topics'] = topics

with open(args.var, 'w') as f:
    json.dump(data, f, indent=4)