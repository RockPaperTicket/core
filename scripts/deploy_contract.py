from scripts.helpful_scripts import get_account
from brownie import TicketMinter

def main():
    account = get_account()
    TicketMinter.deploy({"from": account})


