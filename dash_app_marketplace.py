import dash
import dash_auth
import dash_core_components as dcc
import dash_html_components as html
from dash.dependencies import Input, Output, State
from datetime import datetime
import pandas as pd
import base64

import json

with open(r'/Users/astrophy/PycharmProjects/data_marketplace/data_marketplace_data_V2.json') as json_file:
    data = json.load(json_file)['items']

USERNAME_PASSWORD_PAIRS = [['username', 'password'],
                           ['Kancharla', '24/06'],
                           ['Brown', '06/08'],
                           ['Heusen', '14/03',],
                           ['Jalalpour', '07/02'],
                           ['Wickens', '27/03'],
                           ['Eyre', '01/12']]

app = dash.Dash()
auth = dash_auth.BasicAuth(app, USERNAME_PASSWORD_PAIRS)

def encode_image(image_file):
    encoded = base64.b64encode(open(image_file, 'rb').read())
    return 'data:image/png;base64,{}'.format(encoded.decode())

keywords = []

for i in range(len(data)):
    item = data[i]['keywords']
    keywords.extend(item)

keywords = list(set(keywords))

names = []

for i in range(len(data)):
    name = data[i]['name']
    names.append(name)


app.layout = html.Div([
    html.H1(children='Search Page'),

    html.Div([
        dcc.Dropdown(
            id='search-term-in',
            options=[{'label': i, 'value': i} for i in names],
            value='Search here...',
            style={'fontSize': 18}
        ),
    ],
        style={'width': '40%', 'display': 'inline-block'}),

    html.Div([
        html.Button(
            id='search-button',
            n_clicks=0,
            children='Search',
            style={'fontSize':18, 'marginLeft':'30px'}
        ),
    ], style={'width': '15%', 'display':'inline-block'}),

    html.Div([
            dcc.Dropdown(
                id='tag',
                options=[{'label': 'Database', 'value': 'Database'},
                         {'label': 'Data Set', 'value': 'Data Set'},
                         {'label': 'Table', 'value': 'Table'},
                         {'label': 'Column', 'value': 'Column'},
                         {'label': 'Description', 'value': 'Description'},
                         {'label': 'Data flow', 'value': 'Data flow'}],
                value='Search everything',
                style={'fontSize': 18}
            ),
    ], style={'width': '40%', 'float': 'right', 'display':'inline-block'}),

    html.Div([
    dcc.Markdown(id = 'markdown')
    ]),

    html.Div([
        html.Img(id='hover-image', src='children', height=300)
        ], style={'paddingTop':35})


])



@app.callback(
    Output(component_id='markdown', component_property='children'),
    [Input(component_id='search-term-in', component_property='value'),
     Input(component_id='tag', component_property='value')]
)
def update_description(kw, tag):
    if tag == 'Description':
        index = names.index(kw)
        desc = data[index]['description']
        return desc


@app.callback(
    Output('hover-image', 'src'),
    [Input('search-term-in', 'value'),
     Input('tag', 'value')])
def callback_image(kw, tag):
    if tag == 'Data flow':
        if kw in ['CLV Model', 'CustomerLifetimeValue_AC']:
            image_file = '/Users/astrophy/PycharmProjects/data_marketplace/clv_model.png'
        elif kw in ['pc_policy', 'policycenter']:
            image_file = '/Users/astrophy/PycharmProjects/data_marketplace/policy_center.png'
        elif kw in ['clv_score', 'clv score']:
            image_file = '/Users/astrophy/PycharmProjects/data_marketplace/clv.png'
    return encode_image(image_file)



if __name__ == '__main__':
    app.run_server()
