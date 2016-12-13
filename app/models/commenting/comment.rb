module Commenting
  class Comment < ActiveRecord::Base
    include Curatable

    COMMENT_TREE_DEPTH_LIMIT = 2

    belongs_to :thread,   class_name: 'Commenting::Thread'
    belongs_to :author,   class_name: 'User'

    has_closure_tree parent_column_name: 'reply_to_id'

    scope :top_level,   -> { roots }
    scope :replies,     -> { where.not(reply_to_id: nil) }

    alias_attribute :reply_to, :parent
    alias_attribute :replies,  :children

    alias top_level? root?
    alias reply?     child?

    def self.comment_tree(hash = hash_tree(limit_depth: COMMENT_TREE_DEPTH_LIMIT))
      hash.each_with_object([]) do |(comment, children), array|
        item = Commenting::CommentTreeItem.new(comment)
        item.children = comment_tree(children)
        array << item
      end
    end
  end
end
