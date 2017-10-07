class WebsiteSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :keyword, :read_at, :crawled_at, :url, :sorted_result
end