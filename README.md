# Smart contract to borrow a book in library

## This contract only use for tesing.

## Features

- Make using cameLigo
- This smart contract use to borrow book and return book.
- It saving the history of renters.


View contract using Better Call Dev

[Link](https://better-call.dev/granadanet/KT19LwRrCcfwqzBf8xStQghm3TYqCED1dERE/operations)

The address of this contract:

> KT19LwRrCcfwqzBf8xStQghm3TYqCED1dERE

The initial storage of your contract is:

```
[ { "prim": "Elt", "args": [ { "int": "0" }, { "prim": "Pair", "args": [ { "prim": "Pair", "args": [ { "prim": "Pair", "args": [ { "string": "KT19hXKZjvg7KqQw78qfsbTQzZ5FMbNvkt7v" }, { "string": "Contemporary fantasy novels" } ] }, { "string": "Harry Potter 1" }, { "int": "5" } ] }, { "prim": "Pair", "args": [ { "string": "Harry Potter and the Sorcerer Stone" }, { "int": "5" } ] }, { "prim": "True" }, [ { "string": "KT19hXKZjvg7KqQw78qfsbTQzZ5FMbNvkt7v" } ] ] } ] }, { "prim": "Elt", "args": [ { "int": "1" }, { "prim": "Pair", "args": [ { "prim": "Pair", "args": [ { "prim": "Pair", "args": [ { "string": "KT1BPsnNSY3uotJA3tT4ZzoDZrMaAuXWdEEn" }, { "string": "Lifestyle" } ] }, { "string": "How To Win Friends and Influence People" }, { "int": "10" } ] }, { "prim": "Pair", "args": [ { "string": "How To Win Friends and Influence People" }, { "int": "1" } ] }, { "prim": "False" }, [ { "string": "KT1BPsnNSY3uotJA3tT4ZzoDZrMaAuXWdEEn" } ] ] } ] } ]
```

## Storage for test

```

Map.literal [ 
  (0n, { 
    book_stock = 5n ; 
    book_address = ("KT19hXKZjvg7KqQw78qfsbTQzZ5FMbNvkt7v" : address); 
    book_price = 5mutez ; 
    not_rent = True ; 
    book_name = "Harry Potter 1" ;
    book_catalogue = "Contemporary fantasy novels" ;
    book_short_description = "Harry Potter and the Sorcerer Stone" ;
    renters = Set.literal[("KT19hXKZjvg7KqQw78qfsbTQzZ5FMbNvkt7v":address)] ;
  }); 
  (1n, { 
    book_stock = 1n ; 
    book_address = ("KT1BPsnNSY3uotJA3tT4ZzoDZrMaAuXWdEEn" : address); 
    book_price = 10mutez ; 
    not_rent = false ; 
    book_name = "How To Win Friends and Influence People" ;
    book_catalogue = "Lifestyle" ;
    book_short_description = "How To Win Friends and Influence People" ;
    renters =  Set.literal[("KT1BPsnNSY3uotJA3tT4ZzoDZrMaAuXWdEEn":address)];
  })
]
```