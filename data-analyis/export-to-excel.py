"""
Project: Ancestors SQL Database Management
Author: Mark Bahr
"""

# -------------------------------------------------------- #
#                   CREATE CONNECTION

# Import neede packages
import psycopg2
import pandas as pd

# Create connection to family_hstory database
# sytax follows: engine = create_engine("postgres+psycopg2://dbname:password@localhost:port/database
conn = psycopg2.connect("dbname=family_history user=postgres password=12345")

# Crate the cursor object
cur = conn.cursor

# ---------------------------------------------------- #
#                   WRITE THE QUERY

# Query, to be updated after analysis, multiples
fam_hist_query = pd.read_sql_query('''
    SELECT * FROM ancestors;
                                   ''')

# Store the results in a Pandas DataFrame
df_fam_hist = pd.DataFrame(fam_hist_query)

# Export the dataframe to a csv file
df_fam_hist.to_csv(r"C\Users\Public\data\fam_hist.csv", index = False)

# Commit changes to database
conn.commit()

# Close the communication with the database
cur.close()
conn.close()



