from scripts.helpful_scripts import get_account
from scripts.set_tokenURI import set_tokenURI
from brownie import TicketMinter

eventLogAddress = "0xDD65Cf1280C52A825B4997bC10E3ad688F6Feab3"
eventID = 1


def create_collectible():
    account = get_account()
    event_ticket = TicketMinter[-1]
    creation_transaction = event_ticket.mintTicket(eventLogAddress, eventID, {"from": account})
    creation_transaction.wait(1)
    print(event_ticket.finalTokenUri())
    print("Collectible created!")

def main():
    create_collectible()