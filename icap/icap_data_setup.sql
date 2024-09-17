USE ROLE accountadmin;
CREATE OR REPLACE DATABASE HOL;
USE SCHEMA PUBLIC;

CREATE OR REPLACE TABLE equity_price (
    date TIMESTAMP_NTZ,
    ticker STRING,
    price DECIMAL(10,2)
);

INSERT INTO equity_price (date, ticker, price)
WITH RECURSIVE dates AS (
    SELECT TO_TIMESTAMP_NTZ('2023-01-01') AS date
    UNION ALL
    SELECT DATEADD(day, 1, date)
    FROM dates
    WHERE date < TO_TIMESTAMP_NTZ('2023-12-31')
),
funds AS (
    SELECT 'LVM' AS ticker, 40.0 AS base_price
    UNION ALL
    SELECT 'OSU', 80.0
    UNION ALL
    SELECT 'HHYL', 60.0
),
prices AS (
    SELECT 
        d.date,
        f.ticker,
        f.base_price AS price,
        f.base_price AS last_price
    FROM dates d, funds f
    WHERE d.date = TO_TIMESTAMP_NTZ('2023-01-01')

    UNION ALL

    SELECT
        d.date,
        p.ticker,
        CASE
            -- Adjust price by a random percentage between -5% and +5%
            WHEN p.ticker = 'LVM' THEN p.last_price + (p.last_price * (uniform(-0.05, 0.05, random())))
            WHEN p.ticker = 'OSU' THEN p.last_price + (p.last_price * (uniform(-0.07, 0.07, random())))
            WHEN p.ticker = 'HHYL' THEN p.last_price + (p.last_price * (uniform(-0.04, 0.04, random())))
        END AS price,
        p.price AS last_price
    FROM dates d
    JOIN prices p ON d.date = DATEADD(day, 1, p.date)
    WHERE d.date <= TO_TIMESTAMP_NTZ('2023-12-31')
)
SELECT
    date,
    ticker,
    TRUNC(price, 2) AS price
FROM prices
ORDER BY date, ticker;


select * from equity_price where ticker = 'OSU';


----completed----

CREATE or replace TABLE market_trends (
    date_created DATE,
    rep_id STRING,
    market_insights STRING
);

INSERT INTO market_trends (date_created, rep_id, market_insights)
VALUES
    ('2024-08-01', '001', 'The rapid adoption of cloud computing has been a game changer for businesses of all sizes. Companies like CloudStream and DataSphere have been leading the charge, helping enterprises transition to cloud-based infrastructures. Many businesses report that the move has resulted in a significant reduction in costs and operational inefficiencies. In particular, the scalability offered by providers such as CloudStream has allowed companies to grow without being burdened by heavy infrastructure investments. The excitement in the tech industry is palpable, as firms are increasingly relying on advanced AI and machine learning services to drive innovation.'),
    ('2024-08-02', '002', 'The global semiconductor shortage has been a major disruption, causing severe delays in production across multiple industries. Companies like ChipMaster and SiliconTech are struggling to keep up with the demand for chips, and their inability to meet production schedules is frustrating manufacturers across sectors like automotive and consumer electronics. As a result, the prices of devices that rely on these components, including smartphones and laptops, have soared. The situation has led to a loss of confidence in the supply chain, with many companies considering alternative solutions to reduce dependency on a few key suppliers.'),
    ('2024-08-03', '003', 'Generative AI has taken the tech world by storm, with companies like InnovAI and MindForge leading the innovation. Businesses are rapidly integrating AI solutions to automate creative tasks, improve customer engagement, and drive operational efficiencies. InnovAI, in particular, has been praised for its cutting-edge language models, which are revolutionizing content creation for marketing and customer service applications. The buzz around generative AI has only intensified as more companies report dramatic improvements in productivity and customer satisfaction, solidifying AI as a cornerstone of future tech developments.'),
    ('2024-08-04', '004', 'Cybersecurity threats have been on the rise, with several high-profile data breaches causing concern across industries. Despite significant investments from companies like SecureGuard and CyberFortress, many organizations are still falling victim to sophisticated attacks. The frequency and severity of ransomware attacks have created a sense of urgency in the tech sector, as firms struggle to stay ahead of evolving threats. As data breaches continue to make headlines, the trust between businesses and their customers is eroding, with many consumers becoming increasingly wary of sharing their personal information online.'),
    ('2024-08-05', '001', 'The shift to remote and hybrid work models has been widely embraced by the tech industry, with companies like CollabSync and FlexiNet providing robust solutions for seamless communication and collaboration. Employees across multiple sectors are reporting higher levels of productivity and job satisfaction, citing the flexibility of working from home as a major factor. CollabSync's enhanced video conferencing and collaboration tools have received widespread praise for their reliability and user-friendly interface, enabling businesses to maintain a strong sense of teamwork and efficiency despite being geographically dispersed.'),
    ('2024-08-06', '002', 'The startup ecosystem has faced a harsh reality this year, as venture capital funding has dried up for many emerging tech companies. Startups that once thrived, such as FinzTech and GreenCortex, are now struggling to secure the necessary investments to keep their projects alive. Investors have become more cautious, especially outside of AI and fintech sectors, leading to widespread layoffs and stalled product launches. The once-booming excitement around tech startups has been replaced by a sense of uncertainty, as many founders fear they may not survive this challenging period.'),
    ('2024-08-07', '003', 'Big Tech companies are making bold moves in virtual and augmented reality, sparking widespread excitement among consumers and investors alike. Innovators like VisionaryTech and MetaZone are pushing the boundaries of immersive experiences, with next-generation VR headsets and AR applications poised to revolutionize industries from gaming to healthcare. VisionaryTech's latest VR release has been especially well-received, offering unparalleled realism and interactivity that are setting new standards in the industry. The potential applications for education, entertainment, and business seem limitless, fueling optimism about the future of these technologies.'),
    ('2024-08-08', '004', 'While quantum computing continues to be hailed as the next frontier of technological innovation, progress has been slower than expected. Despite heavy investments from companies like QuantumCore and QubitMax, many in the industry are growing frustrated with the lack of tangible breakthroughs. The promise of quantum computing solving complex problems such as cryptography and drug discovery remains largely theoretical, and experts are beginning to temper their expectations about its short-term commercial viability. This has caused a growing divide in the tech community, with some questioning whether the hype around quantum computing has been premature.');
