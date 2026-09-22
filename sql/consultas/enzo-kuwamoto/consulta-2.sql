WITH total_acessorios_por_venda AS (
    SELECT 
        vac_venda_id,
        SUM(vac_total) AS total_acessorios
    FROM concessionaria.venda_acessorio
    GROUP BY vac_venda_id
),
dados_forma_pagamento AS (
    SELECT 
        fpg.fpg_descricao AS forma_pagamento,
        vnd.vnd_valor_carro,
        vnd.vnd_desconto,
        (vnd.vnd_desconto / NULLIF(vnd.vnd_valor_carro, 0)) * 100 AS percentual_desconto,
        COALESCE(tac.total_acessorios, 0) AS valor_acessorios
    FROM concessionaria.venda AS vnd
    JOIN concessionaria.forma_pagamento AS fpg 
        ON fpg.fpg_id = vnd.vnd_forma_pagamento_id
    JOIN concessionaria.status_venda AS svd 
        ON svd.svd_id = vnd.vnd_status_venda_id
    LEFT JOIN total_acessorios_por_venda AS tac 
        ON tac.vac_venda_id = vnd.vnd_id
    WHERE svd.svd_nome = 'Entregue'
)
SELECT 
    forma_pagamento,
    COUNT(*) AS quantidade_vendas,
    ROUND(AVG(percentual_desconto), 2) AS desconto_medio_oferecido_percentual,
    ROUND(AVG(valor_acessorios), 2) AS ticket_medio_acessorios
FROM dados_forma_pagamento
GROUP BY 
    forma_pagamento
ORDER BY 
    quantidade_vendas DESC;
