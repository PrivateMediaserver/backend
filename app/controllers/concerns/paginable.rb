module Paginable
  extend ActiveSupport::Concern

  included do
    include Pagy::Method
  end

  private

  def paginate(collection)
    pagy(:offset, collection, page: current_page, limit: current_limit)
  end

  def current_page
    params[:page]&.to_i || 1
  end

  def current_limit
    params[:limit]&.to_i || 20
  end
end
