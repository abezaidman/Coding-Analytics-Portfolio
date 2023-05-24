import streamlit as st
import pandas as pd
import nltk
from nltk.sentiment import SentimentIntensityAnalyzer
import re
from nltk.corpus import stopwords
from nltk.stem import WordNetLemmatizer
import pandas as pd
import numpy as np
import pickle
from sklearn.feature_extraction.text import CountVectorizer, TfidfVectorizer
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score, f1_score, confusion_matrix
from sklearn.pipeline import Pipeline
from PIL import Image
from google.cloud import firestore
import requests
import json
import os
import matplotlib.pyplot as plt
from matplotlib import dates as mpl_dates
from datetime import datetime
import seaborn as sns
import datetime as dt
from datetime import datetime, timedelta
import schedule
import time
import threading
from wordcloud import WordCloud
import altair as alt

# Define the contents of the "Home" tab
def home():
    st.title("r/NBA Sentiment Analysis Project")
    st.subheader("Created by: Gabriel Kusiatin, Jack Whalen, Abe Zaidman, Kayvan Khoobehi, Daniel Cohen")
    "---"
    st.subheader("Project Design and Objective")
    st.write("The goal of this project is to create a model that accuratley predicts the sentiment of posts pulled from the r/NBA reddit page. We're hoping that those who visit our web application can accurately understand the sentiment surrounding any topic being discussed in the r/NBA page.")
    st.write("This project was created as a part of the Applied Machine Learning course in the Master's of Business Analytics program at the A.B. Freeman School of Business at Tulane University. This project is the culmination of everything we learned over the course of our Spring semester in Applied Machine Learning and we hope that those who visit our site enjoy all the work we've done!")
    "---"
    st.subheader("Connect With Us!")
    images = {
    "Gabriel Kusiatin": {
        "path": "1647971708087.jpg",
        "link": "https://www.linkedin.com/in/gabriel-kusiatin/"
    },
    "Jack Whalen": {
        "path": "Johnelite.jpg",
        "link": "https://www.linkedin.com/in/jackjwhalen/"
    },
    "Abe Zaidman": {
        "path": "Tore.jpg",
        "link": "https://www.linkedin.com/in/abezaidman/"
    },
    "Kayvan Khoobehi": {
        "path": "Kayvan.jpg",
        "link": "https://www.linkedin.com/in/kayvankhoobehi/"
    },
    "Daniel Cohen": {
        "path": "Landlord.jpg",
        "link": "https://www.linkedin.com/in/daniel-cohen17/"
    }
}

# Display the pictures side by side with names and hyperlinks
    col1, col2, col3, col4, col5 = st.columns(5)

    with col1:
        image = Image.open(images["Gabriel Kusiatin"]["path"])
        st.image(image)
        st.markdown(f"[{list(images.keys())[0]}]({images['Gabriel Kusiatin']['link']})")
    
    with col2:
        image = Image.open(images["Jack Whalen"]["path"])
        st.image(image)
        st.markdown(f"[{list(images.keys())[1]}]({images['Jack Whalen']['link']})")

    with col3:
        image = Image.open(images["Abe Zaidman"]["path"])
        st.image(image)
        st.markdown(f"[{list(images.keys())[2]}]({images['Abe Zaidman']['link']})")
    
    with col4:
        image = Image.open(images["Kayvan Khoobehi"]["path"])
        st.image(image)
        st.markdown(f"[{list(images.keys())[3]}]({images['Kayvan Khoobehi']['link']})")
    
    with col5:
        image = Image.open(images["Daniel Cohen"]["path"])
        st.image(image)
        st.markdown(f"[{list(images.keys())[4]}]({images['Daniel Cohen']['link']})")

# Define the contents of the "Model Training" tab
def model_training():
    @st.cache_data
    def train_model(test_size):
        # Load the model
        with open('reddit_sentiment_model.pkl', 'rb') as f:
            pipeline = pickle.load(f)

        # Load preprocessed data
        df = pd.read_csv('combined_sentiment.csv')
        df['text'] = df['text'].replace(np.nan, '', regex=True)

        # Split the data into training and test sets
        X_train, X_test, y_train, y_test = train_test_split(df['text'], df['sentiment'], test_size=test_size, random_state=42)

        # Fit the model
        pipeline.fit(X_train, y_train)

        # Predict on training set and calculate training accuracy
        y_train_pred = pipeline.predict(X_train)
        train_acc = accuracy_score(y_train, y_train_pred)

        # Predict on test set and evaluate the model performance
        y_pred = pipeline.predict(X_test)
        test_acc = accuracy_score(y_test, y_pred)
        test_f1 = f1_score(y_test, y_pred, pos_label='positive')

        cm = confusion_matrix(y_test, y_pred)
        fn_rate = cm[1][0] / (cm[1][0] + cm[1][1])
        fp_rate = cm[0][1] / (cm[0][1] + cm[0][0])

        return test_acc, test_f1, fn_rate, fp_rate, train_acc

    st.title("Model Training")
    "---"
   
    # Load the dataframe and display a sample
    combined_sentiment = pd.read_csv("combined_sentiment.csv")
    st.subheader("Sample of combined_sentiment.csv")
    st.write(combined_sentiment.sample(10))
    "---"
    # Add a brief explanation of the model and how it was built
    st.subheader("Model Explanation and Building Process")
    st.write("""
             The model used for sentiment analysis is a Logistic Regression model.
             The text data was preprocessed by removing URLs, tokenizing, converting to lowercase,
             removing stopwords, and lemmatizing the words. After preprocessing, the text was
             transformed into a numerical format using the CountVectorizer from the sklearn library.
             The model was trained using the processed text data and corresponding sentiment labels.
             """)
   
    st.subheader("Select Test Size")
    "---"
    st.write("""
             An important aspect to creating a machine learning model is the test_train_split function that
             seperates your data into training and testing data. For the model we built, we split the data
             into 70% training, 30% testing. It's important to split the data into training and testing to
             mitigate over-fitting the model to the training data, making it less flexible in predicting
             new data. The model is trained on the training data, where it works to identify patterens to 
             make accurate predicitions. Once the model is fitted to the data, we assess it based on its 
             training accuracy, test accuracy, f1_score, false positive and false negative rate. If you'd
             like to see how adjusting the splitting percentage impacts these metrics, you can use the slider
             below to adjust this setting.
             """)
    "---"
    test_size = st.slider("Choose the test size for train-test split:", min_value=0.1, max_value=0.99, value=0.2, step=0.05)
   
    # Train the model with the selected test size
    test_acc, test_f1, fn_rate, fp_rate, train_acc = train_model(test_size)

    # Display the model performance metrics
    st.subheader("Model Performance Metrics")
    st.write(f"Training dataset accuracy: {train_acc:.4f}")
    st.write(f"Test Dataset Accuracy: {test_acc:.4f}")
    st.write(f"Test F1 Score: {test_f1:.4f}")
    st.write(f"False Negative Rate: {fn_rate:.4f}")
    st.write(f"False Positive Rate: {fp_rate:.4f}")

# Define the contents of the "Google Cloud Data Automation" tab
def google_cloud():
    st.title("Google Cloud Data Automation")
    "---"
    st.subheader("About:")
    st.write("In order to keep our model and data up-to-date, we utilized Google Cloud Platform to create a machine learning/data collection workflow that updates everyday at 8 am. This means that every morning at 8, our Google Cloud Functions collect posts from r/NBA, processes them into a structure our model can interpret, and then predict the sentiment based on the text of each individual post.")
    "---"
    # Set Google Cloud credentials
    os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = "aml-final-project-384918-9e022dc26d0d.json"
    # Create a Firestore client
    db = firestore.Client(project = 'aml-final-project-384918')
    # Get a reference to a collection
    collection_ref = db.collection(u'reddit_NBA')
    posts = list(collection_ref.stream())
    docs_dict = []
    for post in posts:
        doc_dict = post.to_dict()
        doc_dict['created_utc'] = post.create_time.timestamp()
        docs_dict.append(doc_dict)
    df = pd.DataFrame(docs_dict)
    df1 = df.copy()
    df1 = df1[["title", "selftext", 'created_utc']]
    df1['created_utc'] = pd.to_datetime(df1['created_utc'], unit='s').dt.date
    df1.selftext = df1.selftext.fillna(" ")
    df1['text'] = df1.selftext + " " + df1.title
    df1 = df1.drop(["title", "selftext"], axis=1)
    def preprocess_text(text):
        if not isinstance(text, (str, bytes)):
            return ''
    # Remove URLs
        text = re.sub(r'http\S+', '', text)
    # Tokenize the text
        tokens = nltk.word_tokenize(text)
    # Convert to lowercase
        tokens = [token.lower() for token in tokens]
    # Remove stopwords
        stop_words = set(stopwords.words('english'))
        tokens = [token for token in tokens if token not in stop_words]
    # Remove non-alphabetic characters
        tokens = [token for token in tokens if token.isalpha() and len(token) > 2]
    # Lemmatize tokens
        lemmatizer = WordNetLemmatizer()
        tokens = [lemmatizer.lemmatize(token) for token in tokens]
    # Join tokens into string and return
        return ' '.join(tokens)
    df1['text'] = df1['text'].apply(preprocess_text)
    @st.cache_data()
    def analyze_sentiment(text):
        sia = SentimentIntensityAnalyzer()
        sentiment = sia.polarity_scores(text)['compound']
        return sentiment
    df1['sentiment_score'] = df1['text'].apply(analyze_sentiment)
# Add a new column to hold the sentiment labels
    df1['sentiment'] = df1['sentiment_score'].apply(lambda x: 'positive' if x >= 0 else 'negative')
    df1 = df1.drop('sentiment_score', axis= 1)
    df1 = df1.sort_values('created_utc', ascending= False)
    st.subheader("Reddit posts from r/NBA, pulled everyday at 8 am")
    st.dataframe(df1)
    "---"
    st.subheader("Number of posts per day")
    # Group the data by date and count the number of posts for each date
    date_counts = df1.groupby('created_utc').size().reset_index(name='count')
    fig, ax = plt.subplots()
    ax.bar(date_counts['created_utc'], date_counts['count'])
    ax.set_xlabel('Date')
    ax.set_ylabel('Number of Posts')
    ax.set_title('Posts Pulled by Date')
    plt.xticks(rotation=45, ha='right')
    st.pyplot(fig)
    st.write("The bar chart above shows the number of posts pulled from r/NBA each day since our cloud functions were established (04/26/2023). The number of posts stored in our Google Cloud Firestore is dependent on the number of posts posted and can not exceed more than 100 as limited by Reddit's API.")
    "---"
    st.subheader("Model Performance on Live Data")
    with open('reddit_sentiment_model.pkl', 'rb') as f:
        trained_model = pickle.load(f)
    df2 = df1.copy()
    df2 = df1.drop('created_utc', axis = 1)
    y_pred = trained_model.predict(df2['text'])
    test_accuracy = accuracy_score(df2['sentiment'], y_pred)
    test_f1_score = f1_score(df2['sentiment'], y_pred, pos_label='positive')
    st.write("Here is the current accuracy and f1 score of our model on the up-to-date data from r/NBA:")
    st.write(f"Accuracy: {test_accuracy}")
    st.write(f"F1_Score: {test_f1_score}")
     # Define a function to run the code
    @st.cache_data()
    def update_dataframe():
        # Load the existing dataframe or create a new one if it doesn't exist
        try:
            performance_by_date = pd.read_csv('performance_by_date.csv')
        except FileNotFoundError:
            performance_by_date = pd.DataFrame(columns=['created_utc', 'accuracy', 'f1_score'])

        # get the current date
        today = pd.Timestamp.now().normalize()

        # append the current date and performance to the dataframe
        performance_by_date = performance_by_date.append({
            'created_utc': today,
            'accuracy': test_accuracy,
            'f1_score': test_f1_score
        }, ignore_index=True)

        # save the updated dataframe to a csv file
        performance_by_date.to_csv('performance_by_date.csv', index=False)
        return performance_by_date
    
    update_dataframe()

    # Define a function to schedule the update_dataframe function to run at 8:10am every day
    def schedule_update():
        schedule.every().day.at("08:10").do(update_dataframe)

        while True:
            schedule.run_pending()
            time.sleep(1)
    
    threading.Thread(target=schedule_update).start()

    df_model = update_dataframe()
    st.write("The data frame and chart below show a day-to-day log of the accuracy and f1 score over time. These scores are calculated after the most recent data has be pulled into the application and are evaluated on the totality of the data set.")
    st.dataframe(df_model)
    # Convert the 'created_utc' column to datetime format
    df_model['created_utc'] = pd.to_datetime(df_model['created_utc'])

    # Set the 'created_utc' column as the index of the dataframe
    df_model.set_index('created_utc', inplace=True)

    st.line_chart(df_model[["accuracy", "f1_score"]])
    
    "---"
    st.subheader('Wordcloud Analysis')
    # Split the data by sentiment
    positive_text = ' '.join(df1[df1['sentiment'] == 'positive']['text'])
    negative_text = ' '.join(df1[df1['sentiment'] == 'negative']['text'])

    # Generate the word clouds
    positive_wordcloud = WordCloud(width=400, height=400, background_color='white').generate(positive_text)
    negative_wordcloud = WordCloud(width=400, height=400, background_color='white').generate(negative_text)

    # Create a figure with two subplots side by side
    fig, axs = plt.subplots(1, 2, figsize=(10, 5))

    # Display the word clouds in the subplots
    axs[0].imshow(positive_wordcloud, interpolation='bilinear')
    axs[0].axis('off')
    axs[0].set_title('Positive Words')
    axs[1].imshow(negative_wordcloud, interpolation='bilinear')
    axs[1].axis('off')
    axs[1].set_title('Negative Words')

    # Display the figure in the Streamlit app
    st.pyplot(fig)
    st.write('Above is a visualization of the most frequent words, split between negative and positive posts, in the r/NBA sub-reddit. The larger the word, the more frequently it appeared in either a negative or positive post.')
    "---"
    st.subheader("See what sentiment is surrounding your favorite team or player in r/NBA!")
    st.write("Input a player or team below and see! Our model is case sensitive and only will display results if the input is in all lowercase. Likewise, you may see better results if you type in embiid as opposed to joel embiid, for example. As of 05/04/23, our model just began running a few days ago, so if your team or player is not appearing, it's most likely because they have not been included in the data we've collected thus far. As more data is collected, the more likely that player or team will be included in a post.")
    # Add a text input box for the user to search
    search_term = st.text_input("Enter a search term:")

    if not search_term:
    # If the input text box is empty, show 0 for the number of positive and negative posts
        positive_posts = 0
        negative_posts = 0
    else:
    # Filter the dataframe based on the search term
        filtered_df = df1[df1["text"].str.contains(search_term)]

    # Calculate the number of positive and negative posts in the filtered dataframe
        positive_posts = filtered_df[filtered_df["sentiment"] == "positive"].shape[0]
        negative_posts = filtered_df[filtered_df["sentiment"] == "negative"].shape[0]
    
    # Display the number of positive and negative posts
    st.write(f"Number of positive posts containing '{search_term}': {positive_posts}")
    st.write(f"Number of negative posts containing '{search_term}': {negative_posts}")
    chart_data = pd.DataFrame({"Sentiment": ["Positive", "Negative"], "Count": [positive_posts, negative_posts]})
    chart = alt.Chart(chart_data).mark_bar().encode(x="Sentiment", y="Count")
    chart_container = st.empty()
    chart_container.altair_chart(chart, use_container_width=True)
    if st.button("Clear"):
        chart_container.empty()
        st.write("")
        search_term = ""

    # Create the tabs
tabs = ["Home", "Model Training", "Google Cloud Data Automation and Model Performance"]
page = st.sidebar.selectbox("Select a page", tabs)

# Display the selected page with its corresponding content
if page == "Home":
    home()
elif page == "Model Training":
    model_training()
elif page == "Google Cloud Data Automation and Model Performance":
    google_cloud()

