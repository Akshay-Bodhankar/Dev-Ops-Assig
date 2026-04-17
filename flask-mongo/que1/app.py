from flask import Flask, jsonify
import json 

app = Flask(__name__)

# API route

@app.route('/api', methods=['GET'])
def get_data():
    with open('data.json', 'r') as f:
        data = json.load(f)
    return jsonify(data)


if __name__ == '__main__':
    app.run(debug=True)