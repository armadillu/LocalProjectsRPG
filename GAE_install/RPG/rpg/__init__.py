from flask import Flask, request, render_template, redirect, url_for
from flask.ext.restful import reqparse, abort, Api, Resource
from pymongo import MongoClient

app = Flask(__name__) # in __init__.py
api = Api(app)


QUESTIONS = [
	{"questionID" : "question1","question" : "what are monkeys?"},
	{"questionID" : "question2","question" : "what are bananas?"},
	{"questionID" : "question3","question" : "what are we doing here?"}
]

#to parse incoming data fields
parser = reqparse.RequestParser()
parser.add_argument('question', type=str)

## DB ###################################################################

client = MongoClient( 'mongodb://oriol:ferrer@widmore.mongohq.com:10010/localProjectsTest' )
db = client["localProjectsTest"]
questionsCol = db['questions'];

def initDB():
	questionsCol.drop();
	for row in QUESTIONS:
		print "inserting into QUESTIONS DB: " + str(row)
		questionsCol.insert(row);


## CHECKS ###############################################################

def abortIfQuestionDoesNotExist(questionID):
	if len(dataForQuestionID(questionID)) <= 0:
		abort(404, message="Question {} doesn't exist".format(questionID))

## DATA ACCESS ###########################################################

def dataForQuestionID(questionID):
	cursor = questionsCol.find( {"questionID":questionID},{'questionID':1, 'question':1, "_id":0 } )
	results = []
	for question in cursor:
		results.append(question)
	return results;

def removeFromQuestions(questionID):
	res = dataForQuestionID(questionID)
	print "about to delete Question " + str(res)
	for r in res:
		questionsCol.remove( {"questionID":questionID} )
	
def allQuestions():
	cursor = questionsCol.find( {},{'questionID':1, 'question':1, "_id":0 } )
	results = []
	for question in cursor:
		results.append(question)
	return results;

def addQuestion(questionText):
	numQuestions = questionsCol.count();
	questionID = 'question' + str( numQuestions + 1); #TODO check for dup!
	newQ = 	{
				'question' : questionText,
				'questionID' : questionID
			}
	print( "adding new Question: " + str(newQ) )
	questionsCol.insert(newQ)
	return questionID;

def updateQuestion(questionText, questionID):
	newQ = 	{
				'question' : questionText,
				'questionID' : questionID
			}
	print( "updating Question: " + str(newQ) )
	removeFromQuestions(questionID);
	questionsCol.insert(newQ)

	
## QUESTIONS ###############################################################

class Question(Resource):
	def get(self, questionID): 								#get a question by its ID
		abortIfQuestionDoesNotExist(questionID)
		return dataForQuestionID(questionID)

	def delete(self, questionID): 							#delete a question by its ID
		abortIfQuestionDoesNotExist(questionID)
		removeFromQuestions(questionID)
		return '', 204

	def post(self, questionID): 							#update a particular question by its ID
		abortIfQuestionDoesNotExist(questionID)
		args = parser.parse_args()
		updateQuestion(args['question'], questionID)
		return dataForQuestionID(questionID), 201

class QuestionsList(Resource):
    def get(self):											#get all questions
        return allQuestions()

    def post(self): 										#add a new question
		args = parser.parse_args()
		question = args['question'];
		qID = addQuestion(question)
		return [{"questionID" : qID , "question" : question }]; #return the question ID

## ADMIN #################################################################


@app.route('/')
def siteRoot():
	return redirect(url_for('admin'))

@app.route('/admin')
@app.route('/admin/')
def admin():
	return render_template('admin.html')


## setup the API #########################################################

api.add_resource(QuestionsList, '/questions')
api.add_resource(Question, '/questions/<string:questionID>')
initDB() #start with a clean DB 

print "\n\n\n\n\n\n"

if __name__ == '__main__':
    app.run(debug=True)
