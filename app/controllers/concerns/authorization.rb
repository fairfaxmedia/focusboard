module Authorization
  extend ActiveSupport::Concern

  private

  def enabled_user
    redirect_to boards_path unless current_user.enabled?
  end

  def admin_user
    redirect_to boards_path unless current_user.admin?
  end
end
