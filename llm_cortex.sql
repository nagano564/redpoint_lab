USE DATABASE HOL;
USE SCHEMA PUBLIC;

SELECT * FROM SUPPORT_TRANSCRIPTS limit 10;

select transcript, snowflake.cortex.sentiment(???) 
from ???;

select transcript,snowflake.cortex.summarize(???) 
from ???;

SET prompt = 
'### 
Summarize this transcript in less than 200 words. 
Put the company name, experience and summary in JSON format. 
###';

select snowflake.cortex.complete('llama2-70b-chat',concat('[INST]',$prompt,transcript,'[/INST]')) as summary
from SUPPORT_TRANSCRIPTS ;

select snowflake.cortex.complete('mixtral-8x7b',concat('[INST]',$prompt,transcript,'[/INST]')) as summary
from SUPPORT_TRANSCRIPTS ;

select snowflake.cortex.complete('mistral-7b',concat('[INST]',$prompt,transcript,'[/INST]')) as summary
from SUPPORT_TRANSCRIPTS ;

select snowflake.cortex.complete('gemma-7b',concat('[INST]',$prompt,transcript,'[/INST]')) as summary
from SUPPORT_TRANSCRIPTS ;

select snowflake.cortex.complete('gemma-7b',concat('[INST]',$prompt,transcript,'[/INST]')) as summary
from SUPPORT_TRANSCRIPTS ;