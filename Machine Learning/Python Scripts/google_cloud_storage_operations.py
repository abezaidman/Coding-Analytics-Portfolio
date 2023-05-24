from google.cloud import storage

def read_files_in_bucket(bucket_name):
    client = storage.Client()
    bucket = client.get_bucket(bucket_name)
    blobs = bucket.list_blobs()

    print(f"List of files in bucket {bucket_name}:")
    for blob in blobs:
        print(f"File: {blob.name}")

def download_file_from_bucket(bucket_name, source_blob_name, destination_file_name):
    client = storage.Client()
    bucket = client.get_bucket(bucket_name)
    blob = bucket.blob(source_blob_name)

    blob.download_to_filename(destination_file_name)
    print(f"File {source_blob_name} downloaded to {destination_file_name}.")

def upload_file_to_bucket(bucket_name, source_file_name, destination_blob_name):
    client = storage.Client()
    bucket = client.get_bucket(bucket_name)
    blob = bucket.blob(destination_blob_name)

    blob.upload_from_filename(source_file_name)
    print(f"File {source_file_name} uploaded to {destination_blob_name}.")

bucket_name = "abezaidman-reddit"

read_files_in_bucket(bucket_name)

source_blob_name = "movie_reviews.json"
destination_file_name = "movie_reviews.csv"
download_file_from_bucket(bucket_name, source_blob_name, destination_file_name)

source_file_name = "movie_reviews.csv"
destination_blob_name = "movie_reviews_uploaded.csv"
upload_file_to_bucket(bucket_name, source_file_name, destination_blob_name)
