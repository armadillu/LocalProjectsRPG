
### http://f.souza.cc/2010/08/flying-with-flask-on-google-app-engine.html

from google.appengine.ext.webapp.util import run_wsgi_app
from rpg import app


run_wsgi_app(app)