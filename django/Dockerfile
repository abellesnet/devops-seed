FROM python:3.5.2

MAINTAINER Alexis Bellés Marzà

RUN pip install --upgrade pip

RUN pip install gunicorn

RUN pip install circus

WORKDIR /var/django

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY . .

RUN python manage.py collectstatic --noinput --settings=app.settings_prod

EXPOSE 8000

RUN chmod +x docker-entrypoint.sh

ENTRYPOINT ["/var/django/docker-entrypoint.sh"]
