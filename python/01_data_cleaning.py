# DATA CLEANING & TRANSFORMATION

import pandas as pd

# Load dataset
data = pd.read_csv('./data/raw_ecommerce_data.csv')

print(data.head(10))

# Dataset inspection
print(data.describe())
print(data.info())
print(data.isnull().sum())

# Fix datatype of date
data['OrderDate'] = pd.to_datetime(data['OrderDate'])

# Created customerID column 
data['CustomerID'] = data['CustomerEmail']
print(data.head(10))

# Create Unit Price column
data['UnitPrice'] = data['TotalPrice($)'] / data['Quantity']

# Rename TotalPrice column to Revenue
data = data.rename(columns={'TotalPrice($)':'Revenue'})
print(data.head(10))

# Remove duplicates
data.drop_duplicates()

# Extract Month & Year column
data['OrderMonth'] = data['OrderDate'].dt.month_name()
data['OrderYear'] = data['OrderDate'].dt.year
data['MonthNum'] = data['OrderDate'].dt.month
print(data.head(10))

# Saved clean data
data.to_csv('./data/cleaned_ecommerce_data.csv')
print("Clean Data Saved Successfully!!")