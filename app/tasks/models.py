from django.contrib.auth.models import User
from django.db import models


class Task(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    title = models.CharField(max_length=255)
    description = models.TextField()
    due_date = models.DateTimeField()
    completed = models.BooleanField(default=False)

    class Meta:
        """Metadata options for the Task model."""
        managed = True

    def __str__(self) -> str:
        """Return the string representation of the task."""
        return self.title
