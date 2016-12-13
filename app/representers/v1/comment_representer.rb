class V1::CommentRepresenter < V1::BaseRepresenter
  self.representation_wrap = :comment

  with_options writeable: false do
    property :id
    property :author_id
    property :reply_to_id
    property :created_at
    property :status

    collection :children, as:     :replies,
                          extend: ::V1::CommentRepresenter,
                          wrap:   false,
                          if:     ->(user_options:, **) {
                            (user_options || {}).fetch(:include_replies, false)
                          }
    property :subject_id,
             getter:    ->(_) { thread.subject.id },
             if:        ->(user_options:, **) {
               (user_options || {}).fetch(:curated, false)
             }
    property :subject_type,
             getter: ->(_) { thread.subject.class.name },
             if:        ->(user_options:, **) {
               (user_options || {}).fetch(:curated, false)
             }
  end

  property :message
end
