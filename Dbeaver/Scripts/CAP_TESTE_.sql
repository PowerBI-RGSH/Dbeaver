-- RGSH.CAP_TESTE source

CREATE OR REPLACE FORCE EDITIONABLE VIEW "RGSH"."CAP_TESTE" ("ID", "PARCELA", "ID_PAR", "OHF_CITEM", "V_DESP", "OHF_VALOR", "OHF_CPART2", "A1_NOME", "NVE_TITULO", "CLI_CA", "CLASSIFICACAO", "TIPO", "PREFIXO", "FORNECEDOR", "EMISSAO", "VENCIMENTO", "DATA", "DESCRITIVO", "DESCRITIVO2", "NATUREZA", "VALOR_LIQUDO", "VALOR_PAGO", "RD0_NOME", "OHF_CNATUR", "ED_DESCRIC") AS 
  SELECT 
    E2_NUM AS ID,
    E2_PARCELA AS Parcela,
    E2_NUM || '/' || E2_PARCELA AS ID_PAR, 
    B.OHF_CITEM,
    OHF_VALOR AS V_Desp,
    B.OHF_VALOR,
    B.OHF_CPART2,
    E.A1_NOME,
    F.NVE_TITULO,
    CASE WHEN E.A1_NOME IS NOT NULL THEN E.A1_NOME || '/' ||  F.NVE_TITULO ELSE '' END AS Cli_Ca,
    CASE WHEN E.A1_NOME IS NULL THEN 'Estrutura/RGSH' ELSE 'Reembolso' END AS Classificacao,
    E2_TIPO AS Tipo,
    E2_PREFIXO AS Prefixo,
    E2_NOMFOR AS Fornecedor,
    TO_CHAR(TO_DATE(E2_EMISSAO, 'YYYYMMDD'), 'DD/MM/YYYY') AS Emissao,
    TO_CHAR(TO_DATE(E2_VENCREA, 'YYYYMMDD'), 'DD/MM/YYYY') AS Vencimento,
    CASE WHEN E2_BAIXA = '     ' THEN ''  ELSE TO_CHAR(TO_DATE(E2_BAIXA, 'YYYYMMDD'), 'DD/MM/YYYY') END AS Data,
    E2_HIST AS Descritivo,
    UTL_RAW.CAST_TO_VARCHAR2(OHF_HISTOR) AS Descritivo2,    
    E2_NATUREZ AS Natureza,
    E2_VALOR AS Valor_Liqudo,
    E2_VALLIQ AS Valor_Pago,
    C.RD0_NOME,
    B.OHF_CNATUR,
    D.ED_DESCRIC    
FROM
    SISJURI.SE2010 -- CAP
LEFT JOIN
    SISJURI.FK7010 A ON E2_NUM = A.FK7_NUM AND E2_PARCELA = A.FK7_PARCEL -- Tabela Intermediária CAP/Desd
LEFT JOIN
    SISJURI.OHF010 B ON A.FK7_IDDOC = B.OHF_IDDOC -- Desdobramentos
LEFT JOIN
    SISJURI.RD0010 C ON B.OHF_CPART2 = C.RD0_CODIGO -- Participante
LEFT JOIN
    SISJURI.SED010 D ON B.OHF_CNATUR = D.ED_CODIGO
LEFT JOIN
    SISJURI.SA1010 E ON B.OHF_CCLIEN = E.A1_COD AND B.OHF_CLOJA = A1_LOJA -- Cliente
LEFT JOIN
    SISJURI.NVE010 F ON B.OHF_CCLIEN = F.NVE_CCLIEN AND B.OHF_CCASO = F.NVE_NUMCAS -- Caso
WHERE
    SISJURI.SE2010.D_E_L_E_T_ <> '*'
AND
    A.D_E_L_E_T_ <> '*'
AND
    B.D_E_L_E_T_ <> '*'
--AND
  --  D.D_E_L_E_T_ <> '*'
--AND
    --D.ED_FILIAL <> '0101'
ORDER BY 
    E2_VENCREA DESC; ----TESTEEEE----