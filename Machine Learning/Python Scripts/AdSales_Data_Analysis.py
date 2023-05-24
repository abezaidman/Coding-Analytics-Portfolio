## part 1
# import required libraries to your workspace

import pandas as pd

import matplotlib.pyplot as plt 

# read the csv file using pandas and copy the resulting dataframe to variable df

df = pd.read_csv('AdSales.csv')

# examine the dataframe df

print(df.head())

print(df.info())
print(df.shape)
print(df.columns)

# draw a simple line plot of dataframe using the plot() function

df.plot()

plt.show()

# Do you see any problems with this plot?

# Change the python code to read the csv file in the beginning to

df = pd.read_csv('AdSales.csv', index_col='Quarter')

# Re-execute all blocks and check if your line plot is fixed now. 

# To save your plot as an image file adsales_lineplot.png, add another line of code.

plt.savefig('adsales_lineplot.png')

# Check your workspace folder for saved image.

 

## part 2
# Create a function sales_plot() and move the code you wrote so far into the function except the
# code that imports pandas and matplotlib.
def sales_plot():
    df = pd.read_csv('AdSales.csv')
    print(df.head())
print(df.info())
print(df.shape)
print(df.columns)
df.plot()
plt.show()
df = pd.read_csv('AdSales.csv', index_col='Quarter')
plt.savefig('adsales_lineplot.png')


