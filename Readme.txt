# Flight Data Analysis Project

## **Description**
Comprehensive flight data analysis leveraging SQL and Python to evaluate airline performance, delays, cancellations, passenger trends, and weather impacts. Includes realistic datasets, SQL queries, and insights to improve operational efficiency and support data-driven decision-making for the aviation industry.

## **Project Overview**
This project provides actionable insights into flight performance and operational efficiency in the aviation industry. By analyzing realistic datasets, it addresses critical aspects such as delays, cancellations, airline and route performance, passenger traffic, and weather impacts.

## **Project Objectives**
1. **Flight Performance Analysis:** Evaluate delays, cancellations, and patterns.
2. **Airline and Route Efficiency:** Assess and compare operational performance of airlines and routes.
3. **Passenger and Traffic Insights:** Identify trends at airports and routes.
4. **Weather Impact on Flights:** Examine weather-related delays and cancellations.
5. **Cancellations Analysis:** Investigate reasons and trends for flight cancellations.
6. **Seasonal Trends:** Analyze time-based and seasonal variations in flight operations.

## **Project Structure**

### **Data Files (CSV)**
- `airlines.csv`: Airline details including IATA codes.
- `airports.csv`: Airport details including passenger statistics.
- `delays.csv`: Information on flight delays.
- `merge_flights.csv`: Combined flight and delay data for analysis.
- `routes.csv`: Routes data including origin, destination, and distance.
- `weather.csv`: Weather conditions affecting flights.

### **SQL Files**
- `flight_analysis_setup.sql`: Creates and loads database tables from the CSV files.
- `flight_analysis_queries.sql`: Executes queries to meet project objectives and derive insights.

### **Python Scripts**
- `CreatingDB.py`: Automates database creation and table population.
- `newMergeFlightDelays.py`: Merges `flights.csv` and `delays.csv` into `merge_flights.csv`, ensuring data consistency.

### **Documentation**
- `Airline_Industry_Performance_Report.docx`: Detailed report and findings for the whole project
- `Project_Objectives_and_Questions.docx`: Detailed objectives and questions for the analysis.
- ER Diagram: A visual representation of the database schema.

## **References**
- **Data Sources**: 
  - United States Department of Transportation
  - Bureau of Transportation Statistics (https://www.bts.gov/content/passengers-boarded-top-50-us-airports)
- **Tools Used**: Python, MySQL Workbench, Excel

## **Setup Instructions**
1. Clone the repository:
   ```bash
   git clone <repository_url>
   ```
2. Navigate to the project directory:
   ```bash
   cd Flight_Data_Analysis
   ```
3. Install required Python libraries:
   ```bash
   pip install pandas
   ```
4. Run `CreatingDB.py` to set up the database:
   ```bash
   python scripts/CreatingDB.py
   ```
5. Run `newMergeFlightDelays.py` if re-merging flight and delay data is needed:
   ```bash
   python scripts/newMergeFlightDelays.py
   ```
6. Execute `flight_analysis_setup.sql` in MySQL Workbench to create and populate tables.
7. Execute `flight_analysis_queries.sql` in MySQL Workbench to analyze data.

## **References**
- United States Department of Transportation.
- Bureau of Transportation Statistics
(https://www.bts.gov/content/passengers-boarded-top-50-us-airports)).
- Tools: Python, MySQL Workbench, Excel.

## **Contributing**
Contributions are welcome! Fork this repository, make your changes, and submit a pull request.

## **License**
This project is licensed under the MIT License. See the `License` file for details.

## **Contact**
For inquiries or feedback, contact:
- **Kartik K Nariya**
- **Email:** nariyak007@gmail.com
- **GitHub Profile:** https://github.com/kalkt