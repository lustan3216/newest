class WebsiteSerializer < ActiveModel::Serializer
  attributes :id, :current_episode, :read_at, :crawled_at, :url, :title,
             :sub_urls, :sub_urls_title

end