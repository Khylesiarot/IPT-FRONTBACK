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
    booked_flight_ids = Bookedflights.objects.values_list('flight_id', flat=True)
    flights = Flights.objects.exclude(id__in=booked_flight_ids)
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
    booked_flight_ids = Bookedflights.objects.filter(user_id=user_id, is_cancelled=False).values_list('flight_id', flat=True)
    booked_flights = Flights.objects.filter(id__in=booked_flight_ids)
    serialized_flights = FlightsSerializer(booked_flights, many=True)
    return Response(serialized_flights.data) 

@api_view(['GET'])
def get_cancelled_flights(request,user_id):
    cancelled_flight_ids = Bookedflights.objects.filter(user_id= user_id,is_cancelled=True).values_list('flight_id', flat=True)
    cancelled_flights = Flights.objects.filter(id__in=cancelled_flight_ids)
    serialized_flights = FlightsSerializer(cancelled_flights, many=True)
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
@api_view(['POST'])
def register_user(request):
    email = request.data.get('email')
    if Users.objects.filter(email=email).exists():
        return Response({'error': 'Email already exists'}, status=400)

    serializer = UsersSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data, status=201)
    return Response(serializer.errors, status=400)