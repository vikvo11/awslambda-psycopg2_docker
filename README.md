psycopg2 Python 3 Library for AWS Lambda
====

## Why this fork?
`psycopg2` library needs to be compiled in Amazon Linux using a specific Python version.
I created the script to automatically compile the library using any Python version.

Due to AWS Lambda missing the required PostgreSQL libraries in the AMI
image, we needed to compile psycopg2 with the PostgreSQL `libpq.so` library
statically linked libpq library instead of the default dynamic link.


## Prepare
1. Install Docker.
1. Download the
  [PostgreSQL source code](https://ftp.postgresql.org/pub/source) (.tar.gz),
  rename to **postgresql.tar.gz** and put it into `sources` folder.
1. Download the
  [psycopg2 source code](https://pypi.org/project/psycopg2/#files) (.tar.gz),
  rename to **psycopg2.tar.gz** and put it into `sources` folder.


## Compile in MacOS/Linux
- compile: `make compile PYTHON=<version>` (find [available versions](https://www.python.org/ftp/python/) here).
- compile with SSL support: `make compile PYTHON=<version> SSL=1`

custom compiled `psycopg2` library is now ready in the `build` folder.


## Compile in Windows
`Makefile` is not available on Windows, there're few options:
- use [WSL](https://learn.microsoft.com/en-us/windows/wsl/)
- run docker commands in `makefile` manually.
