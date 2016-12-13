class V1::CommentsRepresenter < V1::CollectionRepresenter
  self.representation_wrap = :comments
  items extend: ::V1::CommentRepresenter,
        class:  Commenting::Comment,
        wrap:   false
end
