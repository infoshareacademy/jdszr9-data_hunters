from flask import Flask
app = Flask(__name__)

@app.route('/') 
def IsSelf() :
    return 'Hello 这是自'

app.run()