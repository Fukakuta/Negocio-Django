#!/usr/bin/env bash
set -o errexit

pip install -r requirements.txt
python manage.py collectstatic --no-input
python manage.py migrate

python manage.py shell -c "
import os
from django.contrib.auth import get_user_model

User = get_user_model()
username = os.environ.get('DJANGO_SUPERUSER_USERNAME')
email = os.environ.get('DJANGO_SUPERUSER_EMAIL')
password = os.environ.get('DJANGO_SUPERUSER_PASSWORD')

if username and password:
    user, created = User.objects.get_or_create(username=username)
    user.email = email or ''
    user.set_password(password)
    user.is_superuser = True
    user.is_staff = True
    user.save()
    print('Superusuario listo desde variables de Render.')
"
