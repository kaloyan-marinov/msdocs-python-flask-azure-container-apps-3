from flask import Flask


app = Flask(__name__)


@app.route('/api/todos')
def get_items():
   return {
      'todos': [
         {'id': 1, 'description': 'work out'},
         {'id': 2, 'description': 'take a shower'},
         {'id': 3, 'description': 'buy groceries'},
         {'id': 4, 'description': 'cook dinner'},
      ]
   }


if __name__ == '__main__':
   app.run()
