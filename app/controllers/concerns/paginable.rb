module Paginable
  extend ActiveSupport::Concern

  included do
    include Pagy::Backend
  end

  private

  def paginate(collection)
    pagination, records = pagy(collection, page: current_page, limit: current_limit)

    [ pagination, records ]
  end

  def current_page
    params[:page]&.to_i || 1
  end

  def current_limit
    params[:limit]&.to_i || 20
  end
end
