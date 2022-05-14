This smart contract is able to allow the winners of the RockPaperTicket Game to mint their ticket. The following are its properties:

1. The ticket which represents entry to the created event comes in form of a SVG file. It contains information such as the event name, total amount of tickets, and the ticket number. The event name and total amount of tickets have to be passed in into the smart contract constructor.
2. Winners have to be added via the addWinner function. Only then are participants allowed to mint their ticket.
3. There is a maxSupply variable which requires the minted ticket amount to be below the total ticket amount.
4. Every winner can only mint 1 Ticket.