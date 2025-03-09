from django.urls import path

from . import views

app_name = "tasks"


urlpatterns = [
    path("", views.home, name="home"),
    path("create_task/", views.create_task, name="create_task"),
    path("view_task/<int:id>/", views.view_task, name="task"),
]

