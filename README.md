# selt2023-final-project-team-001

## Installation

Clone the repository. Then, you'll need to install some additional dependencies.

### pre-commit

`pre-commit` can be installed in a variety of ways.

```shell
# With pip:
pip install pre-commit
# With homebrew:
brew install pre-commit
# With conda:
conda install -c conda-forge pre-commit
```

Then, in the repository directory, run `pre-commit install` to install the git hooks.
You can setup the environment and ensure it works by running `pre-commit run --all-files`
(you'll need to ensure your Ruby system version is 3.1.3 beforehand).

### PostgreSQL

The [installation instructions](https://www.postgresql.org/download/) for PostgreSQL vary
by operating system.

#### macOS

One way to install PostgreSQL on macOS is with [Homebrew](https://brew.sh/):

```shell
# Version 15 is the default version that Heroku uses.
brew install postgresql@15
brew link postgresql@15

# Start the server and have it start on login.
# Alternatively, you can use "run" instead of "start" to have it not start on login.
brew services start postgresql@15
```

#### Ubuntu

One way to install PostgreSQL on Ubuntu is via apt

```shell
sudo apt update
sudo apt install postgresql postgresql-contrib
```

To start running the PostgreSQL Service:
```shell
sudo service postgresql start
# If you want to enable it to always start at boot
sudo systemctl enable postgresql
```

To access PostgreSQL via the postgres user and then enter PostgreSQL prompt
```shell
sudo -i -u postgres
psql
# To exit PostgreSQL prompt run
# \q
```

To create a PostgreSQL User and Database for development (replace myapp_development, myappuser, and 'password' with the desired names for your database, user, and password).
```shell
CREATE DATABASE myapp_development;
CREATE USER myappuser WITH PASSWORD 'password';
ALTER ROLE myappuser SET client_encoding TO 'utf8';
ALTER ROLE myappuser SET default_transaction_isolation TO 'read committed';
ALTER ROLE myappuser SET timezone TO 'UTC';
GRANT ALL PRIVILEGES ON DATABASE myapp_development TO myappuser;
```
Lastly in config/database.yml be sure to set the username, password, and database fields to match the PostgreSQL configuration you set up.

#### Windows
