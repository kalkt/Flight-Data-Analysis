import pandas as pd
import numpy as np
import random
from datetime import datetime, timedelta

# Set random seed for reproducibility
np.random.seed(42)

# Function to generate airports
def generate_airports(num_airports=50):
    airports = []
    major_us_airports = [
        ('ATL', 'Hartsfield-Jackson Atlanta International Airport', 'Atlanta', 'GA'),
        ('LAX', 'Los Angeles International Airport', 'Los Angeles', 'CA'),
        ('ORD', "O'Hare International Airport", 'Chicago', 'IL'),
        ('DFW', 'Dallas/Fort Worth International Airport', 'Dallas', 'TX'),
        ('DEN', 'Denver International Airport', 'Denver', 'CO'),
        ('JFK', 'John F. Kennedy International Airport', 'New York', 'NY'),
        ('SFO', 'San Francisco International Airport', 'San Francisco', 'CA'),
        ('SEA', 'Seattle-Tacoma International Airport', 'Seattle', 'WA'),
        ('LAS', 'McCarran International Airport', 'Las Vegas', 'NV'),
        ('MCO', 'Orlando International Airport', 'Orlando', 'FL')
    ]
    
    for i in range(num_airports):
        if i < len(major_us_airports):
            airport = major_us_airports[i]
            airports.append({
                'airport_id': i + 1,
                'airport_code': airport[0],
                'airport_name': airport[1],
                'city': airport[2],
                'state': airport[3],
                'country': 'United States',
                'latitude': round(np.random.uniform(25, 48), 6),
                'longitude': round(np.random.uniform(-125, -70), 6)
            })
        else:
            # Generate additional airports
            airport_code = ''.join(random.choices('ABCDEFGHIJKLMNOPQRSTUVWXYZ', k=3))
            city = f"City_{i}"
            state = random.choice(['CA', 'NY', 'TX', 'FL', 'IL', 'PA', 'OH', 'GA', 'NC', 'MI'])
            
            airports.append({
                'airport_id': i + 1,
                'airport_code': airport_code,
                'airport_name': f"{city} International Airport",
                'city': city,
                'state': state,
                'country': 'United States',
                'latitude': round(np.random.uniform(25, 48), 6),
                'longitude': round(np.random.uniform(-125, -70), 6)
            })
    
    return pd.DataFrame(airports)

# Function to generate airlines
def generate_airlines(num_airlines=15):
    airlines_list = [
        ('Delta Air Lines', 'DL'),
        ('American Airlines', 'AA'),
        ('United Airlines', 'UA'),
        ('Southwest Airlines', 'WN'),
        ('JetBlue Airways', 'B6'),
        ('Alaska Airlines', 'AS'),
        ('Spirit Airlines', 'NK'),
        ('Frontier Airlines', 'F9'),
        ('Hawaiian Airlines', 'HA'),
        ('Allegiant Air', 'G4')
    ]
    
    airlines = []
    for i in range(num_airlines):
        if i < len(airlines_list):
            airline = airlines_list[i]
            airlines.append({
                'airline_id': i + 1,
                'airline_name': airline[0],
                'iata_code': airline[1],
                'country': 'United States'
            })
        else:
            # Generate additional airlines
            airline_name = f"Airline_{i}"
            airlines.append({
                'airline_id': i + 1,
                'airline_name': airline_name,
                'iata_code': ''.join(random.choices('ABCDEFGHIJKLMNOPQRSTUVWXYZ', k=2)),
                'country': 'United States'
            })
    
    return pd.DataFrame(airlines)

# Function to generate routes
def generate_routes(airports_df, num_routes=500):
    routes = []
    airport_ids = airports_df['airport_id'].tolist()
    
    for i in range(num_routes):
        origin = random.choice(airport_ids)
        destination = random.choice([aid for aid in airport_ids if aid != origin])
        
        routes.append({
            'route_id': i + 1,
            'origin_airport_id': origin,
            'destination_airport_id': destination,
            'distance_miles': round(np.random.uniform(100, 3000), 2)
        })
    
    return pd.DataFrame(routes)

# Function to generate flights
def generate_flights(airlines_df, routes_df, num_flights=15000):
    flights = []
    airlines = airlines_df['airline_id'].tolist()
    routes = routes_df['route_id'].tolist()
    
    start_date = datetime(2023, 1, 1)
    end_date = datetime(2023, 12, 31)
    
    for i in range(num_flights):
        airline_id = random.choice(airlines)
        route_id = random.choice(routes)
        
        # Randomize flight schedule
        scheduled_departure = start_date + timedelta(seconds=random.randint(0, int((end_date - start_date).total_seconds())))
        scheduled_journey_time = random.randint(45, 600)  # minutes
        scheduled_arrival = scheduled_departure + timedelta(minutes=scheduled_journey_time)
        
        # Determine flight status and actual times
        status_choices = ['On Time', 'Delayed', 'Canceled', 'Diverted']
        status = random.choices(status_choices, weights=[0.75, 0.15, 0.07, 0.03])[0]
        
        actual_departure = None
        actual_arrival = None
        actual_journey_time = None
        delay_minutes = 0
        cancellation_reason = None
        
        if status == 'On Time':
            actual_departure = scheduled_departure
            actual_arrival = scheduled_arrival
            actual_journey_time = scheduled_journey_time
        elif status == 'Delayed':
            delay_minutes = random.randint(15, 240)
            actual_departure = scheduled_departure + timedelta(minutes=delay_minutes)
            actual_arrival = scheduled_arrival + timedelta(minutes=delay_minutes)
            actual_journey_time = scheduled_journey_time + delay_minutes
        elif status == 'Canceled':
            cancellation_reason = random.choice(['Weather', 'Technical', 'Operational'])
        elif status == 'Diverted':
            delay_minutes = random.randint(30, 300)
        
        flight_number = f"{random.choice(airlines_df[airlines_df['airline_id'] == airline_id]['iata_code'].values)}{random.randint(100, 9999)}"
        
        flights.append({
            'flight_id': i + 1,
            'airline_id': airline_id,
            'route_id': route_id,
            'flight_number': flight_number,
            'scheduled_departure': scheduled_departure,
            'scheduled_arrival': scheduled_arrival,
            'actual_departure': actual_departure,
            'actual_arrival': actual_arrival,
            'scheduled_journey_time': scheduled_journey_time,
            'actual_journey_time': actual_journey_time,
            'status': status,
            'delay_minutes': delay_minutes,
            'cancellation_reason': cancellation_reason
        })
    
    return pd.DataFrame(flights)

# Function to generate delays
def generate_delays(flights_df, num_delays=5000):
    delays = []
    delay_types = ['Weather', 'Technical', 'Air Traffic Control', 'Airline Operations', 'Security']
    
    delayed_flights = flights_df[flights_df['status'] == 'Delayed']
    
    for i in range(num_delays):
        flight = delayed_flights.sample(n=1).iloc[0]
        
        delays.append({
            'delay_id': i + 1,
            'flight_id': flight['flight_id'],
            'delay_type': random.choice(delay_types),
            'delay_minutes': flight['delay_minutes']
        })
    
    return pd.DataFrame(delays)

# Function to generate weather
def generate_weather(airports_df, num_weather_records=20000):
    weather = []
    start_date = datetime(2023, 1, 1)
    end_date = datetime(2023, 12, 31)
    
    for i in range(num_weather_records):
        airport_id = random.choice(airports_df['airport_id'])
        date_time = start_date + timedelta(seconds=random.randint(0, int((end_date - start_date).total_seconds())))
        
        weather.append({
            'weather_id': i + 1,
            'airport_id': airport_id,
            'date_time': date_time,
            'temperature': round(np.random.uniform(-10, 40), 2),
            'precipitation': round(np.random.uniform(0, 5), 2),
            'wind_speed': round(np.random.uniform(0, 50), 2),
            'visibility': round(np.random.uniform(0, 10), 2),
            'conditions': random.choice(['Clear', 'Cloudy', 'Rainy', 'Snowy', 'Thunderstorm'])
        })
    
    return pd.DataFrame(weather)

# Generate data
airports_df = generate_airports()
airlines_df = generate_airlines()
routes_df = generate_routes(airports_df)
flights_df = generate_flights(airlines_df, routes_df)
delays_df = generate_delays(flights_df)
weather_df = generate_weather(airports_df)

# Save to CSV
airports_df.to_csv('airports.csv', index=False)
airlines_df.to_csv('airlines.csv', index=False)
routes_df.to_csv('routes.csv', index=False)
flights_df.to_csv('flights.csv', index=False)
delays_df.to_csv('delays.csv', index=False)
weather_df.to_csv('weather.csv', index=False)

print("Data generation complete. CSV files created.")
