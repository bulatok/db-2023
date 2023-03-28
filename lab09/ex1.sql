CREATE TYPE currency_type AS ENUM ('RUB');
CREATE TABLE IF NOT EXISTS accounts
(
    id       BIGSERIAL,
    name     TEXT,
    credit   INT,
    CURRENCY currency_type DEFAULT 'RUB'
);

INSERT INTO accounts (name, credit, CURRENCY) VALUES ('account1', 1000, 'RUB');
INSERT INTO accounts (name, credit, CURRENCY) VALUES ('account2', 1000, 'RUB');
INSERT INTO accounts (name, credit, CURRENCY) VALUES ('account3', 1000, 'RUB');

-- T1
BEGIN;
    SAVEPOINT savepoint;
    UPDATE accounts SET credit = credit - 500 WHERE name = 'account1';
    UPDATE accounts SET credit = credit + 500 WHERE name = 'account3';

    -- T2
    SAVEPOINT savepoint;
    UPDATE accounts SET credit = credit - 700 WHERE name = 'account2';
    UPDATE accounts SET credit = credit + 700 WHERE name = 'account1';

    -- T3
    SAVEPOINT savepoint;
    UPDATE accounts SET credit = credit - 100 WHERE name = 'account2';
    UPDATE accounts SET credit = credit + 100 WHERE name = 'account3';

    -- Return Credit for all Account
    SELECT * FROM accounts;

    ROLLBACK TO SAVEPOINT savepoint;
    RELEASE SAVEPOINT savepoint;
    ROLLBACK TO SAVEPOINT savepoint;
    RELEASE SAVEPOINT savepoint;
    ROLLBACK TO SAVEPOINT savepoint;
    RELEASE SAVEPOINT savepoint;
COMMIT;


-- B)
ALTER TABLE accounts ADD BankName VARCHAR(100);
UPDATE accounts SET BankName = 'SberBank' WHERE id = 1 OR id = 3;
UPDATE accounts SET BankName = 'Tinkoff' WHERE id = 2;

INSERT INTO accounts (name, credit, CURRENCY) VALUES ('account4', 0, 'RUB');

BEGIN;
    SAVEPOINT savepoint;
    UPDATE accounts SET credit = credit - 500 WHERE name = 'account1';
    UPDATE accounts SET credit = credit + 500 WHERE name = 'account3';


    -- T2
    SAVEPOINT savepoint;
    UPDATE accounts SET credit = credit - 700 WHERE name = 'account2';
    UPDATE accounts SET credit = credit + 700 WHERE name = 'account1';
    UPDATE accounts SET credit = credit - 30 WHERE name = 'account2';
    UPDATE accounts SET credit = credit + 30 WHERE name = 'account4';

    -- T3
    SAVEPOINT savepoint;
    UPDATE accounts SET credit = credit - 100 WHERE name = 'account2';
    UPDATE accounts SET credit = credit + 100 WHERE name = 'account3';
    UPDATE accounts SET credit = credit - 30 WHERE name = 'account2';
    UPDATE accounts SET credit = credit + 30 WHERE name = 'account4';


-- Return Credit for all Account
    SELECT * FROM accounts;

    ROLLBACK TO SAVEPOINT savepoint;
    RELEASE SAVEPOINT savepoint;
    ROLLBACK TO SAVEPOINT savepoint;
    RELEASE SAVEPOINT savepoint;
    ROLLBACK TO SAVEPOINT savepoint;
    RELEASE SAVEPOINT savepoint;
COMMIT;

-- C
CREATE TABLE Ledger
(
    ID                  BIGSERIAL PRIMARY KEY,
    FromID              INTEGER,
    ToID                INTEGER,
    Fee                 INTEGER,
    Amount              INTEGER,
    TransactionDateTime TIMESTAMP
);

-- for A
BEGIN;
    SAVEPOINT savepoint;
    UPDATE accounts SET credit = credit - 500 WHERE name = 'account1';
    UPDATE accounts SET credit = credit + 500 WHERE name = 'account3';
    INSERT INTO Ledger (FromID, ToID, Fee, Amount, TransactionDateTime) VALUES (1, 2, 0, 500, now());

    -- T2
    SAVEPOINT savepoint;
    UPDATE accounts SET credit = credit - 700 WHERE name = 'account2';
    UPDATE accounts SET credit = credit + 700 WHERE name = 'account1';
    INSERT INTO Ledger (FromID, ToID, Fee, Amount, TransactionDateTime) VALUES (2, 1, 0, 700, now());


    -- T3
    SAVEPOINT savepoint;
    UPDATE accounts SET credit = credit - 100 WHERE name = 'account2';
    UPDATE accounts SET credit = credit + 100 WHERE name = 'account3';
    INSERT INTO Ledger (FromID, ToID, Fee, Amount, TransactionDateTime) VALUES (2, 3, 0, 100, now());

    -- Return Credit for all Account and Ledger
    SELECT * FROM accounts;
    SELECT * FROM Ledger;

    ROLLBACK TO SAVEPOINT savepoint;
    RELEASE SAVEPOINT savepoint;
    ROLLBACK TO SAVEPOINT savepoint;
    RELEASE SAVEPOINT savepoint;
    ROLLBACK TO SAVEPOINT savepoint;
    RELEASE SAVEPOINT savepoint;
COMMIT;

-- for b
BEGIN;
    SAVEPOINT savepoint;
    UPDATE accounts SET credit = credit - 500 WHERE name = 'account1';
    UPDATE accounts SET credit = credit + 500 WHERE name = 'account3';
    INSERT INTO Ledger (FromID, ToID, Fee, Amount, TransactionDateTime) VALUES (1, 2, 0, 500, now());

-- T2
    SAVEPOINT savepoint;
    UPDATE accounts SET credit = credit - 700 WHERE name = 'account2';
    UPDATE accounts SET credit = credit + 700 WHERE name = 'account1';
    UPDATE accounts SET credit = credit - 30 WHERE name = 'account2';
    UPDATE accounts SET credit = credit + 30 WHERE name = 'account4';
    INSERT INTO Ledger (FromID, ToID, Fee, Amount, TransactionDateTime) VALUES (2, 1, 30, 500, now());


    -- T3
    SAVEPOINT savepoint;
    UPDATE accounts SET credit = credit - 100 WHERE name = 'account2';
    UPDATE accounts SET credit = credit + 100 WHERE name = 'account3';
    UPDATE accounts SET credit = credit - 30 WHERE name = 'account2';
    UPDATE accounts SET credit = credit + 30 WHERE name = 'account4';
    INSERT INTO Ledger (FromID, ToID, Fee, Amount, TransactionDateTime) VALUES (2, 3, 30, 500, now());



    -- Return Credit for all Account and Ledger
    SELECT * FROM accounts;
    SELECT * FROM Ledger;

    ROLLBACK TO SAVEPOINT savepoint;
    RELEASE SAVEPOINT savepoint;
    ROLLBACK TO SAVEPOINT savepoint;
    RELEASE SAVEPOINT savepoint;
    ROLLBACK TO SAVEPOINT savepoint;
    RELEASE SAVEPOINT savepoint;
COMMIT;