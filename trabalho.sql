-- 1) Quantidade de ingressos vendidos
SELECT SUM(quantidade) AS "Quantidade Ingressos Vendidos" FROM parque.compra;

-- 2) Registro do show com seu nome e atores/atrizes escalados
SELECT shows.id AS "ID do Show", atracao.nome AS "Nome do Show", registro_shows.data_realizado AS "Data de Realização", pessoa.nome AS "Ator/Atriz Escalado"
FROM atracao
INNER JOIN shows ON atracao.id = shows.id
INNER JOIN registro_shows ON shows.id = registro_shows.id_show
INNER JOIN escala_show ON registro_shows.id = escala_show.id_reg_show
INNER JOIN pessoa ON escala_show.cpf_ator = pessoa.cpf
ORDER BY data_realizado;

-- 3) Faturamento total Ingressos
SELECT SUM(valor) AS "Faturamento Ingressos" FROM pagamento;

-- 4) Faturamento Total Lojas
SELECT SUM(valor) AS "Faturamento Lojas" FROM nota;

-- 5) Ranking de venda de ingressos por vendedor
SELECT pessoa.nome, pessoa.cpf, COUNT(compra.cpf_vendedor) AS "Quantidade Vendida"
FROM compra
INNER JOIN pessoa ON compra.cpf_cliente = pessoa.cpf
GROUP BY compra.cpf_vendedor
ORDER BY Quantidade_Vendida DESC;

-- 6) Média de salário geral
SELECT AVG(salario) AS "Média de Salário" FROM funcionario;

-- 7) Média de salário por cargo
SELECT AVG(salario) AS "Média de Salário", 
  CASE 
    WHEN operador.cpf IS NOT NULL THEN 'Operador'
    WHEN atores.cpf IS NOT NULL THEN 'Ator'
    WHEN vendedor_ingressos.cpf IS NOT NULL THEN 'Vendedor Ingressos'
    WHEN logista.cpf IS NOT NULL THEN 'Logista'
    ELSE 'Não Definido'
  END AS Cargo 
FROM funcionario 
LEFT JOIN operador ON funcionario.cpf = operador.cpf
LEFT JOIN atores ON funcionario.cpf = atores.cpf
LEFT JOIN vendedor_ingressos ON funcionario.cpf = vendedor_ingressos.cpf
LEFT JOIN logista ON funcionario.cpf = logista.cpf
GROUP BY Cargo;

-- 8) Quantidade de Funcionários por Cargo
SELECT COUNT(*) AS "Quantidade de Funcionários", 
  CASE 
    WHEN operador.cpf IS NOT NULL THEN 'Operador'
    WHEN atores.cpf IS NOT NULL THEN 'Ator'
    WHEN vendedor_ingressos.cpf IS NOT NULL THEN 'Vendedor Ingressos'
    WHEN logista.cpf IS NOT NULL THEN 'Logista'
    ELSE 'Não Definido'
  END AS Cargo 
FROM funcionario 
LEFT JOIN operador ON funcionario.cpf = operador.cpf
LEFT JOIN atores ON funcionario.cpf = atores.cpf
LEFT JOIN vendedor_ingressos ON funcionario.cpf = vendedor_ingressos.cpf
LEFT JOIN logista ON funcionario.cpf = logista.cpf
GROUP BY Cargo;

-- 9) Soma de faturamento por logista 
SELECT l.cpf AS cpf_vendedor, p.nome AS vendedor, SUM(valor) AS "Valor Total de Vendas"
FROM parque.nota AS n
INNER JOIN logista AS l ON n.cpf_logista = l.cpf
INNER JOIN pessoa AS p ON l.cpf = p.cpf
GROUP BY cpf_logista;

-- 10) Ranking de vendas de produtos por loja
SELECT l.id AS "ID Loja", l.nome AS "Nome da Loja", COUNT(id_produto) AS "Quantidade de Produtos Vendidos"
FROM nota AS n
INNER JOIN lojas AS l ON n.id_loja = l.id
INNER JOIN produtos_nota AS pn ON n.id = pn.id_nota
GROUP BY id_loja
ORDER BY COUNT(id_produto) DESC;

-- 11)  Ranking de faturamento ingressos por vendedor
SELECT c.cpf_vendedor, pe.nome AS nome_vendedor, SUM(p.valor) AS "Faturamento"
FROM compra AS c
INNER JOIN pagamento AS p ON c.id = p.id_compra
INNER JOIN pessoa AS pe ON c.cpf_vendedor = pe.cpf
GROUP BY c.cpf_vendedor
ORDER BY SUM(p.valor) DESC;

-- 12) Shows que passaram de 80% da capacidade máxima 
SELECT *, rs.lotacao / s.lotacao_max AS percentual
FROM shows AS s
INNER JOIN registro_shows AS rs ON rs.id_show = s.id
HAVING percentual >= 0.80;

-- 13) Quantidade de atrações por localidade
SELECT localidade, COUNT(*) AS quantidade FROM atracao 
GROUP BY localidade;

-- 14) Maior idade mínima por localidade 
SELECT localidade, MAX(idade_minima) AS idade_minima_max FROM atracao 
GROUP BY localidade;

-- 15) Quais produtos pertencem a quais lojas
SELECT p.id AS "ID Produto", p.nome AS "Nome do Produto", p.preco AS "Preço do Produto", l.id AS "ID Loja", l.nome AS "Nome da Loja"
FROM lojas AS l
INNER JOIN loja_produtos AS lp ON l.id = lp.id_loja
INNER JOIN produtos AS p ON lp.id_produto = p.id;

-- 16) Média de preço de produtos por loja
SELECT l.id AS "ID Loja", l.nome AS "Nome da Loja", ROUND(AVG(p.preco), 2) AS "Média de Preço dos Produtos"
FROM lojas AS l
INNER JOIN loja_produtos AS lp ON l.id = lp.id_loja
INNER JOIN produtos AS p ON lp.id_produto = p.id
GROUP BY id_loja;

-- 17) Nome e cargo de funcionários que ganham acima de 1800 R$
SELECT pessoa.cpf, pessoa.nome, funcionario.salario, 
  CASE 
    WHEN operador.cpf IS NOT NULL THEN 'Operador'
    WHEN atores.cpf IS NOT NULL THEN 'Ator'
    WHEN vendedor_ingressos.cpf IS NOT NULL THEN 'Vendedor Ingressos'
    WHEN logista.cpf IS NOT NULL THEN 'Logista'
    ELSE 'Não Definido'
  END AS Cargo
FROM funcionario 
INNER JOIN pessoa ON pessoa.cpf = funcionario.cpf
LEFT JOIN operador ON funcionario.cpf = operador.cpf
LEFT JOIN atores ON funcionario.cpf = atores.cpf
LEFT JOIN vendedor_ingressos ON funcionario.cpf = vendedor_ingressos.cpf
LEFT JOIN logista ON funcionario.cpf = logista.cpf
WHERE salario >= 1800
ORDER BY salario DESC;

-- 18) Dia que mais foram comprados ingressos
SELECT data_checkin AS data, SUM(quantidade) AS quantidade_vendida 
FROM compra 
GROUP BY data_checkin 
ORDER BY quantidade_vendida DESC 
LIMIT 1;

-- 19) Faturamento Total
SELECT SUM(soma) AS "Faturamento Total" 
FROM ((SELECT SUM(valor) AS soma FROM pagamento)
UNION
(SELECT SUM(valor) AS soma FROM nota)) AS x;

-- 20) Despesas total com salários
SELECT ROUND(SUM(salario), 2) AS "Soma dos Salários" FROM funcionario;
