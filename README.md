Summary:
In this project, we cleaned and aggregated data from an e-commerce sales dataset with Excel, after that we imported the cleaned dataset to BigQuery and answered 5 questions about the data with SQL queries, to end this project we visualized the answers in Tableau to identify the insights easier.

We downloaded this dataset from Kaggle, the dataset contains a year's worth of transactions from an e-commerce business from London.

First we cleaned the dataset using Excel.
*we made sure we removed all duplicates
*we checked spelling and standardization
*we checked all formats were right
*removed money signs to avoid problems when importing the dataset to BigQuery

After that we added new columns using Excel
*we added TotalTransactions using multiplication functions
*we added the SaleType using IFS functions
*we added the Month, Weekday, and Year columns using functions depending on the date.

Next, we imported the data to Bigquery and we used SQL queries to answer the next questions:
1.	How many people buy in bulge and how does it compare to regular buyers?
2.	What were our best and worse months?
3.	They want to add some offers to a couple weekdays in January 2020.  which days should have an added discount and why?
4.	Should we target marketing campaigns to countries that performed well in the last year? What 3 countries other than the UK and why?

open SQL Queries folder to see queries.

After that we used those insights to create data visulizations in Tableau.

open Visualizations to see the results.
