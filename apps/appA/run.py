import os
import boto3
from io import BytesIO
from flask import Flask, jsonify

app = Flask(__name__)
app.config['AWS_SERVER_PUBLIC_KEY'] = os.getenv('AWS_SERVER_PUBLIC_KEY')
app.config['AWS_SERVER_SECRET_KEY'] = os.getenv('AWS_SERVER_SECRET_KEY')

@app.route('/')
def index():
  session = boto3.Session(
    aws_access_key_id=app.config['AWS_SERVER_PUBLIC_KEY'],
    aws_secret_access_key=app.config['AWS_SERVER_SECRET_KEY'],
  )
  s3_client = session.client('s3')
  f = BytesIO()
  s3_client.download_fileobj('devops-tests-emorini', 'test.txt', f)
  bytes_content = f.getvalue()
  return jsonify({'message': bytes_content.decode("utf-8")}), 200

if __name__ == '__main__':
  app.run(debug=False,host='0.0.0.0')