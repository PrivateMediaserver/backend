class V1::VideosController < V1Controller
  before_action :authorize
  before_action :set_video, only: %i[ show screenshots update destroy ]

  def index
    @videos = Current.user.videos
                     .with_attached_file
                     .where(videos_query)
                     .includes(
                       preview: { file_attachment: :blob }
                     )
  end

  def show
  end

  def screenshots
    @screenshots = @video.screenshots.order(created_at: :asc).with_attached_file
  end

  def create
    @video = Current.user.videos.new(video_params)

    if @video.save
      ProcessVideoJob.perform_later(@video.id)
      render :show, status: :created
    else
      render json: { status: 422, error: "Unprocessable Content", fields: @video.errors }, status: :unprocessable_content
    end
  end

  def update
    if @video.update(video_params)
      render :show, status: :ok
    else
      render json: { status: 422, error: "Unprocessable Content", fields: @video.errors }, status: :unprocessable_content
    end
  end

  def destroy
    @video.destroy!
  end

  private

  def set_video
    @video = Current.user.videos.find(params.expect(:id))
  end

  def videos_query
    params.permit(:collection_id)
  end

  def video_params
    params.expect(video: [ :name, :collection_id, :file ])
  end
end
