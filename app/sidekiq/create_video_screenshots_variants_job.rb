class CreateVideoScreenshotsVariantsJob
  include Sidekiq::Job

  def perform(id)
    Video.find(id).screenshots.each do |screenshot|
      CreateScreenshotVariantsJob.perform_async(screenshot.id)
    end
  end
end
