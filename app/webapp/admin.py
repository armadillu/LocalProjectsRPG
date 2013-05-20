from flask import Flask, render_template, request
from flask.ext.restful import reqparse, abort, Api, Resource
from pymongo import MongoClient
from wtforms.ext.appengine.db import model_form

from webapp import app



@app.route("/admin")
def admin():
	#form = RegistrationForm(request.POST)
	#app.logger.debug('A value for debugging')
	return render_template('index.html')


