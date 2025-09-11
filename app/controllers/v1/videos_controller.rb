class V1::VideosController < V1Controller
  include Paginable

  before_action :authorize, except:  %i[ playlist ]
  before_action :set_video, only: %i[ show screenshots update update_preview update_progress destroy ]

  def index
    videos = Current.user.videos.processed

    if videos_query[:person_ids].present?
      videos = videos.joins(video_people: :person)
                       .where(people: { id: videos_query[:person_ids] })
    end

    if videos_query[:tag_ids].present?
      videos = videos.joins(video_tags: :tag)
                       .where(tags: { id: videos_query[:tag_ids] })
    end

    videos = videos.order(created_at: :desc)
                   .with_attached_file
                   .includes(
                     preview: { file_attachment: :blob }
                   )

    @pagination, @videos = paginate(videos)
  end

  def show
    @playlist = v1_videos_video_playlist_url(@video, params: { key: @video.generate_token_for(:playlist) })
  end

  def random_id
    id = Current.user.videos.order("RANDOM()").limit(1).pluck(:id).first

    render json: { id: }
  end

  def playlist
    @video = Video.find(params[:id])

    fragments = @video.video_fragments
                      .includes(file_attachment: :blob)
                      .order(sequence_number: :asc)

    playlist_lines = @video.headers.dup

    fragments.each do |fragment|
      playlist_lines.push("#EXTINF:#{fragment.duration}")
      playlist_lines.push(polymorphic_url(fragment.file))
    end

    playlist_lines.push("#EXT-X-ENDLIST")

    render plain: playlist_lines.map(&:to_s).join("\n"), content_type: "application/vnd.apple.mpegurl"
  end

  def screenshots
    @screenshots = @video.screenshots.order(created_at: :asc).with_attached_file
  end

  def create
    @video = Current.user.videos.new(create_video_params)

    if @video.save
      ProcessVideoJob.perform_later(@video.id)
      render :show, status: :created
    else
      render json: { status: 422, error: "Unprocessable Content", fields: @video.errors }, status: :unprocessable_content
    end
  end

  def update
    if @video.update(update_video_params)
      render :show, status: :ok
    else
      render json: { status: 422, error: "Unprocessable Content", fields: @video.errors }, status: :unprocessable_content
    end
  end

  def update_preview
    new_preview = @video.screenshots.find(params.expect(:preview_id))

    if new_preview.update(main: true)
      @screenshots = @video.screenshots.order(created_at: :asc)
      render :screenshots, status: :ok
    else
      render json: { status: 422, error: "Unprocessable Content", fields: new_preview.errors }, status: :unprocessable_content
    end
  end

  def update_progress
    if @video.update(update_video_progress)
      render json: { progress: @video.progress, viewed: @video.viewed }, status: :ok
    else
      render json: { status: 422, error: "Unprocessable Content", fields: @video.errors }, status: :unprocessable_content
    end
  end

  def destroy
    @video.destroy!
  end

  private

  def videos_query
    params.permit(person_ids: [], tag_ids: [])
  end

  def set_video
    @video = Current.user.videos.find(params.expect(:id))
  end

  def create_video_params
    params.expect(video: [ :name, :file ])
  end

  def update_video_params
    params.expect(video: [ :name, person_ids: [], tag_ids: [] ])
  end

  def update_video_progress
    params.expect(video: [ :progress ])
  end
end
