from flask import Flask
from flask.ext.restful import reqparse, abort, Api, Resource

app = Flask(__name__)
api = Api(app)

QUESTIONS = [
	{"questionID" : "question1","question" : "what are monkeys?"},
	{"questionID" : "question2","question" : "what are bananas?"},
	{"questionID" : "question3","question" : "what are we doing here?"}
]

TOKENS = [
	{"tokenID" : "token1","token" : "Income Tax"},
	{"tokenID" : "token2","token" : "Education Level"},
	{"tokenID" : "token3","token" : "Public Health"	}
]

QUESTIONTOKENVALUES = [
	{"questionID": 'question1', 
	"tokenValues":
		[
		{"tokenID": 'token1', "values": {"yes":0, "no":5}},
		{"tokenID": 'token2', "values": {"yes":-3, "no":2}}, 
		{"tokenID": 'token3', "values": {"yes":5, "no":-3}}
		]
	},
	{"questionID": 'question2', 
	"tokenValues":
		[
		{"tokenID": 'token1', "values": {"yes":1, "no":2}},
		{"tokenID": 'token2', "values": {"yes":-1, "no":-1}}, 
		{"tokenID": 'token3', "values": {"yes":2, "no":-0}}
		]
	}
]

TODOS = {
    'todo1': {'task': 'build an API'},
    'todo2': {'task': '?????'},
    'todo3': {'task': 'profit!'},
}


parser = reqparse.RequestParser()
parser.add_argument('question', type=str)
parser.add_argument('token', type=str)
parser.add_argument('yes', type=str)
parser.add_argument('no', type=str)


## CHECKS #######################################################

def abortIfTokenDoesNotExist(tokenID):
	if (len(dataForTokenID(tokenID))==0):
		abort(404, message="Token {} doesn't exist".format(tokenID))

def abortIfQuestionDoesNotExist(questionID):
	if len(dataForQuestionID(questionID))==0:
		abort(404, message="Question {} doesn't exist".format(questionID))

## DATA ACCESS ###################################################

def dataForTokenID(tokenID):
	res = [x for x in TOKENS if x["tokenID"]==tokenID]
	return res

def dataForQuestionID(questionID):
	res = [x for x in QUESTIONS if x["questionID"]==questionID]
	return res

def removeFromTokens(tokenID):
	res = dataForTokenID(tokenIDID)
	print "about to delete " + str(res)
	del TOKEN[res]

def removeFromQuestions(questionID):
	res = dataForQuestionID(questionID)
	print "about to delete " + str(res)
	del QUESTIONS[res]


#################################################################


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
        TODOS[questionID] = task
        return task, 201


# TodoList
#   shows a list of all todos, and lets you POST to add new tasks
class TodoList(Resource):
    def get(self):
        return TODOS

    def post(self):
        args = parser.parse_args()
        todo_id = 'todo%d' % (len(TODOS) + 1)
        TODOS[todo_id] = {'task': args['task']}
        return TODOS[todo_id], 201

##
## Actually setup the Api resource routing here
##
#api.add_resource(TodoList, '/todos')
api.add_resource(Question, '/questions/<string:questionID>')


if __name__ == '__main__':
    app.run(debug=True)
    