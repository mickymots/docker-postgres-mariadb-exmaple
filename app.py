import pyodbc 
import traceback
from flask import Flask
app = Flask(__name__)


@app.route('/')
def hello_pg():
    database = 'espresso' 
    username = 'pgadmin' 
    password = 'something' 
    # cnxn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER='+server+';DATABASE='+database+';UID='+username+';PWD='+ password)
    message = ''
    try:
        cnxn = pyodbc.connect('DRIVER={PostgreSQL ANSI};Server=db;Port=5432;Database=espresso;UserName=pgadmin;Password=something;String Types=Unicode')

        cnxn.setencoding(encoding='utf-8')
        cnxn.setdecoding(pyodbc.SQL_CHAR, encoding='utf-8')
        cnxn.setdecoding(pyodbc.SQL_WCHAR, encoding='utf-8')


        cursor = cnxn.cursor()

        
        #Sample select query
        cursor = cursor.execute("SELECT version();") 
        
        # row = cursor.fetchone() 
        for row in cursor: 
            message = f'output = {row[0]}'
            row = cursor.fetchone()
    except Exception:
        message = traceback.format_exc()

    return f'Hey, we have Flask in a Docker container! {message}'

import mysql.connector as database

@app.route('/maria')
def hello_maria():
    # Connect to MariaDB Platform
    message = 'default message'
    try:
        conn = database.connect(
            user="root",
            password="something",
            host="maria_db",
            port=3306,
        )
        cursor = conn.cursor()
        cursor.execute("SELECT version();") 
        message = 'before running 2'
        
        for row in cursor:
            print(f"row{row[0]}") 
            message = message + f"{row[0]}"

        # /message = "after running query"
    except Exception as e:
        print(f"Error connecting to MariaDB Platform: {e}")
        mesaage = 'some errror '
        
  

    return f'Hey, we have Maria-Db in a Docker container! {message}'



if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
