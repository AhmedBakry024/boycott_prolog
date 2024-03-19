:-consult(data).

% get the number of orders for a specific customer 

% Task 3: List all items in a specific customer order given customer id and order id.
getItemsInOrderById(CustName, OrderId, Items):- customer(X, CustName) , order(X, OrderId, Items).

% Task 4: return number of items in a specific customer order given customer name and order id.
itemsCount([], 0).
itemsCount([_|T], N):- itemsCount(T, N1), N is N1 + 1.
getNumOfItems(CustName, OrderId, Count):-
    customer(X, CustName),
    order(X, OrderId, Items),
    itemsCount(Items, Count).
% Task 6: return wether a company is a boycott company or not
isBoycott(Company):- boycott_company(X,_), Company =.. [X].