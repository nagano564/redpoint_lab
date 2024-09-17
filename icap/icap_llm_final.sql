USE DATABASE HOL;
USE SCHEMA SCHEMAXXX;

SELECT * FROM market_trends limit 10;

select market_insights, snowflake.cortex.sentiment(???) 
from ???;

select market_insights, snowflake.cortex.summarize(???) 
from ???;


SET prompt = 
'### 
Summarize this transcript in less than 200 words. 
Put the company name, sentiment as positive or negative and summary in JSON format. 
###';

select snowflake.cortex.complete('llama2-70b-chat',concat('[INST]',$prompt,market_insights,'[/INST]')) as complete_json
from market_trends ;

select snowflake.cortex.complete('mixtral-8x7b',concat('[INST]',$prompt,market_insights,'[/INST]')) as complete_json
from market_trends ;

select snowflake.cortex.complete('mistral-7b',concat('[INST]',$prompt,market_insights,'[/INST]')) as complete_json
from market_trends ;

select snowflake.cortex.complete('gemma-7b',concat('[INST]',$prompt,market_insights,'[/INST]')) as complete_json
from market_trends ;

select snowflake.cortex.complete('gemma-7b',concat('[INST]',$prompt,market_insights,'[/INST]')) as complete_json
from market_trends ;