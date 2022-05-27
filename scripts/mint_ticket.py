from scripts.helpful_scripts import get_account
from brownie import TicketMinter

eventLogAddress = "0x75537828f2ce51be7289709686A69CbFDbB714F1"
eventID = 1


def create_collectible():
    account = get_account()
    event_ticket = TicketMinter[-1]
    creation_transaction = event_ticket.mintTicket(eventLogAddress, {"from": account})
    creation_transaction.wait(1)
    print(event_ticket.finalTokenUri())
    print("Collectible created!")

def main():
    create_collectible()