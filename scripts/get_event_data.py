#provide a list of addresses to be added to the mapping inside the smart contract
#these addresses are pulled from another smart contract and are set to True in the mapping
from brownie import network, TicketMinter
from scripts.helpful_scripts import get_account

eventLogAddress = "0x5F94f304d8779fE32FbD901f8B0D0e7391871330"
eventID = 1

def getEventData():
    account = get_account()
    event_ticket = TicketMinter[-1]
    eventData = event_ticket.getEventData(eventLogAddress, eventID, {"from": account})
    eventData.wait(1)
    number_of_ticket = event_ticket.newTokenId()
    print(f"You have {number_of_ticket} tickets!")
    name_of_event = event_ticket.eventName()
    print(f"Your event is called {name_of_event}!")
    total_tickets = event_ticket.numberOfTickets()
    print(f"There are {total_tickets} tickets available!")
    print("Data retrieved!")

def main():
    getEventData()