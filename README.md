# SQL Data Analysis for Genealogy

This project uses the SQL database language to load, clean, organize, analyze and visualize family history data. The SQL tasks included data wrangling (cleaning, and structuring), and data analysis and the data visualization will be done using Tableau. The presentation will use Miscrosoft PowerPoint and Tableau. The data is from a ficticious genealogist who desires to have additional data storage and data analysis for his clients.

The project folders follow the following format:

#### Data Wrangling

- Data cleaning, which includes the files for the raw data and SQL files for cleaning. Using SQL I created a database, imported the data into a single table, cleaned the data, and split the location and date columns into multiple columns.
- The Data Structure folder includes a csv file with cleaned data, an ER diagram and the SQL files to create the storage tables and insert the cleaned data. This is where the data is organized into separate tables with required relationships and check constraints.

#### Data Analysis

- Analyze the data by finding summary statistics
- Gain the answers to important or interesting questions.

For example, which country is home for the greatest number of your ancestors? Or, which ancestors had the longest life span? These select queries are much more complicated than the select queries seen in the data wrangling section. Getting simple answers from data that is organized into separate tables can require complex joins and subqueries. For example, one of the more difficult queries I wrote so far in this project is the query that returns a list of the names of a each ancestor along with the names of their parents and grandparents. The query that found ancestors who had emigrated was also difficult, because emigration might not be proved just because a person's birth and death country were different. To provide further likelihood of emigration, I also checked to see if their children were born or married in the parent's death_country.

#### Data Visualization

#### Presenting Results
