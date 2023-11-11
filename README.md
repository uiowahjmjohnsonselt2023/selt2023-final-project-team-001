# selt2023-final-project-team-001

## Project Summary

This is a practical online platform designed for buying and selling goods. We aim to make the process straightforward, connecting buyers with a variety of products and allowing sellers to list their items easily.

### Key Features

- Users can create an account and login securely. 

- Users can view products available for sale, with the option to sort and filter according to attributes like price, date posted, and tags.

- Users can register to sell products, with the ability to sell as an independent seller (in the style of Facebook Marketplace or Craigslist) or set up a storefront to sell products regularly (more in the style of Etsy).

- Buyers and sellers can make use of third-party plugins for UPS and FedEx to calculate shipping, prepare and print shipping labels, and track their orders.

- Buyers and sellers can interact in a number of different ways: through on-platform messaging, commenting, and leaving product, seller, and buyer reviews.

### Navigation

- When users navigate to the \login page of the app, they are prompted to log in with their username and password.

- If users do not have an account, they should visit \signup, where they will be prompted to create an account.

- Users can register to sell products on the \register page.

- Users can view products for sale on the \products page. 


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

#### Windows

You can install PostgreSQL using WSL and follow the above guide for Ubuntu.
