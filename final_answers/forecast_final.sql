use schema hol.public;

select * from vehicle_sales_by_make;

CREATE OR REPLACE VIEW honda_view AS (
    SELECT
        date,
        revenue
    FROM
        vehicle_sales_by_make
    WHERE
        make LIKE 'Honda'
);

select * from honda_view;

-- Create forecast using Cortex ML-Powered Function "Forecast"
-- Documentation https://docs.snowflake.com/en/user-guide/ml-powered-
-- Example of Single-Series Data Forecast
CREATE OR REPLACE snowflake.ml.forecast honda_forecast_model (
    INPUT_DATA => SYSTEM$REFERENCE('view', 'honda_view'),
    TIMESTAMP_COLNAME => 'date',
    TARGET_COLNAME => 'revenue'
);

-- Show models to confirm training has completed: 
SHOW snowflake.ml.forecast;

-- Forecasting model is now available as lobstermac_forecast
-- Use CALL to forecast the next thrity timestamps (30 Days):
CALL honda_forecast_model!FORECAST(FORECASTING_PERIODS => 30);

-- Use Chart to visualize the forecast
-- Select Chart Type = Line
-- Select Data FORECAST
-- Add column UPPER_BOUND
-- Add colum LOWER_BOUND
-- Keep TS as X-Axis

-- Let's save the forecasted value predictions as a new TABLE
CREATE OR REPLACE TABLE honda_forecast_table AS (
    SELECT *
    FROM TABLE(RESULT_SCAN(-1))
);

SELECT * FROM honda_forecast_table;

-- Add the forecasted value predictions (FORECAST, LOWER_BOUND, UPPER_BOUND) to the original input data
CREATE OR REPLACE VIEW combined_table_honda AS (
    SELECT TO_DATE(date) AS date, revenue, NULL as FORECAST, NULL as LOWER_BOUND, NULL AS UPPER_BOUND FROM honda_view
    UNION 
    SELECT TO_DATE(TS) AS date, NULL as revenue, FORECAST, LOWER_BOUND, UPPER_BOUND from honda_forecast_table
    ORDER BY date DESC
);

SELECT * FROM combined_table_honda;

-- Use Chart to visualize the forecast
-- Select Chart Type = Line
-- Select Data TOTAL_SOLD
-- Add column UPPER_BOUND
-- Add column FORECAST
-- Add colum LOWER_BOUND
-- Keep DATE as X-Axis

-- Now let's think about Forecasting on Multiple Series
-- Create view for all types of Mac & Cheese sales
-- Ensure you remove any unnecessary columns, else the model will attempt to use as exogenous variables
CREATE OR REPLACE VIEW all_make_view AS (
    SELECT *
    FROM
        vehicle_sales_by_make
);

SELECT DISTINCT make FROM all_make_view;

CREATE OR REPLACE snowflake.ml.forecast all_make_forecast (
  INPUT_DATA => SYSTEM$REFERENCE('view', 'all_make_view'),
  SERIES_COLNAME => 'make',
  TIMESTAMP_COLNAME => 'date',
  TARGET_COLNAME => 'revenue'
);

SHOW snowflake.ml.forecast;

-- Forecasting model is now available as lobstermac_forecast
-- Use CALL to forecast the next thrity timestamps (30 Days):
CALL all_make_forecast!FORECAST(FORECASTING_PERIODS => 30);

-- Let's save the forecasted value predictions as a new TABLE
CREATE OR REPLACE TABLE all_make_prediction AS (
    SELECT *
    FROM TABLE(RESULT_SCAN(-1))
);

SELECT * FROM all_make_prediction LIMIT 10;

-- Remove unnecessary quotes from the new SERIES column 
SELECT *, REGEXP_REPLACE(SERIES,'["]') as make FROM all_make_prediction;
-- Save output as the new mac_cheese_predictions table
CREATE OR REPLACE TABLE all_make_prediction_table AS (
    SELECT *
    FROM TABLE(RESULT_SCAN(-1))
);
-- Drop the unneccessary SERIES column
ALTER TABLE all_make_prediction DROP COLUMN SERIES;
-- View table
select * from all_make_prediction limit 10;

-- Add the forecasted value predictions (FORECAST, LOWER_BOUND, UPPER_BOUND) to the original input data for multiple items
CREATE OR REPLACE VIEW all_make_prediction_combined AS (
    SELECT TO_DATE(date) AS date, make, revenue, NULL as FORECAST, NULL as LOWER_BOUND, NULL AS UPPER_BOUND FROM ???
    UNION 
    SELECT TO_DATE(TS) AS date, make, NULL as revenue, FORECAST, LOWER_BOUND, UPPER_BOUND from ???
    ORDER BY date DESC
);

CREATE OR REPLACE VIEW all_make_prediction_combined AS (
    SELECT TO_DATE(date) AS date, make, revenue, NULL AS FORECAST 
    FROM all_make_view
    UNION 
    SELECT TO_DATE(TS) AS date, make, NULL AS revenue, ROUND(FORECAST, 0) AS FORECAST 
    FROM all_make_prediction_table
    ORDER BY date DESC
);

SELECT * FROM all_make_prediction_combined;

-- Use Chart to visualize the forecast
-- Select Chart Type = Line
-- Select Data FORECAST
-- Add column MENU_ITEM_NAME as SERIES
-- Keep Date as X-Axis