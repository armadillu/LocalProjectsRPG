from flask import Flask
from flask.ext.restful import reqparse, abort, Api, Resource
from pymongo import MongoClient

app = Flask(__name__)
api = Api(app)

QUESTIONS = [
	{"questionID" : "question1","question" : "what are monkeys?"},
	{"questionID" : "question2","question" : "what are bananas?"},
	{"questionID" : "question3","question" : "what are we doing here?"}
]

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
	if dataForQuestionID(questionID).count() <= 0:
		abort(404, message="Question {} doesn't exist".format(questionID))

## DATA ACCESS ###########################################################

def dataForQuestionID(questionID):
	res = questionsCol.find({"questionID":"question1"});
	return res

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

def addQuestion(args):
	numQuestions = questionsCol.count();
	questionID = 'question' + str( numQuestions + 1); #TODO!
	newQ = 	{
				'question' : args['question'],
				'questionID' : questionID
			}
	print( "adding new Question: " + str(newQ) )
	questionsCol.insert(newQ)
	
## QUESTIONS ###############################################################

class Question(Resource):
    def get(self, questionID):
        abortIfQuestionDoesNotExist(questionID)
        return dataForQuestionID(questionID)

    def delete(self, questionID):
        abortIfQuestionDoesNotExist(questionID)
        removeFromQuestions(questionID)
        return '', 204

    def put(self, questionID):
        args = parser.parse_args()
        question = {'question': args['question']}
        print(question)
        #TODOS[questionID] = question
        return question, 201

class QuestionsList(Resource):
    def get(self):
        return allQuestions()

    def post(self):
        args = parser.parse_args()
        addQuestion(args)
        return ''

## setup the API ##################################################

api.add_resource(QuestionsList, '/questions')
api.add_resource(Question, '/questions/<string:questionID>')
initDB() #start with a clean DB 

print "\n\n\n\n\n\n"

if __name__ == '__main__':
    app.run(debug=True)
