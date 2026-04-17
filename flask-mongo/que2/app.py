from flask import Flask, render_template, request, redirect, url_for
from pymongo import MongoClient

app = Flask(__name__)

client = MongoClient('mongodb://localhost:27017/')
db = client['student_db']
collection = db['students']

@app.route('/')
def form():
    return render_template('form.html')

@app.route('/submit', methods=['POST'])
def submit():
    try:
        name = request.form['name']
        age = int(request.form['age'])

        collection.insert_one({
            'name': name, 
            'age': age
        })
        return redirect(url_for("success"))

    except Exception as e:
        print(f"Error: {e}")
        return render_template('form.html', error=str(e))
    
@app.route('/success')
def success():
    return render_template('success.html')

if __name__ == '__main__':
    app.run(debug=True)