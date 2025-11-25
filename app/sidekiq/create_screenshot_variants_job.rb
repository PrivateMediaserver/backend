class CreateScreenshotVariantsJob
  include Sidekiq::Job

  def perform(id)
    screenshot = Screenshot.find(id)

    screenshot.file.variant(:thumb).processed if screenshot.main
    screenshot.file.variant(:webp).processed
  end
end
