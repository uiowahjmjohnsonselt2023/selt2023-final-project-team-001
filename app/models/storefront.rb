class Storefront < ApplicationRecord
  include PgSearch::Model

  belongs_to :user

  validates :name, presence: true, uniqueness: true, length: {maximum: 75}
  validates :short_description, presence: true, length: {maximum: 500}

  pg_search_scope :search_text,
    against: {name: "A", short_description: "B"},
    using: {
      tsearch: {
        dictionary: "english",
        tsvector_column: "searchable",
        prefix: true,
        any_word: true
      },
      trigram: {
        only: [:name],
        threshold: 0.1
      }
    }
end
