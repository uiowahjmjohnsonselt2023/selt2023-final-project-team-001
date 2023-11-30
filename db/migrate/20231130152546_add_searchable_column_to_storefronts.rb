class AddSearchableColumnToStorefronts < ActiveRecord::Migration[7.1]
  def up
    execute <<-SQL
      ALTER TABLE storefronts
      ADD COLUMN searchable tsvector GENERATED ALWAYS AS (
        setweight(to_tsvector('english', name), 'A') ||
        setweight(to_tsvector('english', short_description), 'B')
      ) STORED;
    SQL
  end

  def down
    remove_column :storefronts, :searchable
  end
end
