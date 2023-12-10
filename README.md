# selt2023-final-project-team-001

## Project Summary

This is a practical online platform designed for buying and selling goods. We aim to make the process straightforward, connecting buyers with a variety of products and allowing sellers to list their items easily.

### Key Features

- Users can create an account, login securely with our credentials or their google account, and reset their password. 

- Users can view products available for sale, with the option to sort and filter according to attributes like price, date posted, and tags.

- Users can register to sell products, with the ability to sell as an independent seller (in the style of Facebook Marketplace or Craigslist) or set up a storefront to sell products regularly (more in the style of Etsy).
- Sellers can choose to set up a storefront where they can establish a business selling their products.
- Sellers can customize their storefront's appearance with HTML or use a premade template.

- Buyers and sellers can interact in a number of different ways: through on-platform messaging and leaving seller reviews.

- Users have profiles which for sellers will display and allow leaving reviews as well as personal info a user wishes to share.

- Users can add items to their cart and "purchase" them.

- Users can search products or storefronts.

- Viewing individual product pages with a view similar to Amazon.

- Ability to add items to a price alert list, where if the price drops below the threshold you set it will send you an email notification.

- Ability for sellers to add deals (either a fixed amount off or a percent off).

### Navigation

- From the home page, users can use the navigation bar to find what they are looking for as well as follow some of the features suggested depending on users status (like whether they are logged in or a seller).
- All users will see links to view what storefronts are available, as well as links to view all products sorted by recency.
- On the left in the nav bar, there is also a dropdown menu listing the product categories. Any user can click a category to view all the products in that category.
- On the right in the nav bar, a user who is not logged in will have a link to the login/sign up page, and a user who is logged in will have a dropdown menu allowing them to view their profile and create or update their storefront among many other features only logged in users can access.
- For explicit instructions see our wiki on the HOWTO page.


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
