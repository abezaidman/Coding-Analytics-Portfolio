import pickle
import streamlit as st
import pandas as pd
from sklearn.metrics import accuracy_score, f1_score
import matplotlib.pyplot as plt
import seaborn as sns
from wordcloud import WordCloud


st.set_option('deprecation.showPyplotGlobalUse', False)

# SVM model and pipeline 
with open("final_pipeline.pkl", "rb") as f:
    pipeline = pickle.load(f)

# Function to classify  user input
def classify_sentiment(input_text):
    y_pred = pipeline.predict([input_text])[0]
    return y_pred

# Test dataset for performance evaluation
test_df = pd.read_csv('test.csv')

# Preprocess test dataset
test_df["text"] =  test_df['combined_review'] = test_df['benefits_review'] + " " + test_df['side_effects_review'] + " " + test_df['comments_review']
test_df['sentiment'] = test_df['rating'].apply(lambda x: 'positive' if x >= 5 else 'negative')

# Palette dictionary for the histogram plot
palette_dict={"negative": "red", "positive": "green"}

# Model performance on the test dataset
test_preds = pipeline.predict(test_df["text"])
test_acc = accuracy_score(test_df["sentiment"], test_preds)
test_f1 = f1_score(test_df["sentiment"], test_preds, pos_label='positive')

# The Streamlit app
def app():
    # Page title and icon
    st.set_page_config(page_title="Drug Review Sentiment Classifier", page_icon=":pill:")

    # App header
    st.header("Drug Review Sentiment Classifier")

    # Tabs 
    tabs = ["About", "Model Selection", "Model Performance", "Sentiment Histogram", "Sample Reviews", "Model Summary", "Word Cloud", "Model Test"]
    tab = st.sidebar.selectbox("Choose a tab", tabs)

    # Tab content
    if tab == "About":
        st.header("About This App")
        st.write("This is an interactive app that uses a Linear SVM classifier to predict the sentiment of drug reviews as either positive or negative.")
        st.write("The model was trained on a dataset of patient reviews on various prescription drugs.")
        st.write("This app was created as part of the Advanced Machine Learning course at Tulane University.")
        st.write("Developer: Abe Zaidman")
    
    elif tab == "Model Selection":
        st.write("To identify the best model for the task, I experimented with three different algorithms: Logistic Regression, Random Forest, and Linear SVM. Based on my evaluation metrics, including accuracy and F1 score, I ultimately selected the Linear SVM as the final model.")
        st.write("The Logistic Regression model had an Accuracy Score of 0.831 on the test dataset")
        st.write("The Logistic Regression model had F1 score of 0.897 on the test dataset")
        st.write("The Random Forest model had an Accuracy Score of 0.791 on the test dataset")
        st.write("The Random Forest model had F1 score of .881 on the test dataset")
        st.write("The Linear SVM model had an Accuracy Score of 0.815 on the test dataset")
        st.write("The Linear SVM model had F1 score of 0.885 on the test dataset")

    elif tab == "Model Performance":
        st.write(f"Accuracy: {test_acc:.2f}")
        st.write(f"F1 Score: {test_f1:.2f}")

    elif tab == "Sentiment Histogram":
        sns.histplot(data=test_df, x="sentiment", hue="sentiment", multiple="stack", kde=False, alpha=0.5, palette=palette_dict)
        plt.title("Positive and Negative Reviews")
        plt.xlabel("Sentiment")
        plt.ylabel("Count")
        st.pyplot()
    
    elif tab == "Sample Reviews":
        st.header("Sample Reviews")
        st.write(f"Number of reviews: {len(test_df)}")
        st.write(f"Number of positive reviews: {sum(test_df['sentiment'] == 'positive')}")
        st.write(f"Number of negative reviews: {sum(test_df['sentiment'] == 'negative')}")
        st.write("")
        st.write("Here are some sample reviews:")
        st.write(test_df[["text", "sentiment"]].sample(n=5, random_state=42))
        st.write("There are significantly more positive reviews than negative ones.")


    elif tab == "Model Summary":
        st.write("The model used in this app is a Linear SVM classifier trained on a dataset of patient reviews on various prescription drugs.")
        st.write("To improve the model performance, I used the following techniques:")
        st.write("- Text preprocessing: I cleaned and normalized the text data to remove noise and reduce sparsity.")
        st.write("- Feature engineering: I used the CountVectorizer technique to convert the text data into numerical features.")
        st.write("- Hyperparameter tuning: I used a grid search cross-validation approach to find the optimal hyperparameters for the Linear SVM classifier.")
        st.write("- Adding n-grams: I experimented with using both unigrams and bigrams as features, but found that using only unigrams gave better performance.")
        st.write("- Stop words removal: I tried removing stop words from the text data to reduce the noise, but found that keeping them gave better performance.")
        st.write("- Using TF-IDF vectorization: I tried using TF-IDF vectorization instead of CountVectorizer, but found that CountVectorizer gave better performance.")
        st.write("- Ensemble learning: I tried combining multiple machine learning models using a voting classifier, but found that using a single Linear SVM classifier gave the best performance.")
        st.write("- Using Spacy for text preprocessing: I experimented with using Spacy to preprocess the text data, including tokenization, part-of-speech tagging, and named entity recognition, but found that it did not improve the model performance significantly.")

    elif tab == "Word Cloud":
        st.header("Word Cloud of Most Frequent Words in Reviews")

        # New DataFrame with the individual words in each review
        words_df = pd.DataFrame(test_df["text"].str.split(expand=True).stack(), columns=["word"])

        # Frequency of each word 
        word_counts = words_df["word"].value_counts().sort_values(ascending=False)

        # Create the word cloud
        wordcloud = WordCloud(background_color="white", colormap="Dark2_r", max_font_size=150, random_state=42).generate_from_frequencies(word_counts)

        # Display the word cloud
        plt.figure(figsize=(10, 10))
        plt.imshow(wordcloud, interpolation="bilinear")
        plt.axis("off")
        st.pyplot()

    elif tab == "Model Test":
        st.header("Model Test")
        user_input = st.text_input("Enter a drug review:", "")
        if user_input:
            y_pred = classify_sentiment(user_input)
            if y_pred == 'positive':
                 st.write("The review is positive 😊")
            else:
                st.write("The review is negative 😔")

if __name__ == '__main__':
    app()


