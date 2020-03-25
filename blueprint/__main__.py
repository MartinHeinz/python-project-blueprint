from flask import Flask, request

app = Flask(__name__)


@app.route("/")
def echo():
    return f"You said: {request.args.get('text', '')}\n"


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
