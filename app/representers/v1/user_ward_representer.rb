class V1::UserWardRepresenter < V1::WardRepresenter
  property :creator, skip_render: true
  property :url, skip_parse: true
end
