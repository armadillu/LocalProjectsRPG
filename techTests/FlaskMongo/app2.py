from flask import Flask
from pymongo import MongoClient

client = MongoClient( 'mongodb://oriol:ferrer@widmore.mongohq.com:10010/localProjectsTest' )
db = client["localProjectsTest"]


def searchQuestion(d1):


for entry in db['questionPoints'].find():
	
	print entry

print("end");
    
   