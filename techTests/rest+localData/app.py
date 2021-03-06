from flask import Flask
from flask.ext.restful import reqparse, abort, Api, Resource

app = Flask(__name__)
api = Api(app)

QUESTIONS = [
	{"questionID" : "question1","question" : "what are monkeys?"},
	{"questionID" : "question2","question" : "what are bananas?"},
	{"questionID" : "question3","question" : "what are we doing here?"}
]


parser = reqparse.RequestParser()
parser.add_argument('question', type=str)

## CHECKS #######################################################

def abortIfTokenDoesNotExist(tokenID):
	if (len(dataForTokenID(tokenID))==0):
		abort(404, message="Token {} doesn't exist".format(tokenID))

def abortIfQuestionDoesNotExist(questionID):
	if len(dataForQuestionID(questionID))==0:
		abort(404, message="Question {} doesn't exist".format(questionID))

## DATA ACCESS ###################################################


def dataForQuestionID(questionID):
	res = [x for x in QUESTIONS if x["questionID"]==questionID]
	return res

def removeFromQuestions(questionID):
	res = dataForQuestionID(questionID)
	print "about to delete Question " + str(res)
	print str(QUESTIONS)
	for r in res:
		QUESTIONS.remove(r)
	
def allQuestions():
	return QUESTIONS;

	
def addQuestion(args):
	questionID = 'question'+str( len(QUESTIONS) + 1);
	if questionID in 
	newQ = 	{
				'question:' : args['question'],
				'questionID:' : 'question'+str( len(QUESTIONS) + 1)
			}
	print( "adding new Question " + str(newQ) )
	QUESTIONS.append(newQ)
	

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


if __name__ == '__main__':
    app.run(debug=True)
    