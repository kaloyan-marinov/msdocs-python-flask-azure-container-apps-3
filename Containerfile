FROM python:slim

COPY requirements.txt requirements.txt
RUN pip install --upgrade pip
RUN pip install -r requirements.txt
RUN pip install gunicorn pymysql cryptography

COPY src src
# COPY migrations migrations
# COPY microblog.py config.py boot.sh ./
COPY boot.sh ./
RUN chmod a+x boot.sh

# ENV FLASK_APP microblog.py
ENV FLASK_APP src/app.py
# RUN flask translate compile

EXPOSE 5000
ENTRYPOINT ["./boot.sh"]
