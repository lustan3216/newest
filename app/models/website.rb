class Website < ApplicationRecord

  belongs_to :user

  validates_presence_of :keyword, :url
  validates :url, uniqueness: { scope: :user_id }, on: :create

  before_save :assign_current_episode, on: :create
  after_commit :crawl_data, on: :create

  def result
    keys = redis.keys("#{url}:episode:*")
    reduce_keys(keys)
  end

  def sorted_result
    result.sort_by { |x| x.keys.first.to_s.to_i }
  end

  def reduce_keys(keys)
    keys.reduce([]) do |all, key|
      parsed_key = parse_redis_episode(key)
      if current_episode < parsed_key.to_i
        all << Hash[parsed_key, redis.get(key)]
      else
        all
      end
    end
  end

  def parse_redis_episode(key)
    key.match(/.+:episode:(\d+)/)[1]
  end

  def parse_episode
    keyword.match(/(\d*)/)[1]
  end

  def title
    redis.get("#{url}:title")
  end

  private

  def assign_current_episode
    assign_attributes(current_episode: parse_episode)
  end

  def crawl_data
    Crawler::Main.new(self).update
    update_column(:crawled_at, Time.current)
  end

end
