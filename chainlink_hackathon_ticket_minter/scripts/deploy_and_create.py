from scripts.helpful_scripts import get_account
from brownie import CertificatesCollection

sample_token_uri = "https://gateway.pinata.cloud/ipfs/QmYHstn3Mx5qmcUAsPS5sCK1Mbcc2hFcGqZumWuRei6PW6"

def main():
    account = get_account()
    certificate_collectible = CertificatesCollection.deploy({"from": account})
    creation_transaction = certificate_collectible.mintTicket(sample_token_uri, {"from": account})
    creation_transaction.wait(1)