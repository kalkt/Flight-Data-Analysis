import pandas as pd

# Load the flights and delays datasets
flights_file = "flights.csv"
delays_file = "delays.csv"

# Read the CSV files
flights = pd.read_csv(flights_file)
delays = pd.read_csv(delays_file)

# Standardize datetime columns in the flights DataFrame
datetime_columns = ["scheduled_departure", "scheduled_arrival", "actual_departure", "actual_arrival"]
for col in datetime_columns:
    flights[col] = pd.to_datetime(flights[col], errors="coerce").dt.strftime("%Y-%m-%d %H:%M:%S")

# Merge the flights and delays datasets
delays_grouped = delays.groupby("flight_id")["delay_type"].apply(", ".join).reset_index()
delays_grouped.rename(columns={"delay_type": "delay_reasons"}, inplace=True)

merged_flights = pd.merge(flights, delays_grouped, on="flight_id", how="left")

# Separate datetime columns into date and time columns
for col in datetime_columns:
    date_col = col + "_date"
    time_col = col + "_time"
    merged_flights[date_col] = pd.to_datetime(merged_flights[col], errors="coerce").dt.date
    merged_flights[time_col] = pd.to_datetime(merged_flights[col], errors="coerce").dt.time

# Reorder columns for better readability
final_columns_order = [
    "flight_id", "airline_id", "route_id", "flight_number",
    "scheduled_departure", "scheduled_departure_date", "scheduled_departure_time",
    "scheduled_arrival", "scheduled_arrival_date", "scheduled_arrival_time",
    "actual_departure", "actual_departure_date", "actual_departure_time",
    "actual_arrival", "actual_arrival_date", "actual_arrival_time",
    "scheduled_journey_time", "actual_journey_time",
    "flight_status", "delay_minutes", "delay_reasons", "cancellation_reason"
]
merged_flights = merged_flights[final_columns_order]

# Save the merged and updated DataFrame to a new CSV file
output_file = "merged_flights.csv"
merged_flights.to_csv(output_file, index=False)

print(f"Merged file with separated date and time columns saved as {output_file}.")