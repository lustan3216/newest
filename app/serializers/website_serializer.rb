class WebsiteSerializer < ActiveModel::Serializer
  attributes :id, :keyword, :read_at, :crawled_at, :url, :sorted_result, :title
end