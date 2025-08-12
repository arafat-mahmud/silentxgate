from rest_framework.decorators import api_view
from rest_framework.response import Response

@api_view(['GET'])
def server_list(request):
    servers = [
        {"name": "USA-SilentX", "ip": "vpn.usa.silentxgate.com", "speed": "1Gbps"},
        {"name": "Europe-SilentX", "ip": "vpn.eu.silentxgate.com", "speed": "500Mbps"},
    ]
    return Response(servers)
