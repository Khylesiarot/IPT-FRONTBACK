from django.http import JsonResponse
from rest_framework.decorators import api_view, APIView
from rest_framework.response import Response
from django.contrib.auth import authenticate, login
from django.views.decorators.csrf import csrf_exempt
from api.models import Users,Flights, Bookedflights
from .serializer import UsersSerializer, FlightsSerializer,BookedflightsSerializer
from django.shortcuts import get_object_or_404
from rest_framework import status


@csrf_exempt
@api_view(['POST'])
def login_view(request):
    email = request.data.get('email')
    password = request.data.get('password')

    # Check if user with given email exists
    try:
        user = Users.objects.get(email=email)
        if user.password == password:
            return Response({'status': 'Email not found'},status=200)
    except Users.DoesNotExist:
        return Response({'status': 'Email not found'}, status=400)

    
    return Response({'status': 'Invalid password'}, status=401)


@api_view(['GET'])
@csrf_exempt
def users_list(request, email= ""):
   users = Users.objects.all()
   serializer = UsersSerializer(users, many=True)
   return Response(serializer.data)

    
@api_view(['GET'])
@csrf_exempt
def get_flights(request):
    flights = Flights.objects.all()
    serializer = FlightsSerializer(flights, many=True)
    return Response(serializer.data)

@api_view(['GET'])
@csrf_exempt
def getBookedFlights(request):
    booked_flights = Bookedflights.objects.all()
    serializer = BookedflightsSerializer(booked_flights, many=True)
    return Response(serializer.data)


@csrf_exempt
@api_view(['GET'])
def get_user_by_email(request, email):
    try:
        user = Users.objects.get(email=email)
        serializer = UsersSerializer(user)
        return Response(serializer.data)
    except Users.DoesNotExist:
        return Response(status=404)
    
    
# @csrf_exempt
# @api_view(['POST'])
# def create_booked_flight(request):
#     user_id = request.data.get('user_id')
#     flight_id = request.data.get('flight_id')

#     user = get_object_or_404(Users, userId=user_id)
#     flight = get_object_or_404(Flights, id=flight_id)

#     serializer = BookedflightsSerializer(data=request.data)
#     serializer.is_valid(raise_exception=True)
#     serializer.save(user=user, flight=flight)

#     return Response(serializer.data, status=201)


@api_view(['GET'])
@csrf_exempt
def getUserBookedFlights(request, user_id):
    try:
        user = Users.objects.get(userId=user_id)
        booked_flights = Bookedflights.objects.filter(user=user)
        serializer = BookedflightsSerializer(booked_flights, many=True)
        return Response(serializer.data)
    except Users.DoesNotExist:
        return Response({'error': 'User not found'}, status=404)




@api_view(['GET'])
def get_user_booked_flights(request, user_id):
    booked_flight_ids = Bookedflights.objects.filter(user_id=user_id).values_list('flight_id', flat=True)
    booked_flights = Flights.objects.filter(id__in=booked_flight_ids)
    serialized_flights = FlightsSerializer(booked_flights, many=True)
    return Response(serialized_flights.data) 




@api_view(['PUT', 'POST', 'GET'])
def cancel_booked_flight(request, user_id, flight_id):
    booked_flight = get_object_or_404(Bookedflights, user_id=user_id, flight_id=flight_id)
    booked_flight.is_cancelled = True
    booked_flight.save()
    return Response({'message': 'Booked flight cancelled successfully.'}, status=201)


@api_view(['PUT', 'POST', 'GET'])
def rebooked_flight(request, user_id, flight_id):
    booked_flight = get_object_or_404(Bookedflights, user_id=user_id, flight_id=flight_id)
    booked_flight.is_cancelled = False
    booked_flight.save()
    return Response({'message': 'Flight booked successfully.'}, status=201)

#----
@csrf_exempt
@api_view(['POST'])
def create_booked_flight(request):
    serializer = BookedflightsSerializer(data=request.data)
    serializer.is_valid(raise_exception=True)

    user_id = request.data.get('user')
    flight_id = request.data.get('flight')

    # Retrieve the user and flight objects
    user = get_object_or_404(Users, userId=user_id)
    flight = get_object_or_404(Flights, id=flight_id)

    # Check if the flight is already booked by the user
    if Bookedflights.objects.filter(user=user, flight=flight).exists():
        return Response({'message': 'Flight is already booked by the user.'}, status=status.HTTP_400_BAD_REQUEST)

    serializer.save(user=user, flight=flight)

    return Response(serializer.data, status=status.HTTP_201_CREATED)
#---


@csrf_exempt
def register_user(request):
    if request.method == 'POST':
        data = request.POST
        userId = data.get('userId')
        email = data.get('email')
        password = data.get('password')
        firstname = data.get('firstname')
        lastname = data.get('lastname')

        try:
            user = Users(userId=userId, email=email, password=password, firstname=firstname, lastname=lastname)
            user.save()
            return Response({'message': 'User registered successfully.'})
        except Exception as e:
            return Response({'error': str(e)}, status=500)

    return Response({'error': 'Invalid request method.'}, status=400)