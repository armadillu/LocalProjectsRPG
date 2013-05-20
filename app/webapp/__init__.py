from flask import Flask
from flask.ext.restful import reqparse, abort, Api, Resource
from pymongo import MongoClient

app = Flask(__name__)
api = Api(app)
connection = MongoClient('mongodb://oriol:ferrer@widmore.mongohq.com:10010/localProjectsTest')
db = connection["localProjectsTest"]

from restAPI import *
from admin import *
