CREATE TABLE account (
    username TEXT,
    fullname TEXT,
    balance INT,
    Group_id INT
);

INSERT INTO account (username, fullname, balance, Group_id) VALUES ('jones', 'Alice Jones', 82, 1);
INSERT INTO account (username, fullname, balance, Group_id) VALUES ('bitdiddl', 'Ben Bitdiddle', 65, 1);
INSERT INTO account (username, fullname, balance, Group_id) VALUES ('mike', 'Michael Dole ', 73, 2);
INSERT INTO account (username, fullname, balance, Group_id) VALUES ('alyssa', 'Alyssa P. Hacker', 79, 3);
INSERT INTO account (username, fullname, balance, Group_id) VALUES ('bbrown', 'Bob Brown', 100, 3);

-- Two separate terminals (Terminal 1 and Terminal 2) are used to connect to the database.
-- In Terminal 1, a transaction is started and the contents of the account table are displayed.
-- In Terminal 2, a transaction is started and the contents of the account table are displayed.
-- In Terminal 1, the username of "Alice Jones" is updated to "ajones".
-- In Terminal 1, the account table is displayed again and the change is visible in Terminal 1.
-- In Terminal 2, the account table is displayed again and the change is not visible in Terminal 2.
-- In Terminal 1, the changes are committed and the account table is displayed again. The changes are visible in both Terminal 1 and Terminal 2.
-- In Terminal 2, a new transaction is started.
-- In Terminal 1, the balance for Alice's account is updated by +10.
-- In Terminal 2, the balance for Alice's account is updated by +20.
-- Terminal 2 displays the account table and sees the new balance for Alice's account (+20).
-- In Terminal 1, the changes are committed.
-- In Terminal 2, the changes are rolled back and the balance for Alice's account is reset to its original value.
-- Two new separate transactions (T1 and T2) are started.
-- In Terminal 1 (T1), accounts with group_id=2 are read.
-- In Terminal 2 (T2), Bob is moved to group 2.
-- In Terminal 1 (T1), accounts with group_id=2 are read again and Bob is now part of that group.
-- In Terminal 1 (T1), the balances of the accounts in group 2 are updated by +15.
-- Both T1 and T2 commit their transactions, and there are no conflicts between them, so both isolation levels show the same result.