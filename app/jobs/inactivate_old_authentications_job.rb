class InactivateOldAuthenticationsJob < ApplicationJob
  queue_as :medium

  def perform
    authentications.find_each(&:expired!)
  end

  private

  def authentications
    Authentication.active.where(updated_at: ..6.hours.ago)
  end
end
