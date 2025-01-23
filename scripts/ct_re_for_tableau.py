import sqlite3
import pandas as pd

# Connecting to SQLite DataBase
conn = sqlite3.connect('ct_real_estate_1.db')

# Reading all the cleaned data
df = pd.read_sql_query('SELECT * FROM ct_real_estate_1', conn)

# Saving to .csv for Tableau Public
df.to_csv('ct_re_data_1.csv', index=False)

conn.close()

