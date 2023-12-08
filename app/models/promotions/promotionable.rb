module Promotionable
  extend ActiveSupport::Concern

  included do
    has_one :promotion, as: :promotionable, touch: true
    delegate_missing_to :promotion
  end
end
