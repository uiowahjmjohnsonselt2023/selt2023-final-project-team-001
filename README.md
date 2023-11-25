# selt2023-final-project-team-001

## Project Summary

This is a practical online platform designed for buying and selling goods. We aim to make the process straightforward, connecting buyers with a variety of products and allowing sellers to list their items easily.

### Key Features

- Users can create an account and login securely. 

- Users can view products available for sale, with the option to sort and filter according to attributes like price, date posted, and tags.

- Users can register to sell products, with the ability to sell as an independent seller (in the style of Facebook Marketplace or Craigslist) or set up a storefront to sell products regularly (more in the style of Etsy)
- Sellers can choose to set up a storefront where they can establish a business selling their products
- Sellers can customize their storefront's appearance with HTML

- Buyers and sellers can make use of third-party plugins for UPS and FedEx to calculate shipping, prepare and print shipping labels, and track their orders.

- Buyers and sellers can interact in a number of different ways: through on-platform messaging, commenting, and leaving product, seller, and buyer reviews.

### Navigation

- From the home page, users can use the navigation bar to find what they are looking for.
- All users will see links to view their storefronts (for users who are not logged in/registered, following this link will lead them to a page showing that they have no storefronts), as well as links to view all products sorted by recency.
- On the left in the nav bar, there is also a dropdown menu listing the product categories. Any user can click a category to view all the products in that category.
- On the right in the nav bar, a user who is not logged in will have a link to the login/sign up page, and a user who is logged in will have a dropdown menu allowing them to view their profile and create or update their storefront


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
