:-consult(data).

% get the number of orders for a specific customer 

% add item to the end of the list
add([], L, L).
add([H|T], L2, [H|NT]):-
add(T, L2, NT).

% Task 1: List all orders for a specific customer given customer name as a list.

getOrders(CustID, OrderID, [L|Rest]):- 
    order(CustID, OrderID, Items), 
    L = order(CustID, OrderID, Items),
    OrderID1 is OrderID + 1, 
    getOrders(CustID, OrderID1, Rest), !.

getOrders(_,_,[]).

list_orders(CustName, L):-
    customer(CustID, CustName), getOrders(CustID, 1, L).

% Task 2: Count the number of orders for a specific customer given customer name.
countOrdersOfCustomer(CustName, Count):-
    list_orders(CustName, L),
    getLength(L, Count).

getLength([], 0).
getLength([_|T], N):- getLength(T, N1), N is N1 + 1.

% Task 3: List all items in a specific customer order given customer id and order id.
getItemsInOrderById(CustName, OrderId, Items):- customer(X, CustName) , order(X, OrderId, Items).

% Task 4: return number of items in a specific customer order given customer name and order id.
itemsCount([], 0).
itemsCount([_|T], N):- itemsCount(T, N1), N is N1 + 1.
getNumOfItems(CustName, OrderId, Count):-
    customer(X, CustName),
    order(X, OrderId, Items),
    itemsCount(Items, Count).

% Task 5: return the total price of a specific customer order given customer name and order id.
calcPriceOfList([], 0).
calcPriceOfList([H|T], Price):- item(H, _, P), calcPriceOfList(T, Price1), Price is Price1 + P.
calcPriceOfOrder(CustName, OrderId, Price):-
    getItemsInOrderById(CustName, OrderId, Items),
    calcPriceOfList(Items, Price).

% Task 6: return wether a company is a boycott company or not
isBoycott(A):- boycott_company(X,_), A == X, ! ;
 item(A, Company, _), boycott_company(Company, _).

% Task 7: return the justifications for boycotting a company given the company name
whyToBoycott(Company, Justifications):- boycott_company(Company, Justifications).

% Task 8: Given an username and order ID, remove all the boycott items from this order.
removeBoycottItemsFromAnOrder(CustName, OrderId, NewItems):-
    getItemsInOrderById(CustName, OrderId, Items),
    removeBoycottItems(Items, NewItems).

removeBoycottItems([], []).
removeBoycottItems([H|T], NewItems):- 
    item(H, Company, _), boycott_company(Company, _), removeBoycottItems(T, NewItems), ! ;
    removeBoycottItems(T, NewItems1), add([H], NewItems1, NewItems).

% Task 9: Given a customer name and order ID, update the items in the order by replacing the boycott items with their alternatives.
replaceBoycottItemsFromAnOrder(CustName, OrderId, NewItems):-
    getItemsInOrderById(CustName, OrderId, Items),
    updateBoycottItems(Items, NewItems).

updateBoycottItems([], []).
updateBoycottItems([H|T], NewItems):- 
    isBoycott(H), alternative(H,Alternative), add([Alternative], NewItems1, NewItems), updateBoycottItems(T, NewItems1), ! ;
    updateBoycottItems(T, NewItems1), add([H], NewItems1, NewItems).

% Task 10: Given a customer name and order ID, calculate the total price of the order after replacing the boycott items with their alternatives.
calcPriceAfterReplacingBoycottItemsFromAnOrder(CustName, OrderId,NewItems, Price):-
    replaceBoycottItemsFromAnOrder(CustName, OrderId, NewItems),
    calcPriceOfList(NewItems, Price).

% Task 11: calculate the difference in price between a boycott product and its alternative
getTheDifferenceInPriceBetweenItemAndAlternative(BoycottProduct, AlternativeProduct, Diff):- alternative(BoycottProduct, AlternativeProduct) , item(BoycottProduct, _, Price1), item(AlternativeProduct, _, Price2), Diff is Price1 - Price2.