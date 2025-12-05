--
-- PostgreSQL database dump
--

\restrict jNnGfWa5uiyRaeAvHefYej865MhF1IFhuuxhPBfjffol6TXCvBOKPP2HzO7oxEW

-- Dumped from database version 18.1 (Debian 18.1-1.pgdg13+2)
-- Dumped by pg_dump version 18.1 (Ubuntu 18.1-1.pgdg24.04+2)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: edge_tags; Type: TABLE; Schema: public; Owner: amass
--

CREATE TABLE public.edge_tags (
    tag_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    ttype character varying(255),
    content jsonb,
    edge_id integer
);


ALTER TABLE public.edge_tags OWNER TO amass;

--
-- Name: edge_tags_tag_id_seq; Type: SEQUENCE; Schema: public; Owner: amass
--

ALTER TABLE public.edge_tags ALTER COLUMN tag_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.edge_tags_tag_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: edges; Type: TABLE; Schema: public; Owner: amass
--

CREATE TABLE public.edges (
    edge_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    etype character varying(255),
    content jsonb,
    from_entity_id integer,
    to_entity_id integer
);


ALTER TABLE public.edges OWNER TO amass;

--
-- Name: edges_edge_id_seq; Type: SEQUENCE; Schema: public; Owner: amass
--

ALTER TABLE public.edges ALTER COLUMN edge_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.edges_edge_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: entities; Type: TABLE; Schema: public; Owner: amass
--

CREATE TABLE public.entities (
    entity_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    etype character varying(255),
    content jsonb
);


ALTER TABLE public.entities OWNER TO amass;

--
-- Name: entities_entity_id_seq; Type: SEQUENCE; Schema: public; Owner: amass
--

ALTER TABLE public.entities ALTER COLUMN entity_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.entities_entity_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: entity_tags; Type: TABLE; Schema: public; Owner: amass
--

CREATE TABLE public.entity_tags (
    tag_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    ttype character varying(255),
    content jsonb,
    entity_id integer
);


ALTER TABLE public.entity_tags OWNER TO amass;

--
-- Name: entity_tags_tag_id_seq; Type: SEQUENCE; Schema: public; Owner: amass
--

ALTER TABLE public.entity_tags ALTER COLUMN tag_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.entity_tags_tag_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: gorp_migrations; Type: TABLE; Schema: public; Owner: amass
--

CREATE TABLE public.gorp_migrations (
    id text NOT NULL,
    applied_at timestamp with time zone
);


ALTER TABLE public.gorp_migrations OWNER TO amass;

--
-- Name: edge_tags edge_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: amass
--

ALTER TABLE ONLY public.edge_tags
    ADD CONSTRAINT edge_tags_pkey PRIMARY KEY (tag_id);


--
-- Name: edges edges_pkey; Type: CONSTRAINT; Schema: public; Owner: amass
--

ALTER TABLE ONLY public.edges
    ADD CONSTRAINT edges_pkey PRIMARY KEY (edge_id);


--
-- Name: entities entities_pkey; Type: CONSTRAINT; Schema: public; Owner: amass
--

ALTER TABLE ONLY public.entities
    ADD CONSTRAINT entities_pkey PRIMARY KEY (entity_id);


--
-- Name: entity_tags entity_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: amass
--

ALTER TABLE ONLY public.entity_tags
    ADD CONSTRAINT entity_tags_pkey PRIMARY KEY (tag_id);


--
-- Name: gorp_migrations gorp_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: amass
--

ALTER TABLE ONLY public.gorp_migrations
    ADD CONSTRAINT gorp_migrations_pkey PRIMARY KEY (id);


--
-- Name: idx_account_content_unique_id; Type: INDEX; Schema: public; Owner: amass
--

CREATE UNIQUE INDEX idx_account_content_unique_id ON public.entities USING btree (((content ->> 'unique_id'::text))) WHERE ((etype)::text = 'Account'::text);


--
-- Name: idx_autnum_content_handle; Type: INDEX; Schema: public; Owner: amass
--

CREATE UNIQUE INDEX idx_autnum_content_handle ON public.entities USING btree (((content ->> 'handle'::text))) WHERE ((etype)::text = 'AutnumRecord'::text);


--
-- Name: idx_autnum_content_number; Type: INDEX; Schema: public; Owner: amass
--

CREATE INDEX idx_autnum_content_number ON public.entities USING btree (((content ->> 'number'::text))) WHERE ((etype)::text = 'AutnumRecord'::text);


--
-- Name: idx_autsys_content_number; Type: INDEX; Schema: public; Owner: amass
--

CREATE UNIQUE INDEX idx_autsys_content_number ON public.entities USING btree (((content ->> 'number'::text))) WHERE ((etype)::text = 'AutonomousSystem'::text);


--
-- Name: idx_contact_record_content_discovered_at; Type: INDEX; Schema: public; Owner: amass
--

CREATE UNIQUE INDEX idx_contact_record_content_discovered_at ON public.entities USING btree (((content ->> 'discovered_at'::text))) WHERE ((etype)::text = 'ContactRecord'::text);


--
-- Name: idx_domainrec_content_domain; Type: INDEX; Schema: public; Owner: amass
--

CREATE UNIQUE INDEX idx_domainrec_content_domain ON public.entities USING btree (((content ->> 'domain'::text))) WHERE ((etype)::text = 'DomainRecord'::text);


--
-- Name: idx_edge_from_entity_id; Type: INDEX; Schema: public; Owner: amass
--

CREATE INDEX idx_edge_from_entity_id ON public.edges USING btree (from_entity_id);


--
-- Name: idx_edge_to_entity_id; Type: INDEX; Schema: public; Owner: amass
--

CREATE INDEX idx_edge_to_entity_id ON public.edges USING btree (to_entity_id);


--
-- Name: idx_edge_updated_at; Type: INDEX; Schema: public; Owner: amass
--

CREATE INDEX idx_edge_updated_at ON public.edges USING btree (updated_at);


--
-- Name: idx_edgetag_edge_id; Type: INDEX; Schema: public; Owner: amass
--

CREATE INDEX idx_edgetag_edge_id ON public.edge_tags USING btree (edge_id);


--
-- Name: idx_edgetag_updated_at; Type: INDEX; Schema: public; Owner: amass
--

CREATE INDEX idx_edgetag_updated_at ON public.edge_tags USING btree (updated_at);


--
-- Name: idx_entities_etype; Type: INDEX; Schema: public; Owner: amass
--

CREATE INDEX idx_entities_etype ON public.entities USING btree (etype);


--
-- Name: idx_entities_updated_at; Type: INDEX; Schema: public; Owner: amass
--

CREATE INDEX idx_entities_updated_at ON public.entities USING btree (updated_at);


--
-- Name: idx_enttag_entity_id; Type: INDEX; Schema: public; Owner: amass
--

CREATE INDEX idx_enttag_entity_id ON public.entity_tags USING btree (entity_id);


--
-- Name: idx_enttag_updated_at; Type: INDEX; Schema: public; Owner: amass
--

CREATE INDEX idx_enttag_updated_at ON public.entity_tags USING btree (updated_at);


--
-- Name: idx_file_content_url; Type: INDEX; Schema: public; Owner: amass
--

CREATE UNIQUE INDEX idx_file_content_url ON public.entities USING btree (((content ->> 'url'::text))) WHERE ((etype)::text = 'File'::text);


--
-- Name: idx_fqdn_content_name; Type: INDEX; Schema: public; Owner: amass
--

CREATE UNIQUE INDEX idx_fqdn_content_name ON public.entities USING btree (((content ->> 'name'::text))) WHERE ((etype)::text = 'FQDN'::text);


--
-- Name: idx_funds_transfer_content_unique_id; Type: INDEX; Schema: public; Owner: amass
--

CREATE UNIQUE INDEX idx_funds_transfer_content_unique_id ON public.entities USING btree (((content ->> 'unique_id'::text))) WHERE ((etype)::text = 'FundsTransfer'::text);


--
-- Name: idx_identifier_content_unique_id; Type: INDEX; Schema: public; Owner: amass
--

CREATE UNIQUE INDEX idx_identifier_content_unique_id ON public.entities USING btree (((content ->> 'unique_id'::text))) WHERE ((etype)::text = 'Identifier'::text);


--
-- Name: idx_ipaddr_content_address; Type: INDEX; Schema: public; Owner: amass
--

CREATE UNIQUE INDEX idx_ipaddr_content_address ON public.entities USING btree (((content ->> 'address'::text))) WHERE ((etype)::text = 'IPAddress'::text);


--
-- Name: idx_ipnetrec_content_cidr; Type: INDEX; Schema: public; Owner: amass
--

CREATE INDEX idx_ipnetrec_content_cidr ON public.entities USING btree (((content ->> 'cidr'::text))) WHERE ((etype)::text = 'IPNetRecord'::text);


--
-- Name: idx_ipnetrec_content_handle; Type: INDEX; Schema: public; Owner: amass
--

CREATE UNIQUE INDEX idx_ipnetrec_content_handle ON public.entities USING btree (((content ->> 'handle'::text))) WHERE ((etype)::text = 'IPNetRecord'::text);


--
-- Name: idx_location_content_address; Type: INDEX; Schema: public; Owner: amass
--

CREATE UNIQUE INDEX idx_location_content_address ON public.entities USING btree (((content ->> 'address'::text))) WHERE ((etype)::text = 'Location'::text);


--
-- Name: idx_netblock_content_cidr; Type: INDEX; Schema: public; Owner: amass
--

CREATE UNIQUE INDEX idx_netblock_content_cidr ON public.entities USING btree (((content ->> 'cidr'::text))) WHERE ((etype)::text = 'Netblock'::text);


--
-- Name: idx_org_content_name; Type: INDEX; Schema: public; Owner: amass
--

CREATE INDEX idx_org_content_name ON public.entities USING btree (((content ->> 'name'::text))) WHERE ((etype)::text = 'Organization'::text);


--
-- Name: idx_org_content_unique_id; Type: INDEX; Schema: public; Owner: amass
--

CREATE UNIQUE INDEX idx_org_content_unique_id ON public.entities USING btree (((content ->> 'unique_id'::text))) WHERE ((etype)::text = 'Organization'::text);


--
-- Name: idx_person_content_full_name; Type: INDEX; Schema: public; Owner: amass
--

CREATE INDEX idx_person_content_full_name ON public.entities USING btree (((content ->> 'full_name'::text))) WHERE ((etype)::text = 'Person'::text);


--
-- Name: idx_person_content_unique_id; Type: INDEX; Schema: public; Owner: amass
--

CREATE UNIQUE INDEX idx_person_content_unique_id ON public.entities USING btree (((content ->> 'unique_id'::text))) WHERE ((etype)::text = 'Person'::text);


--
-- Name: idx_phone_content_e164; Type: INDEX; Schema: public; Owner: amass
--

CREATE UNIQUE INDEX idx_phone_content_e164 ON public.entities USING btree (((content ->> 'e164'::text))) WHERE ((etype)::text = 'Phone'::text);


--
-- Name: idx_phone_content_raw; Type: INDEX; Schema: public; Owner: amass
--

CREATE UNIQUE INDEX idx_phone_content_raw ON public.entities USING btree (((content ->> 'raw'::text))) WHERE ((etype)::text = 'Phone'::text);


--
-- Name: idx_product_content_product_name; Type: INDEX; Schema: public; Owner: amass
--

CREATE INDEX idx_product_content_product_name ON public.entities USING btree (((content ->> 'product_name'::text))) WHERE ((etype)::text = 'Product'::text);


--
-- Name: idx_product_content_unique_id; Type: INDEX; Schema: public; Owner: amass
--

CREATE UNIQUE INDEX idx_product_content_unique_id ON public.entities USING btree (((content ->> 'unique_id'::text))) WHERE ((etype)::text = 'Product'::text);


--
-- Name: idx_product_release_content_name; Type: INDEX; Schema: public; Owner: amass
--

CREATE UNIQUE INDEX idx_product_release_content_name ON public.entities USING btree (((content ->> 'name'::text))) WHERE ((etype)::text = 'ProductRelease'::text);


--
-- Name: idx_service_content_unique_id; Type: INDEX; Schema: public; Owner: amass
--

CREATE UNIQUE INDEX idx_service_content_unique_id ON public.entities USING btree (((content ->> 'unique_id'::text))) WHERE ((etype)::text = 'Service'::text);


--
-- Name: idx_tls_content_serial_number; Type: INDEX; Schema: public; Owner: amass
--

CREATE UNIQUE INDEX idx_tls_content_serial_number ON public.entities USING btree (((content ->> 'serial_number'::text))) WHERE ((etype)::text = 'TLSCertificate'::text);


--
-- Name: idx_url_content_url; Type: INDEX; Schema: public; Owner: amass
--

CREATE UNIQUE INDEX idx_url_content_url ON public.entities USING btree (((content ->> 'url'::text))) WHERE ((etype)::text = 'URL'::text);


--
-- Name: edge_tags fk_edge_tags_edges; Type: FK CONSTRAINT; Schema: public; Owner: amass
--

ALTER TABLE ONLY public.edge_tags
    ADD CONSTRAINT fk_edge_tags_edges FOREIGN KEY (edge_id) REFERENCES public.edges(edge_id) ON DELETE CASCADE;


--
-- Name: edges fk_edges_entities_from; Type: FK CONSTRAINT; Schema: public; Owner: amass
--

ALTER TABLE ONLY public.edges
    ADD CONSTRAINT fk_edges_entities_from FOREIGN KEY (from_entity_id) REFERENCES public.entities(entity_id) ON DELETE CASCADE;


--
-- Name: edges fk_edges_entities_to; Type: FK CONSTRAINT; Schema: public; Owner: amass
--

ALTER TABLE ONLY public.edges
    ADD CONSTRAINT fk_edges_entities_to FOREIGN KEY (to_entity_id) REFERENCES public.entities(entity_id) ON DELETE CASCADE;


--
-- Name: entity_tags fk_entity_tags_entities; Type: FK CONSTRAINT; Schema: public; Owner: amass
--

ALTER TABLE ONLY public.entity_tags
    ADD CONSTRAINT fk_entity_tags_entities FOREIGN KEY (entity_id) REFERENCES public.entities(entity_id) ON DELETE CASCADE;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT ALL ON SCHEMA public TO amass;


--
-- PostgreSQL database dump complete
--

\unrestrict jNnGfWa5uiyRaeAvHefYej865MhF1IFhuuxhPBfjffol6TXCvBOKPP2HzO7oxEW

