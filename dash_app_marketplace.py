import dash
import dash_auth
import dash_core_components as dcc
import dash_html_components as html
from dash.dependencies import Input, Output, State
from datetime import datetime
import pandas as pd

USERNAME_PASSWORD_PAIRS = [['username', 'password'],
                           ['Kancharla', '24/06'],
                           ['Brown', '06/08'],
                           ['Heusen', '14/03',],
                           ['Jalalpour', '07/02'],
                           ['Wickens', '27/03'],
                           ['Eyre', '01/12']]

app = dash.Dash()
auth = dash_auth.BasicAuth(app, USERNAME_PASSWORD_PAIRS)

app.layout = html.Div([
    html.H1(children='Search Page'),

    html.Div([
        dcc.Input(
            id='search-term-in',
            type='text',
            value='Search here...',
            style={'fontSize': 28}
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
                id='xaxis-column',
                options=[{'label': 'Database', 'value': 'Database'},
                         {'label': 'Data Set', 'value': 'Data Set'},
                         {'label': 'Table', 'value': 'Table'},
                         {'label': 'Column', 'value': 'Column'}],
                value='Search everything'
            ),
    ], style={'width': '40%', 'float': 'right', 'display':'inline-block'})


])


if __name__ == '__main__':
    app.run_server()
