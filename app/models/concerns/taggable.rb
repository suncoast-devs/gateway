# frozen_string_literal: true
module Taggable
  extend ActiveSupport::Concern

  included do
    has_many :taggings, as: :taggable
    has_many :tags, through: :taggings
  end

  def tag_list
    tags.map(&:name).join(', ')
  end

  def tag_list=(names)
    self.tags = names.split(',').map do |name|
      Tag.where(name: name.strip).first_or_create!
    end
  end

  def merge_tags(new_names)
    tag_names = tags.map(&:name)
    new_names = names.split(',')

    self.tags = (tag_names + new_names).uniq.map do |name|
      Tag.where(name: name.strip).first_or_create!
    end
  end

  module ClassMethods
    def tag_counts
      Tag.select('tags.*, count(taggings.tag_id) as count').joins(:taggings).group('taggings.tag_id')
    end
  end
end
