FROM amazonlinux:latest

# install prerequisites
RUN yum update
RUN yum groupinstall "Development Tools" -y
RUN yum install openssl-devel bzip2-devel libffi-devel -y

# install Python
ARG PY_VER

WORKDIR /opt
RUN curl -o Python-${PY_VER}.tgz https://www.python.org/ftp/python/${PY_VER}/Python-${PY_VER}.tgz 
RUN tar xzf Python-${PY_VER}.tgz && cd Python-${PY_VER} && ./configure --enable-optimizations && make altinstall
RUN rm -rf ./Python-${PY_VER}.tgz

# Unpack postgresql and psycopg2
RUN mkdir -p /sources/psycopg2 /sources/postgresql
COPY ./sources /sources/
WORKDIR /sources
RUN tar xzf postgresql.tar.gz -C postgresql --strip-components 1
RUN tar xzf psycopg2.tar.gz -C psycopg2 --strip-components 1

# compile psycopg2
ARG SSL

WORKDIR /sources/postgresql
RUN if [ "$SSL" = "1" ]; then \
        ./configure --prefix /sources/postgresql --without-readline --without-zlib --with-openssl; \
    else \
        ./configure --prefix /sources/postgresql --without-readline --without-zlib; \
    fi
RUN make
RUN make install

WORKDIR /sources/psycopg2
RUN sed -i 's/pg_config = /pg_config = \/sources\/postgresql\/bin\/pg_config/g' setup.cfg
RUN sed -i 's/static_libpq = 0/static_libpq = 1/g' setup.cfg
RUN if [ "$SSL" = "1" ]; then sed -i 's/libraries = /libraries = ssl crypto/g' setup.cfg; else :; fi
RUN PY_BIN=$(cat /opt/Python-${PY_VER}/configure | grep ^VERSION= | cut -d "=" -f 2) && python${PY_BIN} setup.py build

RUN if [ "$SSL" = "1" ]; then \
        echo "Successfully compiled with SSL support"; \
    else \
        echo "Successfully compiled without SSL support"; \
    fi

RUN rm -rf ./build/temp.*