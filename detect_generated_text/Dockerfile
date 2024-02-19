FROM python:3.9-alpine
WORKDIR /detector
COPY . /detector
RUN rm -rf __pycache__
RUN pip install -r requirements.txt
EXPOSE 8080
CMD ["python", "app.py"]