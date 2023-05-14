
import dash
from dash import dcc
from dash import html
from dash.dependencies import Input, Output, State
import dash_bootstrap_components as dbc
import numpy as np
import pickle
import pandas as pd
### Setup ###################################################
from dash import Dash, dash_table, dcc, html
import dash_table
app = dash.Dash(__name__)
app.title = 'Machine Learning Model Deployment'
server = app.server
### load ML model ###########################################
with open('xgb_medical_cost_model.pickle', 'rb') as f:
    xgb = pickle.load(f)
### App Layout ###############################################
import time





'''
app.layout = html.Div([
    dbc.Row([html.H3(children='Predict Iris Flower Species')]),
    dbc.Row([
        dbc.Col(html.Label(children='Sepal Length (CM):'), width={"order": "first"}),
        dbc.Col(dcc.Slider(min=4, max=8, value = 5.8, id='sepal_length')) 
    ]),
    dbc.Row([
        dbc.Col(html.Label(children='Sepal Width (CM):'), width={"order": "first"}),
        dbc.Col(dcc.Slider(min=2.0, max=5,  value = 3.0, id='sepal_width')) 
    ]),
    dbc.Row([
        dbc.Col(html.Label(children='Petal Length (CM):'), width={"order": "first"}),
        dbc.Col(dcc.Slider(min=1.0, max=7,  value = 3.8, id='petal_length')) 
    ]),
    dbc.Row([
        dbc.Col(html.Label(children='Petal Width (CM):'), width={"order": "first"}),
       dbc.Col( dcc.Slider(min=0.1, max=3,  value = 1.2, id='petal_width')) 
    ]),   
    dbc.Row([dbc.Button('Submit', id='submit-val', n_clicks=0, color="primary")]),
    html.Br(),
    dbc.Row([html.Div(id='prediction output')])
    
    ], style = {'padding': '0px 0px 0px 150px', 'width': '50%'})


    '''


params = ['age', 'sex', 'bmi', 'children', 'smoker', 'region', 'charges']
OutputFrame= pd.DataFrame( columns= params)


app.layout = html.Div(
    [  'Age: ',
 dcc.Input(
            id="age",
            type="number",
            placeholder="input type {}".format("age"),
        ),    html.Div([



 'Sex: ',
        dcc.RadioItems(['female', 'male',], 'female',  id="sex"), 'MBTI: ']),
        dcc.Input(
            id="bmi",
            type="number",
            placeholder="input type {}".format("bmi"),
        ), 'Children: ',
        dcc.Input(
            id="children",
            type="number",
            placeholder="input type {}".format("children"),
        ),  
        html.Div([



        'Smoker: ',
        dcc.RadioItems(['yes', 'no',], 'no',  id="smoker"), 'Region: ']),
        dcc.Dropdown(['NW - northwest', 'NE - northeast', 'SE - southeast', 'SW -southwest'], 'NW - northwest', multi=False, id="region",  placeholder="input type {}".format("region")),
        html.Button('Submit', id='submit-button'),
        html.Div(id='output-charge',
             children='Fill in the details and click submit')                   

    ]
    +  
    [ html.Div([
    html.Table(id='table-output')

])]+
    
    [html.Div(id="out-all-types")]
)





### Callback to produce the prediction ######################### 
@app.callback(
    Output('output-charge', 'children'),
    Input('submit-button', 'n_clicks'),
    State('age', 'value'),
    State('sex', 'value'),
    State('bmi', 'value'), 
    State('children', 'value'),
    State('smoker', 'value'),
    State('region', 'value')
)

def update_output(n_clicks, age, sex, bmi, children, smoker, region): 
    age=int(age or 0)
    sex=str(sex)
    bmi=int(bmi or 0)
    children=int(children or 0)

    x = [age, sex, bmi, children, smoker, region]
    columns=['age', 'sex', 'bmi', 'children', 'smoker', 'region']
    Trials= pd.DataFrame([x], columns= columns)
    prediction = xgb.predict(Trials)
    prediction=np.where(prediction>0, prediction,0 )
    output=np.expm1(prediction)
    Trials['charges']= int(output)
    Trials
    global OutputFrame

    if(age<18):
        return f'Wprowadź dane .'
    else:
        OutputFrame=pd.concat([OutputFrame, Trials])

        return f'Predicted charge is region {output} .'


@app.callback(Output('table-output', 'children'), Input('submit-button', 'n_clicks'), prevent_initial_call=True)
def update_table(jsonified_cleaned_data):

    # more generally, this line would be
    # json.loads(jsonified_cleaned_data)
    time.sleep(0.1)
    table = dbc.Table.from_dataframe(OutputFrame, striped=True, bordered=True, hover=True)
    return table




### Run the App ###############################################
if __name__ == '__main__':
    app.run_server(debug=True)