-- Stage 3: lookup table that translates product category names (Portuguese -> English)
CREATE TABLE IF NOT EXISTS product_category_translation (
    product_category_name         TEXT PRIMARY KEY,
    product_category_name_english TEXT NOT NULL
);