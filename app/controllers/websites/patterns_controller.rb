class Websites::PatternsController < ApplicationController

  def index
    render json: { data: Website.patterns.to_h }
  end

end
