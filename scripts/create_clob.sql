CREATE TABLE sample_json_table (
    id RAW (16) NOT NULL,
    date_loaded TIMESTAMP(6) WITH TIME ZONE,
    po_document CLOB CONSTRAINT ensure_json CHECK (po_document IS JSON)
);
