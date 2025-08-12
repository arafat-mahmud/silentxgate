from django.urls import path
from vpn_api.views import server_list

urlpatterns = [
    path('api/servers/', server_list),
]
