# https://pganalyze.com/blog/full-text-search-ruby-rails-postgres
class AddSearchableColumnToProducts < ActiveRecord::Migration[7.1]
  def up
    execute <<-SQL
      ALTER TABLE products
      ADD COLUMN searchable tsvector GENERATED ALWAYS AS (
        setweight(to_tsvector('english', name), 'A') ||
        setweight(to_tsvector('english', description), 'B')
      ) STORED;
    SQL
  end

  def down
    remove_column :products, :searchable
  end
end
