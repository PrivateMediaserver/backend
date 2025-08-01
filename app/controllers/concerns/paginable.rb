module Paginable
  extend ActiveSupport::Concern

  included do
    include Pagy::Backend
  end

  private

  def paginate(collection)
    pagination, records = pagy(collection)

    [ pagination, records ]
  end

  def current_page
    params[:page]&.to_i || 1
  end

  def per_page
    params[:per_page]&.to_i || 25
  end
end
