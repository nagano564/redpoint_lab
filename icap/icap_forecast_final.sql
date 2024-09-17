use schema hol.schema0;
use warehouse wh0;

select * from equity_price;

CREATE OR REPLACE VIEW osu_view AS (
    SELECT
        date,
        price
    FROM
        equity_price
    WHERE
        ticker LIKE 'OSU'
);

select * from osu_view;

-- Create forecast using Cortex ML-Powered Function "Forecast"
-- Documentation https://docs.snowflake.com/en/user-guide/ml-powered-
-- Example of Single-Series Data Forecast
CREATE OR REPLACE snowflake.ml.forecast osu_forecast_model (
    INPUT_DATA => SYSTEM$REFERENCE('view', '???'),
    TIMESTAMP_COLNAME => 'date',
    TARGET_COLNAME => '???'
);

-- Show models to confirm training has completed: 
SHOW snowflake.ml.forecast;

-- Forecasting model is now available as lobstermac_forecast
-- Use CALL to forecast the next thrity timestamps (30 Days):
CALL ???!FORECAST(FORECASTING_PERIODS => 30);

-- Use Chart to visualize the forecast
-- Select Chart Type = Line
-- Select Data FORECAST
-- Add column UPPER_BOUND
-- Add colum LOWER_BOUND
-- Keep TS as X-Axis

-- Let's save the forecasted value predictions as a new TABLE
CREATE OR REPLACE TABLE osu_forecast_table AS (
    SELECT *
    FROM TABLE(RESULT_SCAN(-1))
);

SELECT * FROM osu_forecast_table;

-- Add the forecasted value predictions (FORECAST, LOWER_BOUND, UPPER_BOUND) to the original input data
CREATE OR REPLACE VIEW combined_osu_table AS (
    SELECT TO_DATE(date) AS date, price, NULL as FORECAST, NULL as LOWER_BOUND, NULL AS UPPER_BOUND FROM osu_view
    UNION 
    SELECT TO_DATE(TS) AS date, NULL as price, FORECAST, LOWER_BOUND, UPPER_BOUND from osu_forecast_table
    ORDER BY date DESC
);

SELECT * FROM combined_osu_table;

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
CREATE OR REPLACE VIEW all_ticker_view AS (
    SELECT *
    FROM
        equity_price
);

SELECT DISTINCT ticker FROM all_ticker_view;
SELECT *  FROM all_ticker_view;


CREATE OR REPLACE snowflake.ml.forecast all_ticker_forecast (
  INPUT_DATA => SYSTEM$REFERENCE('view', '???'),
  SERIES_COLNAME => '???',
  TIMESTAMP_COLNAME => 'date',
  TARGET_COLNAME => '???'
);

SHOW snowflake.ml.forecast;

-- Forecasting model is now available as lobstermac_forecast
-- Use CALL to forecast the next thrity timestamps (30 Days):
CALL ???!FORECAST(FORECASTING_PERIODS => 30);

-- Let's save the forecasted value predictions as a new TABLE
CREATE OR REPLACE TABLE all_ticker_prediction AS (
    SELECT *
    FROM TABLE(RESULT_SCAN(-1))
);

SELECT * FROM all_ticker_prediction LIMIT 10;

-- Remove unnecessary quotes from the new SERIES column 
SELECT *, REGEXP_REPLACE(SERIES,'["]') as ticker FROM all_ticker_prediction;
-- Save output as the new mac_cheese_predictions table
CREATE OR REPLACE TABLE clean_all_ticker_prediction AS (
    SELECT *
    FROM TABLE(RESULT_SCAN(-1))
);
-- Drop the unneccessary SERIES column
--ALTER TABLE all_ticker_prediction DROP COLUMN SERIES;
-- View table
select * from all_ticker_prediction_table limit 10;

-- Add the forecasted value predictions (FORECAST, LOWER_BOUND, UPPER_BOUND) to the original input data for multiple items
CREATE OR REPLACE VIEW all_ticker_prediction_combined AS (
    SELECT TO_DATE(date) AS date, ticker, price, NULL as FORECAST, NULL as LOWER_BOUND, NULL AS UPPER_BOUND FROM ???
    UNION 
    SELECT TO_DATE(TS) AS date,ticker, NULL as price, FORECAST, LOWER_BOUND, UPPER_BOUND from ???
    ORDER BY date DESC
);

SELECT * FROM ???;

-- Use Chart to visualize the forecast
-- Select Chart Type = Line
-- Select Data FORECAST
-- Add column MENU_ITEM_NAME as SERIES
-- Keep Date as X-Axis