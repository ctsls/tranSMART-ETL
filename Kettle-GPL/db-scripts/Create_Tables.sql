--define table LT_METABOLOMIC_ANNOTATION
create table "TM_LZ"."LT_METABOLOMIC_ANNOTATION"
(
GPL_ID varchar2(20),
BIOCHEMICAL_NAME varchar2(200),
HMDB_ID varchar2(20),
SUPER_PATHWAY varchar2(200),
SUB_PATHWAY varchar2(200)
)

create or replace synonym tm_cz.LT_METABOLOMIC_ANNOTATION for "TM_LZ"."LT_METABOLOMIC_ANNOTATION" ;
grant select, insert, update, delete on "TM_LZ"."LT_METABOLOMIC_ANNOTATION" to tm_cz;
-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------

-- define table DEAPP.DE_METABOLITE_ANNOTATION
CREATE TABLE DEAPP.DE_METABOLITE_ANNOTATION
(
  ID NUMBER(*,0) not null,
  GPL_ID VARCHAR2(50 BYTE) not null,
  BIOCHEMICAL_NAME VARCHAR2(200 BYTE) not null,
  BIOMARKER_ID NVARCHAR2(200),
  HMDB_ID VARCHAR2(50 BYTE)
) 
NOLOGGING 
TABLESPACE "DEAPP";

comment on column DEAPP.DE_METABOLITE_ANNOTATION.ID is
'Unique identifier of this record';
comment on column DEAPP.DE_METABOLITE_ANNOTATION.GPL_ID is
'GPL ID; reference to the de_gpl_info table which has one record for each platform';
comment on column DEAPP.DE_METABOLITE_ANNOTATION.BIOCHEMICAL_NAME is
'HMDB_ID for the HMDB record representing this metabolite. This is represented in the data as well, and may be null if not present';
comment on column DEAPP.DE_METABOLITE_ANNOTATION.BIOMARKER_ID is
'Biomarker ID of this metabolite (HMDBID) in the dictionary. This ID points to primary_external_id in a record in biomart_bio_marker. This value may be null, if no HMDB ID is present.';
comment on column DEAPP.DE_METABOLITE_ANNOTATION.HMDB_ID is
'HMDB_ID for the HMDB record representing this metabolite. This is represented in the data as well, and may be null if not present';

create or replace synonym tm_cz.de_metabolite_annotation for "DEAPP"."DE_METABOLITE_ANNOTATION";
grant select, insert, update, delete on "DEAPP"."DE_METABOLITE_ANNOTATION" to tm_cz;

--------------------------------------------------------------------

CREATE SEQUENCE  "DEAPP"."METABOLOMICS_ANNOT_ID"  MINVALUE 1 MAXVALUE 999999999 INCREMENT BY 1 START WITH 1 NOCACHE  NOORDER  NOCYCLE ;

create or replace synonym tm_cz.metabolomics_annot_id for "DEAPP"."METABOLOMICS_ANNOT_ID";
grant select, alter on "DEAPP"."METABOLOMICS_ANNOT_ID" to tm_cz;

-------------------------------------------------------
-------------------------------------------------------

-- define table DEAPP.de_metabolite_super_pathways 
CREATE TABLE DEAPP.DE_METABOLITE_SUPER_PATHWAYS 
(
  ID NUMBER(*,0) not null,
  GPL_ID VARCHAR2(50 BYTE) not null,
  SUPER_PATHWAY_NAME VARCHAR2(200 BYTE)
) 
NOLOGGING 
TABLESPACE "DEAPP";

comment on column DEAPP.de_metabolite_super_pathways.ID is
'Unique identifier of this record';
comment on column DEAPP.de_metabolite_super_pathways.GPL_ID is
'GPL ID; reference to the de_gpl_info table which has one record for each platform';
comment on column DEAPP.de_metabolite_super_pathways.SUPER_PATHWAY_NAME is
'Name of the superpathway, as represented in the data';

---------------------------------------------

create or replace synonym tm_cz.de_metabolite_super_pathways for "DEAPP"."DE_METABOLITE_SUPER_PATHWAYS";
grant select, insert, update, delete on "DEAPP"."DE_METABOLITE_SUPER_PATHWAYS" to tm_cz;

CREATE SEQUENCE  "DEAPP"."METABOLITE_SUP_PTH_ID"  MINVALUE 1 MAXVALUE 999999999 INCREMENT BY 1 START WITH 1 NOCACHE  NOORDER  NOCYCLE;

create or replace synonym tm_cz.metabolite_sup_pth_id for "DEAPP"."METABOLITE_SUP_PTH_ID";
grant select, alter on "DEAPP"."METABOLITE_SUP_PTH_ID" to tm_cz;

-------------------------------------------------------
-------------------------------------------------------

-- define table DEAPP.DE_METABOLITE_SUB_PATHWAYS
CREATE TABLE DEAPP.DE_METABOLITE_SUB_PATHWAYS 
(
  ID NUMBER(*,0) not null,
  GPL_ID VARCHAR2(50 BYTE) not null,
  SUB_PATHWAY_NAME VARCHAR2(200 BYTE) not null,
  SUPER_PATHWAY_ID NUMBER(*,0)
) 
NOLOGGING 
TABLESPACE "DEAPP";

comment on column DEAPP.de_metabolite_sub_pathways.ID is
'Unique identifier of this record';
comment on column DEAPP.de_metabolite_sub_pathways.GPL_ID is
'GPL ID; reference to the de_gpl_info table which has one record for each platform';
comment on column DEAPP.de_metabolite_sub_pathways.SUPER_PATHWAY_ID is
'ID of the superpathway that this subpathway belongs to (a record in de_metabolite_super_pathways table). If there is no super_pathway, this value may be null';
comment on column DEAPP.de_metabolite_sub_pathways.SUB_PATHWAY_NAME is
'Name of the subpathway, as represented in the data';


create or replace synonym tm_cz.de_metabolite_sub_pathways for "DEAPP"."DE_METABOLITE_SUB_PATHWAYS";
grant select, insert, update, delete on "DEAPP"."DE_METABOLITE_SUB_PATHWAYS" to tm_cz;

CREATE SEQUENCE  "DEAPP"."METABOLITE_SUB_PTH_ID"  MINVALUE 1 MAXVALUE 999999999 INCREMENT BY 1 START WITH 1 NOCACHE  NOORDER  NOCYCLE;

create or replace synonym tm_cz.metabolite_sub_pth_id for "DEAPP"."METABOLITE_SUB_PTH_ID";
grant select, alter on "DEAPP"."METABOLITE_SUB_PTH_ID" to tm_cz;

------------------------------------------------------
------------------------------------------------------

-- define table DEAPP.DE_METABOLITE_SUB_PWAY_METAB
CREATE TABLE DEAPP.DE_METABOLITE_SUB_PWAY_METAB
(
  METABOLITE_ID NUMBER(*,0) not null,
  SUB_PATHWAY_ID NUMBER(*,0) not null
) 
NOLOGGING 
TABLESPACE "DEAPP";

comment on column DEAPP.de_metabolite_sub_pway_metab.METABOLITE_ID is
'Reference for the metabolite, referencing a record in the de_metabolite_annotation';
comment on column DEAPP.de_metabolite_sub_pway_metab.SUB_PATHWAY_ID is
'Reference to the sub_pathway, referencing a record in the de_metabolite_sub_pathway table.';

create or replace synonym tm_cz.de_metabolite_sub_pway_metab for "DEAPP"."DE_METABOLITE_SUB_PWAY_METAB";
grant select, insert, update, delete on "DEAPP"."DE_METABOLITE_SUB_PWAY_METAB" to tm_cz;

------------------------------------------------------
------------------------------------------------------
-- add primary key to DEAPP.DE_METABOLITE_ANNOTATION_PK
ALTER TABLE DEAPP.DE_METABOLITE_ANNOTATION
ADD CONSTRAINT DE_METABOLITE_ANNOTATION_PK PRIMARY KEY (ID);

-- add primary key to DEAPP.de_metabolite_sub_pathway
ALTER TABLE DEAPP.de_metabolite_sub_pathway
ADD CONSTRAINT de_metabolite_sub_pathway_PK PRIMARY KEY (ID);

-- add primary key to DEAPP.de_metabolite_super_pathway
ALTER TABLE DEAPP.de_metabolite_super_pathway
ADD CONSTRAINT de_metabolite_super_pathway_PK PRIMARY KEY (ID);

-- add foreign keys for DEAPP.de_metabolite_sub_pathway
ALTER TABLE DEAPP.de_metabolite_sub_pathway 
ADD FOREIGN KEY (SUPER_PATHWAY_ID) 
REFERENCES DEAPP.de_metabolite_super_pathway(ID);

-- add foreign keys for DEAPP.DE_METABOLITE_ANNOTATION
ALTER TABLE DEAPP.DE_METABOLITE_ANNOTATION 
ADD FOREIGN KEY (BIOMARKER_ID) 
REFERENCES biomart.bio_marker(PRIMARY_EXTERNAL_ID);

-- add foreign keys for DEAPP.de_metabolite_sub_pway_metab
ALTER TABLE DEAPP.de_metabolite_sub_pway_metab 
ADD FOREIGN KEY (METABOLITE_ID) 
REFERENCES DEAPP.DE_METABOLITE_ANNOTATION(ID);
ALTER TABLE DEAPP.de_metabolite_sub_pway_metab 
ADD FOREIGN KEY (SUB_PATHWAY_ID) 
REFERENCES DEAPP.de_metabolite_sub_pathway(ID);