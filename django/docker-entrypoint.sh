#!/usr/bin/env bash

echo Using $(printenv DJANGO_SETTINGS_MODULE)

echo Migrating...

python manage.py migrate

echo Running app...

touch /var/log/gunicorn.access.log
touch /var/log/gunicorn.error.log

exec circusd django.ini \
    --log-level info \
    --log-output /var/log/circus.log \
    "$@"
