from flask import Flask, request
from pymongo import MongoClient

app = Flask(__name__)

client = MongoClient("mongodb://mongo:27017/")
db = client["todo_db"]
collection = db["todo_items"]

@app.route('/submittodoitem', methods=['POST'])
def submit():
    data = request.json or request.form
    print(f"Received data: {data}")
    collection.insert_one({
        "itemName": data.get("itemName"),
        "itemDescription": data.get("itemDescription")
    })

    return "Saved!"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)