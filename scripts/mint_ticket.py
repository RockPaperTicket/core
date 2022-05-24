from scripts.helpful_scripts import get_account
from scripts.set_tokenURI import set_tokenURI
from brownie import TicketMinter

eventLogAddress = "0x5F94f304d8779fE32FbD901f8B0D0e7391871330"
eventID = 1


def create_collectible():
    account = get_account()
    event_ticket = TicketMinter[-1]
    ticket_token_uri = set_tokenURI()
    creation_transaction = event_ticket.mintTicket(ticket_token_uri, eventLogAddress, eventID, {"from": account})
    creation_transaction.wait(1)
    print("Collectible created!")

def main():
    create_collectible()