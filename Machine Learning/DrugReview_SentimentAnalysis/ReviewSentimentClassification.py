import pandas as pd
from sklearn.metrics import accuracy_score, f1_score
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import TfidfVectorizer, CountVectorizer
from sklearn.pipeline import Pipeline
from sklearn.linear_model import LogisticRegression
from sklearn.ensemble import RandomForestClassifier
from sklearn.svm import LinearSVC
import pickle

# Load the datasets
train_df = pd.read_csv("train.csv")
test_df = pd.read_csv("test.csv")

# Pre-process the datasets
def preprocess(df):
    df['combined_review'] = df['benefits_review'] + " " + df['side_effects_review'] + " " + df['comments_review']
    df['sentiment'] = df['rating'].apply(lambda x: 'positive' if x >= 5 else 'negative')
    return df[['combined_review', 'sentiment']]

train_df = preprocess(train_df)
test_df = preprocess(test_df)

# Train several machine learning models
X_train, X_test, y_train, y_test = train_test_split(train_df['combined_review'], train_df['sentiment'], test_size=0.3, stratify=train_df['sentiment'])

# Logistic Regression model
logistic_regression_pipeline = Pipeline([
    ('vect', CountVectorizer(stop_words='english')),
    ('cls', LogisticRegression())
])

logistic_regression_pipeline.fit(X_train, y_train)
logistic_regression_train_preds = logistic_regression_pipeline.predict(X_train)
logistic_regression_test_preds = logistic_regression_pipeline.predict(X_test)

# Random Forest model
random_forest_pipeline = Pipeline([
    ('vect', CountVectorizer(stop_words='english')),
    ('cls', RandomForestClassifier())
])

random_forest_pipeline.fit(X_train, y_train)
random_forest_train_preds = random_forest_pipeline.predict(X_train)
random_forest_test_preds = random_forest_pipeline.predict(X_test)

# Linear SVM Model
linear_pipeline = Pipeline([
    ('vect', CountVectorizer(ngram_range=(1, 2), stop_words='english', max_features=10000)),
    ('cls', LinearSVC())
])

linear_pipeline.fit(X_train, y_train)
linear_train_preds = linear_pipeline.predict(X_train)
linear_test_preds = linear_pipeline.predict(X_test)

# Evaluate and compare the models
models = [
    ('Logistic Regression', logistic_regression_train_preds, logistic_regression_test_preds),
    ('Random Forest', random_forest_train_preds, random_forest_test_preds),
    ('Linear SVM', linear_train_preds, linear_test_preds)
]

for name, train_preds, test_preds in models:
    print(f"{name} - Training accuracy:", accuracy_score(y_train, train_preds))
    print(f"{name} - Training F1 score:", f1_score(y_train, train_preds, pos_label='positive'))
    print(f"{name} - Test accuracy:", accuracy_score(y_test, test_preds))
    print(f"{name} - Test F1 score:", f1_score(y_test, test_preds, pos_label='positive'))
    print()

with open('final_pipeline.pkl', 'wb') as f:
    pickle.dump(linear_pipeline, f)

with open('final_pipeline.pkl', 'rb') as f:
    final_pipeline = pickle.load(f)

test_preds = final_pipeline.predict(test_df['combined_review'])
test_accuracy = accuracy_score(test_df['sentiment'], test_preds)
test_f1_score = f1_score(test_df['sentiment'], test_preds, pos_label='positive')

print("Final model - Test dataset accuracy:", test_accuracy)
print("Final model - Test dataset F1 score:", test_f1_score)


