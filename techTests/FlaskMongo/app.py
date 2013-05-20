from flask import Flask
from pymongo import MongoClient

app = Flask(__name__)

client = MongoClient( 'mongodb://oriol:ferrer@widmore.mongohq.com:10010/localProjectsTest' )
db = client["localProjectsTest"]

#################################################################

@app.route("/")
def hello():
	return "Hello World!"


@app.route("/mongo1")
def find():
	dbDocs = []

	for fruit in db['people'].find():
		dbDocs.append(fruit)

	print fruit
	return str(dbDocs)
    
    
#################################################################

if __name__ == "__main__":
	app.run(debug=True)
	
