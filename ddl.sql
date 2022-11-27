CREATE TABLE IF NOT EXISTS authors
(
    id         BIGSERIAL PRIMARY KEY,
    biography  TEXT,
    first_name VARCHAR(255),
    last_name  VARCHAR(255),
    photo      VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS genres
(
    id        BIGSERIAL PRIMARY KEY,
    parent_id BIGINT REFERENCES genres (id),
    slug      VARCHAR(255) NOT NULL,
    name      VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS books
(
    id               BIGSERIAL PRIMARY KEY,
    description      TEXT,
    image            VARCHAR(255),
    in_cart_amount   BIGINT,
    is_bestseller    INTEGER,
    postponed_amount BIGINT,
    discount_price   double precision,
    price            INTEGER,
    pub_date         TIMESTAMP,
    purchase_amount  BIGINT,
    slug             VARCHAR(255),
    title            VARCHAR(255),
    author_id        BIGINT REFERENCES authors (id),
    genre_id         BIGINT REFERENCES genres (id)
);

CREATE TABLE IF NOT EXISTS tags
(
    id   BIGSERIAL PRIMARY KEY,
    name VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS book2tag
(
    id      BIGSERIAL PRIMARY KEY,
    book_id BIGINT NOT NULL REFERENCES books (id),
    tag_id  BIGINT NOT NULL REFERENCES tags (id)
);

CREATE TABLE IF NOT EXISTS users
(
    id       BIGSERIAL PRIMARY KEY,
    name     VARCHAR(255) NOT NULL,
    balance  INTEGER      NOT NULL,
    contact  VARCHAR(255) NOT NULL,
    reg_time TIMESTAMP    NOT NULL
);

CREATE TABLE IF NOT EXISTS book2author
(
    id        BIGSERIAL PRIMARY KEY,
    author_id BIGINT NOT NULL REFERENCES authors (id),
    book_id   BIGINT NOT NULL REFERENCES books (id)
);

CREATE TABLE IF NOT EXISTS book2genre
(
    id       BIGSERIAL PRIMARY KEY,
    book_id  BIGINT NOT NULL REFERENCES books (id),
    genre_id BIGINT NOT NULL REFERENCES genres (id)
);

CREATE TABLE IF NOT EXISTS book2user
(
    id      BIGSERIAL PRIMARY KEY,
    book_id BIGINT    NOT NULL REFERENCES books (id),
    time    TIMESTAMP NOT NULL,
    user_id BIGINT    NOT NULL REFERENCES users (id)
);

CREATE TABLE IF NOT EXISTS book_review
(
    id      BIGSERIAL PRIMARY KEY,
    book_id BIGINT    NOT NULL REFERENCES books (id),
    text    TEXT      NOT NULL,
    time    TIMESTAMP NOT NULL,
    user_id BIGINT    NOT NULL
);

CREATE TABLE IF NOT EXISTS book_review_like
(
    id        BIGSERIAL PRIMARY KEY,
    review_id BIGINT    NOT NULL REFERENCES book_review (id),
    time      TIMESTAMP NOT NULL,
    user_id   BIGINT    NOT NULL REFERENCES users (id),
    value     smallint  NOT NULL,
    CONSTRAINT users_like UNIQUE (review_id, user_id)
);

