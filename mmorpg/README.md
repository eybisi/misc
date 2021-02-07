### MMORPG Exploit Guide


### General Approach

Since doing things in clientside wont effect that much, you should focus on network between
client and server while replaying/forging packets. 

Most of the mmorpg games encrypt their packets before sending out tho. So reversing games is completely another task. 


### Test List

#### Replay
    - Replay quest packets before finishing quest. Doing so you can get quest 1000x times and get 1000x reward after completion.
    - Replay quest packets that you already given/finished. 
    - 

#### Forging
    - Negative amounts! Anything related with signed integer, try to send negative amounts
    - Splitting items. 5x HP Pot splitted with -1000 => 1005,-1000 
    - Trading. Trading negative money -> Take money from other people
    - Buying item from NPC -> Get negative amount item so NPC gives you money
    - Selling item to NPC -> 
    - Sending item to other player. 



### Published Articles & Videos

https://www.rockpapershotgun.com/2013/05/20/neverwinter-money-making-exploit-sees-cryptic-turn-back-time/

https://www.youtube.com/watch?v=navVWmKpjNE

https://www.youtube.com/watch?v=hABj_mrP-no


