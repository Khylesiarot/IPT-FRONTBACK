from django.contrib import admin
from .models import Users,Flights,Bookedflights

# Register your models here.

admin.site.register(Users)
admin.site.register(Flights)
admin.site.register(Bookedflights)