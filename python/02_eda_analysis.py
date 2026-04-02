# EXPLORATORY DATA ANALYSIS

import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Load cleaned data
df = pd.read_csv('./data/cleaned_ecommerce_data.csv')
print("Data Loaded Successfully!!")

print(df.info())

# Revenue by City - top 10
agg1 = df.groupby('City')['Revenue'].sum().sort_values(ascending=False)
print(agg1.head(10))

# top 10 products by revenue
agg2 = df.groupby('Product')['Revenue'].sum().sort_values(ascending=False)
print(agg2.head(5))

# payment method analysis
agg3 = df.groupby('PaymentMethod')['Revenue'].sum().sort_values(ascending=False)
print(agg3.head())

# revenue by month
df = df.sort_values(by=['MonthNum', 'OrderYear'])
plt.figure(figsize=(10,6))
sns.lineplot(x='OrderMonth', y='Revenue', data=df)
plt.title('Revenue by Month')
plt.xlabel('Month')
plt.ylabel('Revenue')
plt.xticks(rotation=45)
plt.show()

# Discount Impact Analysis
agg5 = df.groupby('Discount(%)').agg({
	'Revenue': 'sum',
	'Quantity':'sum',
	'OrderID': 'count'
}).reset_index()
print(agg5)

# Customer Value Analysis
agg6 = df.groupby('CustomerName').agg({
	'Revenue': 'sum',
	'Quantity':'sum',
	'OrderID': 'count'
}).reset_index().sort_values(ascending=False, by=['Revenue','OrderID'])
print(agg6.head(10))