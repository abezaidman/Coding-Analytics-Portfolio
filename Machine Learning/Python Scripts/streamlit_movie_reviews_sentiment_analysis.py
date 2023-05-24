import streamlit as st
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import CountVectorizer, TfidfTransformer
from sklearn.naive_bayes import MultinomialNB
from sklearn.metrics import classification_report, confusion_matrix, accuracy_score


st.title("Movie Reviews Sentiment Analysis")


df = pd.read_csv('IMDB_movie_reviews_labeled.csv')

st.header("Dataset Summary")
st.write(df.head())
st.write(df.describe())

st.header("Sentiment Distribution")
fig, ax = plt.subplots()
sns.countplot(x='sentiment', data=df, ax=ax)
st.pyplot(fig)

st.header("Model Training and Validation")

X = df['review']
y = df['sentiment']
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

vectorizer = CountVectorizer(stop_words='english')
X_train_counts = vectorizer.fit_transform(X_train)
tfidf_transformer = TfidfTransformer()
X_train_tfidf = tfidf_transformer.fit_transform(X_train_counts)

clf = MultinomialNB().fit(X_train_tfidf, y_train)

X_test_counts = vectorizer.transform(X_test)
X_test_tfidf = tfidf_transformer.transform(X_test_counts)
y_pred = clf.predict(X_test_tfidf)

st.write("Classification Report:")
st.write(classification_report(y_test, y_pred))
st.write("Confusion Matrix:")
st.write(confusion_matrix(y_test, y_pred))
st.write("Accuracy Score:", accuracy_score(y_test, y_pred))

st.header("Predict Sentiment")

user_input = st.text_area("Enter a movie review:")
if st.button("Predict"):
    input_counts = vectorizer.transform([user_input])
    input_tfidf = tfidf_transformer.transform(input_counts)
    prediction = clf.predict(input_tfidf)
    st.write("Predicted Sentiment:", prediction[0])
