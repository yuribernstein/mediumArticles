from flask import Flask, render_template, request, redirect, url_for, flash, jsonify, Response
import waitress
import os
import detector as dt

detector = dt.detector()

app = Flask(__name__)


@app.route('/health', methods=['GET'])
def health():
    return jsonify({'status': 'ok'})

@app.route('/analyze', methods=['POST'])
def analyze():
    data = request.get_json()
    text = data['text']
    result = detector.analyze_text(text)
    return jsonify(result)

if __name__ == '__main__':
    if os.getenv('ENV') == 'development':
        app.run(debug=True, port=8080, host='0.0.0.0')
    else:
        from waitress import serve
        serve(app, host='0.0.0.0', port=8080)