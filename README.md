# Task-2
## Exploratory Data Analysis (EDA) & Business Intelligence
- An end-to-end EDA and BI project on a retail sales dataset — covering descriptive statistics, univariate and multivariate analysis, correlation analysis,
  and business-focused SQL querying to uncover actionable insights on revenue, customers, and product performance.
- To uncover patterns, trends, and relationships within the data and develop proficiency in SQL for data extraction and basic dashboarding.

 ## Tools & Tech Stack
- SQL — filtering, aggregation, joins, window functions.
- Excel — result exports, pivot-style summaries, Dashboard & charts.
- VS Code + Git/GitHub — version control and project hosting.

## Task Performed
## Descriptive Statistics & Univariate Analysis
# Numerical fields summary query
- Calculates the mean, median, standard deviation, minimum, and maximum of Total_Sales to summarize the spread and typical value of order amounts.
#Categorical fields summary query
- Counts orders per Category and calculates each category's percentage share of total orders, sorted from most to least frequent.
  
## SQL Business Questions
- 	Top 5 products by revenue	: Aggregation, sorting
- 	Monthly revenue & active customer trend :	Date functions, DISTINCT
- 	Revenue & AOV by city :	Multi-aggregate, NULL handling
- 	Which age group buys most per category? :	CASE binning, multi-GROUP BY
- 	Top 5 customers by spend : Multi-column GROUP BY
- 	AOV difference by gender :	Simple GROUP BY comparison
- 	Category revenue vs. target : (JOIN)	Multi-table JOIN
  
## Multivariate Analysis & Correlation
- Computes the Pearson correlation between Age and Total_Sales from scratch: the stats CTE first finds the average of each variable, then the main query sums the products of each row's deviation from those averages (the covariance) and divides by the square root of the sum of squared deviations for each variable (their standard deviations) — the result is a value between -1 and 1 showing the strength and direction of the linear relationship.
  
## Repeat Customer Rate
- Counts how many orders each customer placed, then calculates what percentage of all customers placed more than one order — giving the repeat customer rate.

## Key Findings
- Electronics is the top-performing category, driving ~35% of all orders.
- Total_Sales is right-skewed — a small number of high-value orders pull the average up well above the median.
- Unit_Price and Quantity are the real drivers of revenue; Age has no measurable effect on spend.
- Bengaluru has the highest average order value, despite not leading in total order volume.
- Only 5.2% of customers are repeat buyers — retention, not acquisition, is the clearer growth lever.
