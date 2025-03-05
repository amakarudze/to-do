from django.urls import reverse


def test_register_user(client):
    response = client.get(reverse("accounts:register"))
    assert response.status_code == 200


def test_login(client):
    pass
