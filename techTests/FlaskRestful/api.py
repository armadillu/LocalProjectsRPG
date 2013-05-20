from flask import Flask, request, render_template
from flask.ext.restful import Resource, Api

app = Flask(__name__)
api = Api(app)

todos = {}

###############################################

@app.route('/admin', methods=['POST', 'GET'])
def showForm():
	title = request.form.get('title', '')
	text = request.form.get('text', '')
	if (title and text):
		result = { 'title' : title, 'text' : text }
		return render_template('form.html', stuff = result )
	else:
		return render_template('form.html')

###############################################

class TodoSimple(Resource):
    def get(self, todo_id):
        return {todo_id: todos[todo_id]}

    def put(self, todo_id):
        todos[todo_id] = request.form['data']
        return {todo_id: todos[todo_id]}

api.add_resource(TodoSimple, '/<string:todo_id>')



if __name__ == '__main__':
    app.run(debug=True)