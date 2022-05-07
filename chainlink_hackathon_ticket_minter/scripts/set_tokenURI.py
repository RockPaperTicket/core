from brownie import network, TicketMinter
from scripts.helpful_scripts import get_account
from metadata.ticket_metadata_template import ticket_metadata_template
from pathlib import Path
import requests
import json
import os
import base64
import pickle

baseSvg1 = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width='100%' height='100%' fill='purple' /><text x='50%' y='30%' class='base' dominant-baseline='middle' text-anchor='middle'>";
baseSvg2 = "<text x='20%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";
baseSvg3 = "<text x='80%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";


def set_tokenURI():
    print(f"Working on {network.show_active()}")
    event_ticket = TicketMinter[-1]

    #Define all variables
    number_of_ticket = event_ticket.newTokenId()
    print(f"You have {number_of_ticket} tickets!")
    name_of_event = event_ticket.eventName()
    print(f"Your event is called {name_of_event}!")
    total_tickets = event_ticket.maxSupply()
    print(f"There are {total_tickets} tickets available!")

    #encode image
    ticket_image = f"{baseSvg1}{name_of_event}</text>{baseSvg2}{number_of_ticket}</text>{baseSvg3}{total_tickets}</text></svg>"
    ticket_image_bytes = ticket_image.encode('ascii')
    base64_image_bytes = base64.b64encode(ticket_image_bytes)
    base64_image = base64_image_bytes.decode('ascii')
    final_image_URI = f"data:image/svg+xml;base64,{base64_image}"

    #create metadata
    ticket_metadata = ticket_metadata_template
    ticket_metadata["name"] = name_of_event
    ticket_metadata["description"] = f"This is your unique ticket for the event {name_of_event}!"
    ticket_metadata["image"] = final_image_URI

    #encode metadata
    base64_metadata = base64.urlsafe_b64encode(json.dumps(ticket_metadata).encode()).decode()

    #set tokenURI
    ticket_token_uri = f"data:application/json;base64,{base64_metadata}"
    return ticket_token_uri

def main():
    set_tokenURI()




    




# def metadata_encode():




#     for token_id in range(number_of_collectibles):
#         breed = get_breed(advanced_collectible.tokenIdToBreed(token_id))
#         if not advanced_collectible.tokenURI(token_id).startswith("https://"):
#             print(f"Setting tokenURI of {token_id}")
#             set_tokenURI(token_id, advanced_collectible, dog_metadata_dic[breed])


# def set_tokenURI(token_id, nft_contract, tokenURI):
#     account = get_account()
#     tx = nft_contract.setTokenURI(token_id, tokenURI, {"from": account})
#     tx.wait(1)
#     print(
#         f"Awesome! You can view your NFT at {OPENSEA_URL.format(nft_contract.address, token_id)}"
#     )
#     print("Please wait up to 20 minutes, and hit the refresh metadata button")




# message = "Python is fun"
# message_bytes = message.encode('ascii')
# base64_bytes = base64.b64encode(message_bytes)
# base64_message = base64_bytes.decode('ascii')

# print(base64_message)