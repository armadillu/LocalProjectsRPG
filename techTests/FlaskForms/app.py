from flask import Flask, request, render_template

# create our little application :)
app = Flask(__name__)


@app.route('/', methods=['POST', 'GET'])
def showForm():
	#request.form to access POST DATA!
	#request.GET to access GET DATA!
	title = request.form.get('title', '')
	text = request.form.get('text', '')
	if (title and text):
		result = { 'title' : title, 'text' : text }
		return render_template('form.html', stuff = result )
	else:
		return render_template('form.html')

if __name__ == '__main__':
    app.run(debug=True)
