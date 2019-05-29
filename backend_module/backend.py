import copy
import json
import os

from flask import Flask, jsonify, request, send_file
from flask_cors import cross_origin

import backend_module.config as config

app = Flask(__name__)

items = {}


def get_sample_json():
    return os.path.realpath(
        os.path.join(os.getcwd(), 'sample', 'sample.json'))


__location__ = get_sample_json()

with open("C:\\Users\e93583\PycharmProjects\data_marketplace\\backend_module\sample\sample.json") as f:
    json_items = json.load(f)['items']
    for i in json_items:
        items[i['id']] = i


def contains(input_list, item):
    for x in input_list:
        if item in x:
            return True
    return False


def contains_in_txt(input_txt, item):
    l = input_txt.split(" ")
    return contains(l, item)


def search_in_file(keyword, item_type):
    output = []
    for item in json_items:
        if (item_type != "" and item[config.ITEM_TYPE] == item_type) or item_type == "":
            if item['name'] == keyword:
                output = [item] + output
            elif contains(item[config.KEYWORDS], keyword):
                output.append(item)
            elif contains_in_txt(item['description'], keyword):
                output.append(item)
    return output


def find_parents(id):
    sample_items = copy.deepcopy(items)
    it = sample_items[id]
    contained = it
    parent = it[config.CONTAINED_BY]
    while parent != 0:
        # contained["children"] = [item]
        elem = sample_items[parent].copy()
        elem["children"] = [contained]
        contained = elem.copy()
        it = sample_items[parent]
        parent = it[config.CONTAINED_BY]
        # contained.append({"children": item})
    return contained


def find_children(id, relation):
    if relation not in [config.CONTAINS, config.FEEDS]:
        return {"exception": "not a valid relation"}
    return [items[i] for i in items[id][relation]]


def find_flow(id):
    response = []
    output = items[id]
    output['children'] = find_children(id, config.FEEDS)
    if len(items[id][config.FED_BY]) == 0:
        return output
    for i in items[id][config.FED_BY]:
        elem = items[i]
        elem["children"] = output
        response.append(elem)
    return response


@app.route('/search_keyword', methods=['GET', 'POST'])
def search_keyword():
    if request.method == 'POST':
        output = {}
        input = request.json
        keyword = input[config.KEYWORD]
        item_type = input[config.ITEM_TYPE]
        output["response"] = search_in_file(keyword, item_type)

        return jsonify(output)


@app.route('/get_flow', methods=['GET', 'POST'])
def get_flow():
    if request.method == 'POST':
        output = {}
        input = request.json
        id = input["id"]
        output["response"] = find_flow(id)
        return jsonify(output)


@app.route('/get_children', methods=['GET', 'POST'])
def get_children():
    if request.method == 'POST':
        output = {}
        input = request.json
        id = input["id"]
        output["response"] = find_parents(id)
        return jsonify(output)

@app.route('/get_node_by_id', methods=['GET', 'POST'])
def get_node_by_id():
    if request.method == 'POST':
        output = {}
        input = request.json
        id = input["id"]
        output["response"] = items[id]
        return jsonify(output)

@app.route('/flow_test', methods=['GET', 'POST'])
@cross_origin
def flow_test():
    if request.method == 'POST':
        with open("C:\\Users\\e808937\\Documents\\Develop\\Python\\data_marketplace\\JavaScript\\sample.json") as f:
            flow_json_items = json.load(f)
    return jsonify(flow_json_items['response'])


@app.route('/test_js', methods=['GET', 'POST'])
def test_js():
    if request.method == 'GET':
        return send_file(
            'C:\\Users\\e93583\\PycharmProjects\\data_marketplace\\JavaScript\\TreeDiagram.html'
        )

app.debug = True
app.run()
