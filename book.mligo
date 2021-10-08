
//the useed types in the contract
type book_supply = {
    book_address : address;
    book_price : tez ;
    book_stock : nat ;
    not_rent : bool ;
    book_name : string ; 
    book_catalogue: string ;
    book_short_description: string ;
    renters: (address) set;
}

type book_storage = (nat, book_supply) map
type return = operation list * book_storage

type book_id = nat

//types that are required for book transfer function 
type transfer_destination =
[@layout:comb]
{
  to_ : address;
  book_id : book_id;
  amount: nat;
}
 
type transfer =
[@layout:comb]
{
  from_ : address;
  txs : transfer_destination list;
}

type parameter =
        | Borrow of book_id
        | Return of book_id 
        | Nothing

//address to recieve money from book sales
let library_address : address = ("tz1QN6K6KGJ1aaRY4WHsmNWxLwjTAf7jnJNt" : address)

let borrow(book_index, book_storage : nat * book_storage): return =

  let renter : address = Tezos.sender in
  let book_kind : book_supply =
    match Map.find_opt (book_index) book_storage with
    | Some k -> k
    | None -> (failwith "Sorry,  Our library do not stock the requested book!" : book_supply)
  in
 
  // Check if the book is on sale  
  let () = if book_kind.not_rent = true then
    failwith "Sorry, This book is non-rent!"
  in

  // Check if offer is enough to cover price
  let () = if Tezos.amount < (book_kind.book_price ) then
    failwith "Sorry, You need to pay more on this book!"
  in

  // Check if the book is available.
  let () = if book_kind.book_stock = 0n then
    failwith "Sorry, We dont have any available of this book."
  in

  // Check renter have borrowed.
  let () = if Set.mem sender book_kind.renters then
    failwith "Sorry, Your just had borrored this book."
  in
  
  //Update our `book_address` available.
  let update_renter : address set = 
    Set.add renter book_kind.renters
  in 

  let book_storage = Map.update
    book_index
    (Some { book_kind with book_stock = abs (book_kind.book_stock - 1n); renters = update_renter  })
    book_storage
  in

  let tr : transfer = {
    from_ = Tezos.self_address;
    txs = [ {
      to_ = Tezos.sender;
      book_id = abs (book_kind.book_stock - 1n);
      amount = 1n;
    } ];
  }
  in

  // Transfer FA2 functionality
  let entrypoint : transfer list contract = 
    match ( Tezos.get_entrypoint_opt "%transfer" book_kind.book_address : transfer list contract option ) with
    | None -> ( failwith "Invalid external token contract" : transfer list contract )
    | Some e -> e
  in

  let fa2_operation : operation =
    Tezos.transaction [tr] 0tez entrypoint
  in

  // Payout to the shop address.
  let receiver : unit contract =
    match (Tezos.get_contract_opt library_address : unit contract option) with
    | Some (contract) -> contract
    | None -> (failwith ("Not a contract") : (unit contract))
  in
 
  let payout_operation : operation = 
    Tezos.transaction unit amount receiver 
  in
  ([fa2_operation ; payout_operation], book_storage)


let return_book(book_index, book_storage: book_id * book_storage): return = 

  let renter : address = Tezos.sender in

  let book_kind : book_supply =
    match Map.find_opt (book_index) book_storage with
    | Some k -> k
    | None -> (failwith "Sorry,  Our library do not stock the requested book!" : book_supply)
  in

  let update_renter : address set = 
    Set.remove renter book_kind.renters
  in

  let book_storage = Map.update
    book_index
    (Some { book_kind with book_stock = book_kind.book_stock + 1n; renters = update_renter  })
    book_storage
  in

  let tr : transfer = {
    from_ = Tezos.sender;
    txs = [ {
      to_ = Tezos.self_address;
      book_id = book_kind.book_stock + 1n;
      amount = 1n;
    } ];
  }
  in

  let entrypoint : transfer list contract = 
    match ( Tezos.get_entrypoint_opt "%transfer" book_kind.book_address : transfer list contract option ) with
    | None -> ( failwith "Invalid external token contract" : transfer list contract )
    | Some e -> e
  in
 
  let fa2_operation : operation =
    Tezos.transaction [tr] 0mutez entrypoint
  in

  ([fa2_operation], book_storage)



let main(action, book_storage: parameter*book_storage): return = 
   match (action) with
  | Borrow(book_id) -> borrow(book_id,book_storage)
  | Return(book_id) -> return_book(book_id,book_storage)
  | Nothing -> (([]:operation list),book_storage)

