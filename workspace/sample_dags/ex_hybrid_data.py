from datetime import datetime, timedelta
from airflow import DAG
from airflow.decorators import task, dag
from airflow.utils.dates import days_ago
from pathlib import Path


# Define default arguments for the DAG
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': days_ago(1),
    'retries': 0,
    'retry_delay': timedelta(minutes=5),
    'catchup':False
}

# Initialize the DAG
@dag('ex_hybrid_data_and_task_with_multiple_inputs', default_args=default_args, schedule_interval=None)
def ex_hybrid_data_and_task_with_multiple_inputs():
    import duckdb
    import polars as pl
    import pandas as pd

    @task
    def load_data_from_online_file_with_duckdb():
        URL='https://raw.githubusercontent.com/cwida/duckdb/master/data/parquet-testing/bug1554.parquet'

        # via sql
        #dfA=duckdb.sql(f"SELECT * FROM parquet_scan('{URL}')").pl()

        # via read_parquet
        dfA=duckdb.read_parquet(URL).pl()
        print('dfA', type(dfA), dfA)
        
        return dfA

    @task
    def create_polars_frame():
        return pl.DataFrame(
            {
            "A": [1, 2, 3, 4, 5],
                "fruits": ["banana", "banana", "apple", "apple", "banana"],
                "B": [5, 4, 3, 2, 1],
                "cars": ["beetle", "audi", "beetle", "beetle", "beetle"],
            }
        )

    @task
    def create_pandas_frame():
        return pd.DataFrame(
            {
            "A": [1, 2, 3, 4, 5],
                "fruits": ["banana", "banana", "apple", "apple", "banana"],
                "B": [5, 4, 3, 2, 1],
                "cars": ["beetle", "audi", "beetle", "beetle", "beetle"],
            }
        )


    @task
    def create_hybrid_data(polars_dfA, polars_dfB, pandas_df):
        data=['A', 2, 3, 'B', {
            'polars':[polars_dfA, polars_dfB],
            'remaining':pandas_df,
            'test':[4,3,6,7,6,10, 'aaa', 'bbb', 'ccc']
        }]
        return data

    @task
    def get_hybrid_data(data):
        print(data)

    # Set task dependencies
    #prepare_data() >> [prepare_a(), prepare_b()] >> join_a_and_b() >> describe()
    dfA=load_data_from_online_file_with_duckdb()
    dfB=create_polars_frame()
    dfC=create_pandas_frame()
    data=create_hybrid_data(dfA, dfB, dfC)
    get_hybrid_data(data)

# Create the DAG
dag = ex_hybrid_data_and_task_with_multiple_inputs()

if __name__ == "__main__":
    dag.test()