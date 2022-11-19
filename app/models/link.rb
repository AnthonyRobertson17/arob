# frozen_string_literal: true

class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :url, presence: true, format: URI::DEFAULT_PARSER.make_regexp
end
