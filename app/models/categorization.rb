# This is a has_many :through association instead of a has_and_belongs_to_many
# association because we want to be able to add additional attributes to the
# categorization table in the future, which we can't do with a HABTM association.
class Categorization < ApplicationRecord
  belongs_to :product
  belongs_to :category
end
