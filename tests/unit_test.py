#Not completed yet!
from scripts.helpful_scripts import get_account
from brownie import network
import pytest
from scripts import deploy_contract, get_event_data, set_tokenURI


def test_can_create_simple_collectible():
    simple_collectible = deploy_contract()
    
