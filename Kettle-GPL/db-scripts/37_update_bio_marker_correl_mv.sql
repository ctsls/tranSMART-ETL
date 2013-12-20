--DROP TABLE "BIOMART"."BIO_MARKER_CORREL_MV";
DROP MATERIALIZED VIEW "BIOMART"."BIO_MARKER_CORREL_MV";
DROP VIEW "BIOMART"."BIO_MARKER_CORREL_MV_VIEW";

CREATE MATERIALIZED VIEW "BIOMART"."BIO_MARKER_CORREL_MV" ("BIO_MARKER_ID", "ASSO_BIO_MARKER_ID", "CORREL_TYPE", "MV_ID")
ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 COMPRESS BASIC NOLOGGING
STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
TABLESPACE "BIOMART" 
CACHE PARALLEL 2 
BUILD IMMEDIATE
USING INDEX 
REFRESH FORCE ON DEMAND
USING DEFAULT LOCAL ROLLBACK SEGMENT
USING ENFORCED CONSTRAINTS DISABLE QUERY REWRITE
AS SELECT DISTINCT
                b.bio_marker_id,
                b.bio_marker_id AS asso_bio_marker_id,
                'GENE' AS correl_type,
                1 AS mv_id
            FROM
                    biomart.bio_marker b
            WHERE
                    b.bio_marker_type = 'GENE'
            UNION
            SELECT DISTINCT
                b.bio_marker_id,
                b.bio_marker_id AS asso_bio_marker_id,
                'PROTEIN' AS correl_type,
                4 AS mv_id
            FROM
                biomart.bio_marker b
            WHERE
               b.bio_marker_type = 'PROTEIN'
            UNION
            SELECT DISTINCT
                b.bio_marker_id,
                b.bio_marker_id AS asso_bio_marker_id,
                'MIRNA' AS correl_type,
                7 AS mv_id
            FROM
                biomart.bio_marker b
            WHERE
               b.bio_marker_type = 'MIRNA'
            UNION
            SELECT DISTINCT
                c.bio_data_id AS bio_marker_id,
                c.asso_bio_data_id AS asso_bio_marker_id,
                'PATHWAY_GENE' AS correl_type,
                2 AS mv_id
            FROM
                biomart.bio_marker b,
                biomart.bio_data_correlation c,
                biomart.bio_data_correl_descr d
            WHERE
                b.bio_marker_id = c.bio_data_id
                AND c.bio_data_correl_descr_id = d.bio_data_correl_descr_id
                AND b.primary_source_code <> 'ARIADNE'
                AND d.correlation = 'PATHWAY GENE'
            UNION
            SELECT DISTINCT
                c.bio_data_id AS bio_marker_id,
                c.asso_bio_data_id AS asso_bio_marker_id,
                'HOMOLOGENE_GENE' AS correl_type,
                3 AS mv_id
            FROM
                biomart.bio_marker b,
                biomart.bio_data_correlation c,
                biomart.bio_data_correl_descr d
            WHERE
                b.bio_marker_id = c.bio_data_id
                AND c.bio_data_correl_descr_id = d.bio_data_correl_descr_id
                AND d.correlation = 'HOMOLOGENE GENE'
            UNION
            SELECT DISTINCT
                c.bio_data_id AS bio_marker_id,
                c.asso_bio_data_id AS asso_bio_marker_id,
                'PROTEIN TO GENE' AS correl_type,
                5 AS mv_id
            FROM
                biomart.bio_marker b,
                biomart.bio_data_correlation c,
                biomart.bio_data_correl_descr d
            WHERE
                b.bio_marker_id = c.bio_data_id
                AND c.bio_data_correl_descr_id = d.bio_data_correl_descr_id
                AND d.correlation = 'PROTEIN TO GENE'
            UNION
            SELECT DISTINCT
                c.bio_data_id AS bio_marker_id,
                c.asso_bio_data_id AS asso_bio_marker_id,
                'GENE TO PROTEIN' AS correl_type,
                6 AS mv_id
            FROM
                biomart.bio_marker b,
                biomart.bio_data_correlation c,
                biomart.bio_data_correl_descr d
            WHERE
                b.bio_marker_id = c.bio_data_id
                AND c.bio_data_correl_descr_id = d.bio_data_correl_descr_id
                AND d.correlation = 'GENE TO PROTEIN';

COMMENT ON MATERIALIZED VIEW "BIOMART"."BIO_MARKER_CORREL_MV"  IS 'snapshot table for snapshot BIOMART.BIO_MARKER_CORREL_MV';