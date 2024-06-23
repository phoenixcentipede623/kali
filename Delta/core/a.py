import requests

# Function to fetch moves for a given Pokémon
def fetch_moves(pokemon_name, version_group_id):
    url = f'https://pokeapi.co/api/v2/pokemon/{pokemon_name}'
    response = requests.get(url)
    data = response.json()
    
    moves = set()
    for move in data['moves']:
        for version_detail in move['version_group_details']:
            if version_detail['version_group']['url'].split('/')[-2] == str(version_group_id):
                moves.add(move['move']['name'])
    return moves

# Sun-Moon version group ID is 17
version_group_id = 17

# Fetch moves for Vulpix and Machop
vulpix_moves = fetch_moves('vulpix', version_group_id)
machop_moves = fetch_moves('machop', version_group_id)

# Find unique moves for Vulpix
unique_vulpix_moves = vulpix_moves - machop_moves

# Output the count of unique moves
print(len(unique_vulpix_moves))
