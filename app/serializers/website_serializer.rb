class WebsiteSerializer < ActiveModel::Serializer
  attributes :id, :current_episode, :read_at, :crawled_at, :url, :sorted_result, :title
end