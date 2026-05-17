WITH sales as
(
    SELECT 
        sales_id,
        product_sk,
        customer_sk,
        {{multiply('unit_price', 'quantity') }} as calculated_gross_amount,
        gross_amount,
        payment_method
    FROM {{ ref('bronze_sales') }}
),

product as
(
    SELECT 
        product_sk,
        category
    FROM {{ ref('bronze_product') }}
),

customer as
(
    SELECT 
        customer_sk,
        gender
    FROM {{ ref('bronze_customer') }}
),

joined_query as
(
SELECT
    sales.sales_id,
    sales.gross_amount,
    sales.payment_method,
    product.category,
    customer.gender

FROM 
    sales
JOIN 
    product ON sales.product_sk = product.product_sk
JOIN 
    customer ON sales.customer_sk = customer.customer_sk
)

SELECT 
    category,
    gender,
    sum(gross_amount) as total_sales
FROM 
    joined_query
GROUP BY
    category,
    gender
ORDER BY
    total_sales DESC