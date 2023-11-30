class AddNameToStorefronts < ActiveRecord::Migration[7.1]
  def up
    # Add the name column. We use execute because we need to update values in the
    # database, and using the model itself in is considered bad practice. We have to
    # insert values because we need to set a non-null value for existing rows, but
    # but since we want name to be unique, we can't just use a default value.
    execute <<-SQL
      -- Add the name column.
      ALTER TABLE storefronts
      ADD COLUMN name character varying;

      -- Populate the name column using the user's email.
      UPDATE storefronts
      SET name = users.email || '''s Storefront'
      FROM users
      WHERE storefronts.user_id = users.id;

      -- Make the name column non-nullable.
      ALTER TABLE storefronts
      ALTER COLUMN name SET NOT NULL;

      -- Add a uniqueness constraint on the name column.
      ALTER TABLE storefronts
      ADD CONSTRAINT storefronts_name_unique UNIQUE (name);
    SQL
  end

  def down
    remove_column :storefronts, :name
  end
end
