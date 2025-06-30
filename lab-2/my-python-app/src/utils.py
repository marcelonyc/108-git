import requests

def fetch_data(url):
    response = requests.get(url)
    if response.status_code == 200:
        return response.json()
    else:
        raise Exception("Failed to fetch data from the URL")

def process_data(data):
    # Example processing function
    return [item['name'] for item in data if 'name' in item]

def save_data_to_file(data, filename):
    with open(filename, 'w') as file:
        for item in data:
            file.write(f"{item}\n")