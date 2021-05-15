from jcrist/alpine-dask

USER root
RUN /opt/conda/bin/conda create -p /pyenv -y
RUN /opt/conda/bin/conda install -p /pyenv dask scikit-learn flask waitress gunicorn \
    pytest apscheduler matplotlib pyodbc -y
RUN /opt/conda/bin/conda install -p /pyenv -c conda-forge dask-ml -y
RUN /opt/conda/bin/conda install -p /pyenv pip -y
RUN /pyenv/bin/pip install pydrill

# postgres driver added  
RUN apk add psqlodbc

# postgres odbc config file
WORKDIR /etc
COPY odbcinst.ini .

#MariaDB driver
RUN /pyenv/bin/pip install mysql-connector-python


WORKDIR /home/anaconda
COPY app.py .
COPY requirements.txt .


ENTRYPOINT [ "/pyenv/bin/python" ]
CMD ["app.py"]