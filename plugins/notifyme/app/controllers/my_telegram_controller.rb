class MyTelegramController < ApplicationController
  before_filter :require_login, :build_chats

  helper :users

  def index
    @pref = @user.telegram_pref
  end

  def update
    @pref = UserTelegramPreference.new(pref_params)
    if @pref.save
      redirect_to my_telegram_path, notice: l(:notice_account_updated)
    else
      render :index
    end
  end

  private

  def build_chats
    @user = User.current
    @chats = TelegramChat.where(user: @user)
  end

  def pref_params
    params[:user_telegram_preference].permit(:no_self_notified).merge(
      user: @user
    )
  end
end
