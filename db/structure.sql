SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
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
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: carts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.carts (
    id bigint NOT NULL,
    user_id bigint,
    product_id bigint,
    quantity integer DEFAULT 1,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: carts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.carts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: carts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.carts_id_seq OWNED BY public.carts.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categories (
    id bigint NOT NULL,
    name character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: categorizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categorizations (
    id bigint NOT NULL,
    product_id bigint NOT NULL,
    category_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: categorizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.categorizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categorizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.categorizations_id_seq OWNED BY public.categorizations.id;


--
-- Name: messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.messages (
    id bigint NOT NULL,
    sender_id bigint NOT NULL,
    receiver_id bigint NOT NULL,
    subject text NOT NULL,
    message text NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    sender_name character varying DEFAULT ''::character varying NOT NULL,
    "hasRead" boolean DEFAULT false NOT NULL,
    receiver_name character varying NOT NULL,
    "hasSenderDeleted" boolean DEFAULT false NOT NULL,
    "hasReceiverDeleted" boolean DEFAULT false NOT NULL
);


--
-- Name: messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.messages_id_seq OWNED BY public.messages.id;


--
-- Name: price_alerts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.price_alerts (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    product_id bigint NOT NULL,
    threshold numeric(10,2),
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: price_alerts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.price_alerts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: price_alerts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.price_alerts_id_seq OWNED BY public.price_alerts.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.products (
    id bigint NOT NULL,
    name character varying DEFAULT ''::character varying NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    price_cents integer DEFAULT 0 NOT NULL,
    price_currency character varying DEFAULT 'USD'::character varying NOT NULL,
    quantity integer DEFAULT 1 NOT NULL,
    condition integer DEFAULT 400 NOT NULL,
    private boolean DEFAULT false NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    seller_id bigint NOT NULL,
    cart_id bigint,
    photos json,
    searchable tsvector GENERATED ALWAYS AS ((setweight(to_tsvector('english'::regconfig, (name)::text), 'A'::"char") || setweight(to_tsvector('english'::regconfig, description), 'B'::"char"))) STORED,
    views integer
);


--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;


--
-- Name: profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.profiles (
    id bigint NOT NULL,
    bio text,
    location character varying,
    first_name character varying,
    last_name character varying,
    birth_date date,
    twitter character varying,
    facebook character varying,
    instagram character varying,
    website character varying,
    occupation character varying,
    seller_rating integer,
    public_profile boolean DEFAULT true NOT NULL,
    user_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    avatar character varying
);


--
-- Name: profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.profiles_id_seq OWNED BY public.profiles.id;


--
-- Name: reviews; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reviews (
    id bigint NOT NULL,
    reviewer_id bigint NOT NULL,
    seller_id bigint NOT NULL,
    has_purchased_from boolean DEFAULT false NOT NULL,
    interaction_rating integer NOT NULL,
    description text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.reviews_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.reviews_id_seq OWNED BY public.reviews.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: storefronts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.storefronts (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    custom_code text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    name character varying NOT NULL,
    short_description text DEFAULT ''::text NOT NULL,
    searchable tsvector GENERATED ALWAYS AS ((setweight(to_tsvector('english'::regconfig, (name)::text), 'A'::"char") || setweight(to_tsvector('english'::regconfig, short_description), 'B'::"char"))) STORED
);


--
-- Name: storefronts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.storefronts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: storefronts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.storefronts_id_seq OWNED BY public.storefronts.id;


--
-- Name: transactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.transactions (
    id bigint NOT NULL,
    buyer_id bigint,
    "{:null=>false, :foreign_key=>{:to_table=>:users}}_id" bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.transactions_id_seq OWNED BY public.transactions.id;


--
-- Name: transactions_products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.transactions_products (
    id bigint NOT NULL,
    transaction_id bigint NOT NULL,
    product_id bigint NOT NULL,
    quantity_sold integer DEFAULT 1,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: transactions_products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.transactions_products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transactions_products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.transactions_products_id_seq OWNED BY public.transactions_products.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    first_name character varying,
    last_name character varying,
    email character varying,
    password_digest character varying,
    password_digest_confirmation character varying,
    is_seller boolean DEFAULT false NOT NULL,
    is_buyer boolean DEFAULT false NOT NULL,
    is_admin boolean DEFAULT false NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    cart_id bigint,
    uid character varying,
    provider character varying,
    message_id bigint
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: viewed_products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.viewed_products (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    product_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: viewed_products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.viewed_products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: viewed_products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.viewed_products_id_seq OWNED BY public.viewed_products.id;


--
-- Name: carts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.carts ALTER COLUMN id SET DEFAULT nextval('public.carts_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: categorizations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categorizations ALTER COLUMN id SET DEFAULT nextval('public.categorizations_id_seq'::regclass);


--
-- Name: messages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages ALTER COLUMN id SET DEFAULT nextval('public.messages_id_seq'::regclass);


--
-- Name: price_alerts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.price_alerts ALTER COLUMN id SET DEFAULT nextval('public.price_alerts_id_seq'::regclass);


--
-- Name: products id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);


--
-- Name: profiles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profiles ALTER COLUMN id SET DEFAULT nextval('public.profiles_id_seq'::regclass);


--
-- Name: reviews id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reviews ALTER COLUMN id SET DEFAULT nextval('public.reviews_id_seq'::regclass);


--
-- Name: storefronts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storefronts ALTER COLUMN id SET DEFAULT nextval('public.storefronts_id_seq'::regclass);


--
-- Name: transactions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions ALTER COLUMN id SET DEFAULT nextval('public.transactions_id_seq'::regclass);


--
-- Name: transactions_products id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions_products ALTER COLUMN id SET DEFAULT nextval('public.transactions_products_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: viewed_products id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.viewed_products ALTER COLUMN id SET DEFAULT nextval('public.viewed_products_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: carts carts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.carts
    ADD CONSTRAINT carts_pkey PRIMARY KEY (id);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: categorizations categorizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categorizations
    ADD CONSTRAINT categorizations_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: price_alerts price_alerts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.price_alerts
    ADD CONSTRAINT price_alerts_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- Name: reviews reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: storefronts storefronts_name_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storefronts
    ADD CONSTRAINT storefronts_name_unique UNIQUE (name);


--
-- Name: storefronts storefronts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storefronts
    ADD CONSTRAINT storefronts_pkey PRIMARY KEY (id);


--
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


--
-- Name: transactions_products transactions_products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions_products
    ADD CONSTRAINT transactions_products_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: viewed_products viewed_products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.viewed_products
    ADD CONSTRAINT viewed_products_pkey PRIMARY KEY (id);


--
-- Name: idx_on_{:null=>false, :foreign_key=>{:to_table=>:us_0d2f35bed4; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "idx_on_{:null=>false, :foreign_key=>{:to_table=>:us_0d2f35bed4" ON public.transactions USING btree ("{:null=>false, :foreign_key=>{:to_table=>:users}}_id");


--
-- Name: index_carts_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_carts_on_product_id ON public.carts USING btree (product_id);


--
-- Name: index_carts_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_carts_on_user_id ON public.carts USING btree (user_id);


--
-- Name: index_carts_on_user_id_and_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_carts_on_user_id_and_product_id ON public.carts USING btree (user_id, product_id);


--
-- Name: index_categories_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_categories_on_name ON public.categories USING btree (name);


--
-- Name: index_categorizations_on_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_categorizations_on_category_id ON public.categorizations USING btree (category_id);


--
-- Name: index_categorizations_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_categorizations_on_product_id ON public.categorizations USING btree (product_id);


--
-- Name: index_categorizations_on_product_id_and_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_categorizations_on_product_id_and_category_id ON public.categorizations USING btree (product_id, category_id);


--
-- Name: index_messages_on_receiver_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_messages_on_receiver_id ON public.messages USING btree (receiver_id);


--
-- Name: index_messages_on_sender_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_messages_on_sender_id ON public.messages USING btree (sender_id);


--
-- Name: index_price_alerts_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_price_alerts_on_product_id ON public.price_alerts USING btree (product_id);


--
-- Name: index_price_alerts_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_price_alerts_on_user_id ON public.price_alerts USING btree (user_id);


--
-- Name: index_products_on_cart_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_products_on_cart_id ON public.products USING btree (cart_id);


--
-- Name: index_products_on_searchable; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_products_on_searchable ON public.products USING gin (searchable);


--
-- Name: index_products_on_seller_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_products_on_seller_id ON public.products USING btree (seller_id);


--
-- Name: index_profiles_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_profiles_on_user_id ON public.profiles USING btree (user_id);


--
-- Name: index_reviews_on_reviewer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_reviews_on_reviewer_id ON public.reviews USING btree (reviewer_id);


--
-- Name: index_reviews_on_seller_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_reviews_on_seller_id ON public.reviews USING btree (seller_id);


--
-- Name: index_storefronts_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_storefronts_on_user_id ON public.storefronts USING btree (user_id);


--
-- Name: index_transactions_on_buyer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_transactions_on_buyer_id ON public.transactions USING btree (buyer_id);


--
-- Name: index_transactions_products_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_transactions_products_on_product_id ON public.transactions_products USING btree (product_id);


--
-- Name: index_transactions_products_on_transaction_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_transactions_products_on_transaction_id ON public.transactions_products USING btree (transaction_id);


--
-- Name: index_users_on_cart_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_cart_id ON public.users USING btree (cart_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_message_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_message_id ON public.users USING btree (message_id);


--
-- Name: index_viewed_products_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_viewed_products_on_product_id ON public.viewed_products USING btree (product_id);


--
-- Name: index_viewed_products_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_viewed_products_on_user_id ON public.viewed_products USING btree (user_id);


--
-- Name: reviews fk_rails_007031d9cb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT fk_rails_007031d9cb FOREIGN KEY (reviewer_id) REFERENCES public.users(id);


--
-- Name: categorizations fk_rails_039e11056a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categorizations
    ADD CONSTRAINT fk_rails_039e11056a FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: users fk_rails_1d13818f0e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_rails_1d13818f0e FOREIGN KEY (cart_id) REFERENCES public.carts(id);


--
-- Name: storefronts fk_rails_39ff2b2ecf; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.storefronts
    ADD CONSTRAINT fk_rails_39ff2b2ecf FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: transactions fk_rails_458bde2e92; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT fk_rails_458bde2e92 FOREIGN KEY (seller_id) REFERENCES public.users(id);


--
-- Name: price_alerts fk_rails_49aac91261; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.price_alerts
    ADD CONSTRAINT fk_rails_49aac91261 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: categorizations fk_rails_5a40b79a1d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categorizations
    ADD CONSTRAINT fk_rails_5a40b79a1d FOREIGN KEY (category_id) REFERENCES public.categories(id);


--
-- Name: messages fk_rails_67c67d2963; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT fk_rails_67c67d2963 FOREIGN KEY (receiver_id) REFERENCES public.users(id);
-- Name: transactions_products fk_rails_750aa519bf; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions_products
    ADD CONSTRAINT fk_rails_750aa519bf FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: viewed_products fk_rails_7d150f3af7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.viewed_products
    ADD CONSTRAINT fk_rails_7d150f3af7 FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: products fk_rails_82f3b66938; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT fk_rails_82f3b66938 FOREIGN KEY (seller_id) REFERENCES public.users(id);


--
-- Name: carts fk_rails_916f2a1419; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.carts
    ADD CONSTRAINT fk_rails_916f2a1419 FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: transactions_products fk_rails_91958fc620; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions_products
    ADD CONSTRAINT fk_rails_91958fc620 FOREIGN KEY (transaction_id) REFERENCES public.transactions(id);


--
-- Name: viewed_products fk_rails_95ac6b7bea; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.viewed_products
    ADD CONSTRAINT fk_rails_95ac6b7bea FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: price_alerts fk_rails_95c3a9b293; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.price_alerts
    ADD CONSTRAINT fk_rails_95c3a9b293 FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: products fk_rails_99518e1c1e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT fk_rails_99518e1c1e FOREIGN KEY (cart_id) REFERENCES public.carts(id);


--
-- Name: reviews fk_rails_9c9b72d3b5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT fk_rails_9c9b72d3b5 FOREIGN KEY (seller_id) REFERENCES public.users(id);


--
-- Name: messages fk_rails_b8f26a382d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT fk_rails_b8f26a382d FOREIGN KEY (sender_id) REFERENCES public.users(id);


--
-- Name: users fk_rails_e04d7fd992; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_rails_e04d7fd992 FOREIGN KEY (message_id) REFERENCES public.messages(id);


--
-- Name: profiles fk_rails_e424190865; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT fk_rails_e424190865 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: carts fk_rails_ea59a35211; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.carts
    ADD CONSTRAINT fk_rails_ea59a35211 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20231209181651'),
('20231209044224'),
('20231209024152'),
('20231208023046'),
('20231207195703'),
('20231207195223'),
('20231208235127'),
('20231209011039'),
('20231205154444'),
('20231204035349'),
('20231130163958'),
('20231130152546'),
('20231130152310'),
('20231130152251'),
('20231129233947'),
('20231129232534'),
('20231124050558'),
('20231124045627'),
('20231124002516'),
('20231123022551'),
('20231120011401'),
('20231120011257'),
('20231120002253'),
('20231117052029'),
('20231110040315'),
('20231109201942'),
('20231109191026'),
('20231109144728'),
('20231109045248'),
('20231107223800'),
('20231106170227'),
('20231105220022');

