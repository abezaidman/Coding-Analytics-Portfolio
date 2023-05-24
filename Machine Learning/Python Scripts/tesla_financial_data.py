import requests
import json

API_KEY = "9VXRLEGXW1J8QLI3"
url = 'https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&symbol=TSLA&apikey=YOUR_API_KEY'
data = requests.get(url)
print(json.dumps(data.json(), indent=4))

# closing price
df = json.loads(data.text)
jar = df['Meta Data']['3. Last Refreshed']
closing_price = df['Time Series (Daily)'][jar]['4. close']
print("The last closing price: " + str(closing_price))

# company overview
url2 = 'https://www.alphavantage.co/query?function=OVERVIEW&symbol=TSLA&apikey=YOUR_API_KEY'
data2 = requests.get(url2)
df2 = json.loads(data2.text)

pbr = df2['PriceToBookRatio']
atp = df2['AnalystTargetPrice']
print("Price to Book Ratio: " + str(pbr))
print("Analyst Target Price: " + str(atp))

# earnings calendar
url3 = 'https://www.alphavantage.co/query?function=EARNINGS_CALENDAR&symbol=TSLA&apikey=YOUR_API_KEY'
data3 = requests.get(url3)
df3 = json.loads(data3.text)

nrp = df3['NextReportDate']
eps = df3['EPSEstimate']
print("Next Report Date: " + str(nrp))
print("EPS Estimate " + str(eps))