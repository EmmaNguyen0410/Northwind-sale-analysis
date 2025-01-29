# Northwind Traders’s performance analysis 

## Description 
Leveraging sql, this project uses a database that contains sales data of a fictional company named Northwind Traders, which exports/imports goods all over the world to answer some business questions.

Use cases of following SQL concepts are demonstrated: 
- DDL (data definition): CREATE, ALTER, DROP
- Data integrity and constraints: PRIMARY KEY, FOREIGN KEY, UNIQUE.
- Basic queries: SELECT, WHERE.
- DML (Data manipulation language): INSERT, UPDATE, DELETE
- Data integrity and constraints: PRIMARY KEY, FOREIGN KEY. 
- Basic aggregate functions: COUNT, SUM, AVG, MIN, MAX
- Sorting and limiting: ORDER BY, LIMIT
- Joins: INNER JOIN, LEFT JOIN, SELF JOIN.
- Subqueries.
- Grouping: GROUP BY, HAVING.
- Window functions: ROW_NUMBER, DENSE_RANK.
- CTEs

Besides, in the future this project will implement following concepts: 
- Procedure and Functions 
- PREPARE, EXECUTE, DEALLOCATE for SQL injections prevention and performance optimization. 
- Indexing for speeding up queries.
- Backup 
- View
- Transaction: BEGIN, COMMIT, ROLLBACK
- Advanced joins: CROSS JOIN, FULL JOIN
- Set operation: UNION, INTERSECT, EXCEPT
- Window functions: LEAD, LAG


## Set up the database
1. Install Docker [here](https://docs.docker.com/engine/install/).
2. Clone this repository.
3. Navigate the terminal to the project folder and start a Docker instance using: 
```
docker-compose up -d
```
4. Connect to the database and run northwind.postgre.sql script to populate the data. 

## Business question analysis 
Each .sql file in /queries folder yields a corresponding .csv file that answers a business question.

1. Annual review of the company pricing strategy
