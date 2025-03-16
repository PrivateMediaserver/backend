class V1::CollectionsController < V1Controller
  before_action :authorize
  before_action :set_collection, only: %i[ show update destroy ]

  def index
    @collections = Current.user.collections
  end

  def show
  end

  def create
    @collection = Current.user.collections.new(collection_params)

    if @collection.save
      render :show, status: :created
    else
      render json: { status: 422, error: "Unprocessable Content", fields: @collection.errors }, status: :unprocessable_content
    end
  end

  def update
    if @collection.update(collection_params)
      render :show
    else
      render json: { status: 422, error: "Unprocessable Content", fields: @collection.errors }, status: :unprocessable_content
    end
  end

  def destroy
    @collection.destroy!
  end

  private

  def set_collection
    @collection = Current.user.collections.find(params.expect(:id))
  end

  def collection_params
    params.expect(collection: [ :name ])
  end
end
