-- 1) Quantidade de ingressos vendidos
select sum(quantidade) as "Quantidade Ingressos vendidos" from parque.compra;

-- 2) Registro do show com seu nome e atores/atrizes escalados
select shows.id as "ID do Show", atracao.nome as "Nome do Show", registro_shows.data_realizado as "Data de realização", pessoa.nome as "Ator/Atriz Escalado" from atracao
inner join shows on atracao.id = shows.id
inner join registro_shows on shows.id = registro_shows.id_show
inner join escala_show on registro_shows.id = escala_show.id_reg_show
inner join pessoa on escala_show.cpf_ator = pessoa.cpf
order by data_realizado;

-- 3) Faturamento total Ingressos
select sum(valor) as "Faturamento Ingressos" from pagamento;

-- 4) Faturamento Total Lojas
select sum(valor) "Faturamento Lojas" from nota;

-- 5) Ranking de venda de ingressos por vendedor
select pessoa.nome, pessoa.cpf, count(compra.cpf_vendedor) as Quantidade_vendida from compra
inner join pessoa on compra.cpf_cliente = pessoa.cpf
group by compra.cpf_vendedor
order by Quantidade_vendida desc;

-- 6) Média de salário geral
select avg(salario) as "Média de Salário" from funcionario;

-- 7) Média de salário por cargo
select Avg(salario), 
Case 
 When operador.cpf Is Not null then "Operador"
 When atores.cpf Is Not null then "Ator"
 When vendedor_ingressos.cpf Is Not Null then "Vendedor Ingressos"
 When logista.cpf Is Not Null then "Logista"
 Else "Não Definido" End as Cargo 
from Funcionario 
left join operador on funcionario.cpf = operador.cpf
left join atores on funcionario.cpf = atores.cpf
left  join vendedor_ingressos on funcionario.cpf = vendedor_ingressos.cpf
left  join logista on funcionario.cpf = logista.cpf
Group By Cargo;

-- 8) Quantidade de Funcionários por Cargo
select count(*) "Quantidade de Funcionários", 
Case 
 When operador.cpf Is Not null then "Operador"
 When atores.cpf Is Not null then "Ator"
 When vendedor_ingressos.cpf Is Not Null then "Vendedor Ingressos"
 When logista.cpf Is Not Null then "Logista"
 Else "Não Definido" End as Cargo 
from Funcionario 
left join operador on funcionario.cpf = operador.cpf
left join atores on funcionario.cpf = atores.cpf
left  join vendedor_ingressos on funcionario.cpf = vendedor_ingressos.cpf
left  join logista on funcionario.cpf = logista.cpf
Group By Cargo;

-- 9) Soma de faturamento por logista 
select l.cpf as cpf_vendedor, p.nome as vendedor, sum(valor) as "Valor toal de vendas" from parque.nota as n
inner join logista as l on n.cpf_logista = l.cpf
inner join pessoa as p on l.cpf = p.cpf
group by cpf_logista;

-- 10) Ranking de vendas de produtos por loja
select l.id "ID loja", l.nome as "Nome da Loja", count(id_produto) as "Quantidade de produtos vendidos" from nota as n
inner join lojas as l on n.id_loja = l.id
inner join produtos_nota as pn on n.id = pn.id_nota
group by id_loja
order by count(id_produto) desc;

-- 11)  Ranking de faturamento ingressos por vendedor
select c.cpf_vendedor, pe.nome as nome_vendedor, sum(p.valor) as "Faturamento" from compra as c
inner join pagamento as p on c.id = p.id_compra
inner join pessoa as pe on c.cpf_vendedor = pe.cpf
group by c.cpf_vendedor
order by sum(p.valor) desc;

-- 12) Shows que passaram de 80% da capacidade máxima 
select *, rs.lotacao / s.lotacao_max as percentual from shows as s
inner join registro_shows as rs on rs.id_show = s.id having percentual >= 0.80;

-- 13) Quantidade de atraçõespor localidade
select localidade, count(*) as quantidade from atracao 
group by localidade;

-- 14) Maior idade minima por localidade 
select localidade, max(idade_minima) as idade_minima_max from atracao 
group by localidade;

-- 15) Quais produtos pertencem a quais lojas
select  p.id as id_produto, p.nome as nome_produto, p.preco as preco_produto, l.id as id_loja, l.nome as nome_loja from lojas as l
inner join loja_produtos as lp on l.id = lp.id_loja
inner join produtos as p on lp.id_produto = p.id;

-- 16 Media de preço de produtos por loja
select l.id as id_loja, l.nome as nome_loja, round(avg(p.preco),2) as "Média de preço dos produtos" from lojas as l
inner join loja_produtos as lp on l.id = lp.id_loja
inner join produtos as p on lp.id_produto = p.id
group by id_loja;

-- 17) Nome e cargo de funcionarios que ganham acima de 1800 R$
select pessoa.cpf, pessoa.nome, funcionario.salario, 
Case 
 When operador.cpf Is Not null then "Operador"
 When atores.cpf Is Not null then "Ator"
 When vendedor_ingressos.cpf Is Not Null then "Vendedor Ingressos"
 When logista.cpf Is Not Null then "Logista"
 Else "Não Definido" End as Cargo from funcionario 
inner join pessoa on pessoa.cpf = funcionario.cpf
left join operador on funcionario.cpf = operador.cpf
left join atores on funcionario.cpf = atores.cpf
left  join vendedor_ingressos on funcionario.cpf = vendedor_ingressos.cpf
left  join logista on funcionario.cpf = logista.cpf
where salario >= 1800
order by salario desc;

-- 18) Dia que mais foram comprados ingressos
select data_checkin as data, sum(quantidade) as quantidade_vendida 
from compra 
group by data_checkin 
order by quantidade_vendida desc 
limit 1;

-- 19) Faturamento Total
select sum(soma) as "Faturamento Total" from 
((select sum(valor) as soma from pagamento)
union
(select sum(valor) as soma from nota)) as x;


-- 20) Depesas total com salários
select round(sum(salario),2) as "Soma dos salários" from funcionario;