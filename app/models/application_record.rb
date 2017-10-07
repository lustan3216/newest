class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def redis
    Redis.new
  end
end
