from datetime import datetime, timedelta
from airflow import DAG
from airflow.providers.postgres.hooks.postgres import PostgresHook
from airflow.decorators import task, dag

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2023, 8, 26),
    'retries': 0,
    'retry_delay': timedelta(minutes=5),
    'postgres_conn_id': 'postgres_db'
}

@dag('ex_psql', default_args=default_args, schedule_interval=None, catchup=False)
def ex_psql():
    import pandas as pd
    import polars as pl
    @task
    def read_psql_data_in_pandas():
        psql_hook = PostgresHook(postgres_conn_id=default_args['postgres_conn_id'])
        return psql_hook.get_pandas_df(
            """
            SELECT customer_id, i.order_id, quantity
            FROM OrderItems i
            INNER JOIN Orders o ON o.order_id=i.order_id;
            """)
    
    @task
    def perform_calculations_on_pandas(df):
        results = df.groupby('customer_id')['quantity'].sum().reset_index()
        return results
    
    @task
    def write_psql_data_from_pandas(dataframe):
        psql_hook = PostgresHook(postgres_conn_id=default_args['postgres_conn_id'])
        dataframe.to_sql('CustomerAmountPandas', con=psql_hook.get_sqlalchemy_engine(), if_exists='replace', index=False)

    @task
    def read_psql_data_in_polars():
        conn_uri = PostgresHook(postgres_conn_id=default_args['postgres_conn_id']).get_uri()
        return pl.read_database_uri(
            """
            SELECT customer_id, i.order_id, quantity
            FROM OrderItems i
            INNER JOIN Orders o ON o.order_id=i.order_id
            """, uri=conn_uri, engine="adbc")
    
    @task
    def perform_calculations_on_polars(df):
        results = df.group_by("customer_id").agg(pl.col("quantity").sum())  
        return results
    
    @task
    def write_psql_data_from_polars(dataframe):
        conn_uri = PostgresHook(postgres_conn_id=default_args['postgres_conn_id']).get_uri()
        dataframe.write_database('CustomerAmountPolars', connection=conn_uri, engine="adbc", if_table_exists='replace')

    pd_df = read_psql_data_in_pandas()
    pd_results = perform_calculations_on_pandas(pd_df)
    write_psql_data_from_pandas(pd_results)

    pl_df = read_psql_data_in_polars()
    pl_results = perform_calculations_on_polars(pl_df)
    write_psql_data_from_polars(pl_results)

dag = ex_psql()

if __name__ == "__main__":
    dag.test()
