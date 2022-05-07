from scripts.helpful_scripts import get_account
from scripts.set_tokenURI import set_tokenURI
from brownie import TicketMinter

def create_collectible():
    account = get_account()
    event_ticket = TicketMinter[-1]
    ticket_token_uri = set_tokenURI()
    creation_transaction = event_ticket.mintTicket(ticket_token_uri, {"from": account})
    creation_transaction.wait(1)
    print("Collectible created!")

def main():
    create_collectible()