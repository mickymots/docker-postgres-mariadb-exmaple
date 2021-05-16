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




# MariaDB driver
WORKDIR /home/anaconda
COPY mysql-connector-odbc-5.3.14-linux-glibc2.12-x86-64bit.tar.gz .
RUN gunzip mysql-connector-odbc-5.3.14-linux-glibc2.12-x86-64bit.tar.gz
RUN tar xvf mysql-connector-odbc-5.3.14-linux-glibc2.12-x86-64bit.tar

WORKDIR /home/anaconda/mysql-connector-odbc-5.3.14-linux-glibc2.12-x86-64bit
RUN cp bin/* /usr/local/bin
RUN cp lib/* /usr/local/lib


# postgres odbc config file
WORKDIR /home/anaconda

RUN cat /etc/odbcinst.ini

COPY odbcinst.ini /usr/local/etc/odbcinst.ini
RUN rm /etc/odbcinst.ini
RUN ln -s /usr/local/etc/odbcinst.ini /etc/odbcinst.ini

WORKDIR /home/anaconda
COPY app.py .
COPY requirements.txt .


ENTRYPOINT [ "/pyenv/bin/python" ]
CMD ["app.py"]