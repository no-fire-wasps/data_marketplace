import json

from flask import Flask, jsonify, request

import backend_module.config as config

app = Flask(__name__)

items = {}
with open("C:\\Users\e93583\PycharmProjects\data_marketplace\sample.json") as f:
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
    contained = {"children": []}
    item = items[id]
    contained["children"].append(item)
    while item[config.CONTAINED_BY] != "":
        elem = items[item[config.CONTAINED_BY]]
        elem["children"] = [item]
        item = items[item[config.CONTAINED_BY]]
        # contained.append({"children": item})
    return contained


def find_children(id, relation):
    if relation not in [config.CONTAINS, config.FEEDS]:
        return {"exception": "not a valid relation"}
    return [items[i] for i in items[id][relation]]


def find_flow(id):
    response = {"response": []}
    output = items[id]
    output['children'] = find_children(id, config.FEEDS)
    if len(items[id][config.FED_BY]) == 0:
        return output
    for i in items[id][config.FED_BY]:
        elem = items[i]
        elem["children"] = output
        response["response"].append(elem)
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


app.debug = True
app.run()
