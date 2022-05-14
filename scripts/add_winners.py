#provide a list of addresses to be added to the mapping inside the smart contract
#these addresses are pulled from another smart contract and are set to True in the mapping
from brownie import network, TicketMinter
from scripts.helpful_scripts import get_account

winners = ["0x93D76F2889061272CdAb3Ff11FB271BA979fFAd1", "0x8be818B5cB018Fc4E6b76E3A5ce0A8bDF5D76b0d"]

def add_winner():
    account = get_account()
    event_ticket = TicketMinter[-1]
    winner_push = event_ticket.addWinner(winners, {"from": account})
    winner_push.wait(1)
    print("Winners added!")

def main():
    add_winner()