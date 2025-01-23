import pandas as pd
import sqlite3

# Reading raw data
data = pd.read_csv("Real_Estate_Sales_2001-2020_GL.csv")

# Formatting date for consistency
data['Date Recorded'] = pd.to_datetime(data['Date Recorded'], errors='coerce').dt.strftime('%Y-%m-%d')

data = data.where(pd.notnull(data), None)

# Connecting to SQLite
conn = sqlite3.connect('ct_real_estate_1.db')
data.to_sql("ct_real_estate_1", conn, if_exists="replace", index=False)
conn.close()
