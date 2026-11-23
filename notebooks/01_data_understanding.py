import pandas as pd

orders = pd.read_csv("data/raw/olist_orders_dataset.csv")
customers = pd.read_csv(
    "data/raw/olist_customers_dataset.csv",
    dtype={"customer_zip_code_prefix": str},
)

print("ORDERS shape:", orders.shape)
print(orders.dtypes)
print()
print("CUSTOMERS shape:", customers.shape)
print(customers.dtypes)
print()
print(customers.head(3))

print()
print("customer_id benzersiz sayısı:", customers["customer_id"].nunique())
print("customer_unique_id benzersiz sayısı:", customers["customer_unique_id"].nunique())
print("orders içinde benzersiz order_id:", orders["order_id"].nunique())
print("orders içinde benzersiz customer_id:", orders["customer_id"].nunique())

print()
print("=" * 40)
for name in ["order_items", "products", "order_payments", "order_reviews"]:
    df = pd.read_csv(f"data/raw/olist_{name}_dataset.csv")
    print(name, "shape:", df.shape)
    print(list(df.columns))
    print()