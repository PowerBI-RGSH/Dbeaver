-- RGSH.VW_LANCAMENTOS_V1 source

CREATE OR REPLACE FORCE EDITIONABLE VIEW "RGSH"."VW_LANCAMENTOS_V1" ("OHB_CODIGO", "DATA_INCLUSAO", "OHB_CPART", "SOLICITANTE", "ORIGEM", "OHB_NATORI", "OHB_CCUSTO", "OHB_CPARTO", "OHB_NATDES", "OHB_CCUSTD", "OHB_CPARTD", "OHB_CCLID", "OHB_CLOJD", "OHB_CCASOD", "OHB_CTPDPD", "OHB_CDESPD", "OHB_COBRAD", "DATA_DESPESA", "DATA_LANCAMENTO", "OHB_CMOELC", "OHB_VALOR", "DESCRITIVO", "OHB_COTAC", "OHB_CMOEC", "OHB_VALORC", "OHB_CUSINC", "OHB_CPAGTO", "OHB_CRECEB", "OHB_ITDES", "OHB_VLNAC", "CAP_ID", "CAP_PARC", "FATURA_ID", "FATURA_PARC", "NAT_DEST", "NAT_ORI", "NOMECLI", "NOMECASO", "SITUAÇÃO_DESPESA", "DESCRICAO_DESPESA", "NOMETIPODESP", "COBRAR_DESP", "NVE_CAREAJ", "STATUS_DESP", "EMISSAO_FAT", "VENC_FAT", "BAIXA_FATURA", "FAT_DESP", "SIGLAMOEDA_DESP", "NOME_PART", "MOEDA", "NATUREZA_CORRETA", "SITUAÇÃO_DESPESA_2", "SITUACAO_DESP", "E2_NOMFOR", "RD0_CC", "BANCO_CAP", "COBRAR_CONTRATO", "COD_CONTRATO", "NOME_CONTRATO", "TIPO_DESP_N_COBRAR", "ÁREA_TOTAL", "SITUACAO_WO", "EMISSAO_WO", "MOTIVO_WO", "OBS_WO", "DATA_CANCEL_WO", "COD_WO_DESPESA") AS 
  SELECT DISTINCT 
    OHB_CODIGO,
    TO_CHAR(TO_DATE(OHB_DTINCL, 'YYYYMMDD'), 'DD/MM/YYYY') AS Data_Inclusao,
    OHB_CPART,
    D.RD0_NOME AS Solicitante,   
    CASE WHEN OHB_ORIGEM = '1' THEN 'CAP'
    WHEN OHB_ORIGEM = '2' THEN 'CAR'
    WHEN OHB_ORIGEM = '3' THEN 'Tarifador'
    WHEN OHB_ORIGEM = '4' THEN 'Integração'
    WHEN OHB_ORIGEM = '5' THEN 'Digitado'
    WHEN OHB_ORIGEM = '6' THEN 'Solic Desp'
    WHEN OHB_ORIGEM = '7' THEN 'Extrato'
    WHEN OHB_ORIGEM = '' THEN 'Fechamento' ELSE '' END AS Origem,    
    OHB_NATORI,
    OHB_CCUSTO,
    OHB_CPARTO,
    OHB_NATDES,
    OHB_CCUSTD,
    OHB_CPARTD,
    OHB_CCLID,
    OHB_CLOJD,
    OHB_CCASOD,
    OHB_CTPDPD,
    OHB_CDESPD,
    OHB_COBRAD,
    CASE 
        WHEN OHB_DTDESP = '        ' THEN ''
        ELSE TO_CHAR(TO_DATE(OHB_DTDESP, 'YYYYMMDD'), 'DD/MM/YYYY') 
        END AS Data_Despesa,
    TO_CHAR(TO_DATE(OHB_DTLANC, 'YYYYMMDD'), 'DD/MM/YYYY') AS Data_Lancamento,
    OHB_CMOELC,
    OHB_VALOR,
    UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(OHB_HISTOR,2000,1)) as Descritivo,
    OHB_COTAC,
    OHB_CMOEC,
    OHB_VALORC,
    OHB_CUSINC,
    OHB_CPAGTO,
    OHB_CRECEB,
    OHB_ITDES,
    OHB_VLNAC,
    B.FK7_NUM AS CAP_ID,
    B.FK7_PARCEL AS CAP_PARC,
    C.E1_NUM AS FATURA_ID,
    C.E1_PARCELA AS FATURA_PARC,
    E.ED_DESCRIC AS Nat_Dest,
    F.ED_DESCRIC AS Nat_Ori,
    G.NOMECLI,
    G.NOMECASO,
    G.SITUACAO AS Situação_Despesa,
    G.DESCRICAO AS Descricao_Despesa,
    G.NOMETIPODESP,
    G.COBRAVEL_GERAL AS Cobrar_desp,
    G.NVE_CAREAJ,
    G.STATUS AS Status_desp,
    G.EMISSAO_FAT,
    G.VENC_FAT,
    G.BAIXA AS Baixa_fatura,
    G.FATURA AS FAT_DESP,
    --H.BANCO,
    G.SIGLAMOEDA_DESP,
    D.RD0_NOME AS Nome_Part,
    CASE WHEN OHB_CMOELC = '01' THEN 'R$'
    WHEN OHB_CMOELC = '02' THEN 'U$'
    WHEN OHB_CMOELC = '03' THEN 'Eur'
    ELSE OHB_CMOELC END as Moeda,
    CASE 
            WHEN OHB_NATDES = '03.020.001' AND J.COBRAR_DESP = 'N' THEN 'DESP_NCOBCT'
            WHEN OHB_NATDES = '03.020.001' AND OHB_CCLID = '000002' THEN 'DESP_RGSH'
            WHEN OHB_NATDES = '03.020.001' AND OHB_CCLID = '000005' THEN 'DESP_CLPRP'
            WHEN OHB_NATDES  = '03.020.001' AND OHB_CCASOD = '000002' THEN 'DESP_CAPRP'
            WHEN OHB_NATDES = '03.020.001' AND J.COBRAR_DESP = 'N' AND OHB_COBRAD = '2' THEN 'DESP_NCOB'
            WHEN OHB_NATDES = '03.020.001' AND OHB_COBRAD = '2' AND J.COBRAR_DESP = 'S' THEN 'DESP_NCOB'            
            WHEN OHB_NATDES = '03.020.001' AND G.SITUACAO_DESP = 'W' THEN 'DESP_WO'
            WHEN OHB_NATDES = '03.020.001' AND G.SITUACAO = 'WO' THEN 'DESP_WO'
            ELSE OHB_NATDES END AS Natureza_Correta,
    CASE WHEN WO_COD IS NOT NULL AND Situacao_WO = '1' THEN 'WO' ELSE G.SITUACAO END AS Situação_Despesa_2,
    G.SITUACAO_DESP,
    I.E2_NOMFOR,
    D.RD0_CC,
    CASE WHEN I.E2_BCOPAG= '203' THEN 'Santander Impostos'
    WHEN I.E2_BCOPAG= '033' THEN 'Banco Santander'
    WHEN I.E2_BCOPAG = '341' THEN 'Banco Itaú'
    WHEN I.E2_BCOPAG = '001' THEN 'Banco do Brasil'
    WHEN I.E2_BCOPAG = '104' THEN 'Caixa'
    WHEN I.E2_BCOPAG = '208' THEN 'Banco BTG'
    WHEN I.E2_BCOPAG = '336' THEN 'Banco C6 '
    WHEN I.E2_BCOPAG = '999' THEN 'Novo Banco Dólar'
    WHEN I.E2_BCOPAG = 'CXC' THEN 'Caixinha Cofre'
    WHEN I.E2_BCOPAG = 'CXR' THEN 'Caixinha Recepcao'
    WHEN I.E2_BCOPAG = 'DMA' THEN 'Damasceno'
    WHEN I.E2_BCOPAG = 'EUR' THEN 'Novo Banco Euro'
    WHEN I.E2_BCOPAG = 'NPL' THEN 'Mutuo_NPL'
    WHEN I.E2_BCOPAG = 'TDC' THEN 'Reembolso_Colaboradores' ELSE ''
    END AS Banco_CAP,
    CASE WHEN J.COBRAR_DESP = 'S' AND H.COBRAR_DESP = 'N' THEN 'N' ELSE J.COBRAR_DESP END AS Cobrar_Contrato,
    J.ID AS Cod_Contrato,
    J.NOME AS Nome_Contrato,
    H.COBRAR_DESP Tipo_Desp_N_Cobrar,
    P.NVE_CAREAJ AS Área_Total,
    Situacao_WO,
    Emissao_WO,
    Motivo_WO,
    OBS_WO,
    Data_Cancel_WO,
    COD_WO_DESPESA
FROM
    SISJURI.OHB010
LEFT JOIN   
    SISJURI.FK7010 B ON OHB_CPAGTO = B.FK7_CHAVE -- TAbela Intermediaria
LEFT JOIN
   SISJURI.SE2010 I ON FK7_NUM = E2_NUM AND FK7_PARCEL = E2_PARCELA AND E2_NOMFOR <> 'INPS' AND I.D_E_L_E_T_ = ' ' --CAP
LEFT JOIN
    SISJURI.SE1010 C ON OHB_CRECEB = (C.E1_FILIAL||C.E1_PREFIXO||C.E1_NUM||C.E1_PARCELA||C.E1_TIPO) AND C.E1_TIPO = 'FT' -- CAR
LEFT JOIN
    SISJURI.RD0010 D ON OHB_CPARTD = D.RD0_CODIGO -- Participante
LEFT JOIN
    SISJURI.SED010 E ON (OHB_NATDES = E.ED_CODIGO)
LEFT JOIN
    SISJURI.SED010 F ON (OHB_NATORI = F.ED_CODIGO)
LEFT JOIN
    VW_DESPESAS_CLIENTES_V1 G ON OHB_CDESPD = G.CODIGO
lEFT JOIN
    VW_CONTRATO_DESP_N_COBRAR_V1 H ON OHB_CCLID = H.CLIENTE AND OHB_CCASOD = H.COD_CASO AND OHB_CTPDPD = H.DESPESAS_N_COBRAVEIS
LEFT JOIN
    VW_CONTRATOS_DESPESAS_V2 J ON OHB_CCLID = J.CLIENTE AND OHB_CCASOD = J.COD_CASO  -- Contrato/Despesa
LEFT JOIN
    SISJURI.NVE010 P ON OHB_CCLID = NVE_CCLIEN AND OHB_CCASOD = NVE_NUMCAS
--LEFT JOIN
  --  SISJURI.NVZ010 Y ON OHB_CDESPD = Y.NVZ_CDESP
--LEFT JOIN
    --SISJURI.NUF010 Z ON Y.NVZ_CWO = Z.NUF_COD
WHERE 
    SISJURI.OHB010.D_E_L_E_T_ <> '*'
AND
    E.D_E_L_E_T_ <> '*' AND E.ED_FILIAL <> '0101'
AND
    F.D_E_L_E_T_ <> '*' AND F.ED_FILIAL <> '0101';