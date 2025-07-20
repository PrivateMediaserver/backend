class V1::TagsController < V1Controller
  before_action :authorize
  before_action :set_tag, only: [ :update, :destroy ]

  def index
    @tags = Current.user.tags
  end

  def create
    @tag = Current.user.tags.new(tag_params)

    if @tag.save
      render :show, status: :created
    else
      render json: { status: 422, error: "Unprocessable Content", fields: @tag.errors }, status: :unprocessable_content
    end
  end

  def update
    if @video.update(tag_params)
      render :show, status: :ok
    else
      render json: { status: 422, error: "Unprocessable Content", fields: @tag.errors }, status: :unprocessable_content
    end
  end

  def destroy
    @video.destroy!
  end

  private

  def set_tag
    @tag = Current.user.tags.find(params[:id])
  end

  def tag_params
    params.expect(tag: [ :name ])
  end
end
