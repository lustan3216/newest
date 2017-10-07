class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def serialize_data(data, serializer, options = {})
    if data.respond_to?(:to_ary)
      data.map { |record| serializer.new(record, options).as_json }
    else
      serializer.new(data).as_json
    end
  end
end
