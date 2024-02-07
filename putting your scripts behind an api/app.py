from flask import Flask, request, jsonify
import subprocess

app = Flask(__name__)

@app.route('/weather', methods=['GET'])
def get_weather():
    zip_code = request.args.get('zip')
    country_code = request.args.get('country', 'us')

    if not zip_code:
        return jsonify({'error': 'ZIP code is required'}), 400

    script_path = './weather.sh'

    try:
        result = subprocess.run([script_path, zip_code, country_code], capture_output=True, text=True, check=True)
        output = result.stdout
    except subprocess.CalledProcessError as e:
        output = e.output

    return jsonify({'response': output})

@app.route('/systemstats', methods=['GET'])
def systemstats():

    script_path = './systemstats.sh'

    try:
        result = subprocess.run([script_path], capture_output=True, text=True, check=True)
        output = result.stdout
    except subprocess.CalledProcessError as e:
        output = e.output

    return jsonify({'response': output})

@app.route('/systemstats_remote', methods=['GET'])
def systemstats_remote():
    remote_user  = request.args.get('user')
    remote_host = request.args.get('host')
    script_path = './systemstats_remote.sh'

    try:
        result = subprocess.run([script_path, remote_user, remote_host], capture_output=True, text=True, check=True)
        output = result.stdout
    except subprocess.CalledProcessError as e:
        output = e.output

    return jsonify({'response': output})

if __name__ == '__main__':
    app.run(debug=True, port="8080", host="0.0.0.0")
