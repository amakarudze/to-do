import pytest
from django.contrib.auth.models import User
from django.test import Client

from tasks.models import Task


@pytest.fixture
def client(db):
    client = Client()
    return client


@pytest.fixture
def admin(db):
    """Fixture to create an admin user."""
    user = User.objects.create_superuser(
        username="carl",
        email="carl@test.com",
        first_name="Carl",
        last_name="Doe",
        password="pass1234"
    )
    return user

@pytest.fixture
def task(db, admin):
    task = Task.objects.create(
        user=admin,
        title="Brainstorming",
        description="A to do app.",
        due_date="2025-03-01",
        completed=False

    )
    return task
