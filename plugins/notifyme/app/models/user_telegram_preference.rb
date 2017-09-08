class UserTelegramPreference
  include ActiveModel::Model

  attr_accessor :user

  def save
    user.pref[:telegram] = { no_self_notified: no_self_notified }
    user.pref.save!
  end

  def no_self_notified
    return @no_self_notified unless @no_self_notified.nil?
    return false unless user.pref[:telegram]
    user.pref[:telegram][:no_self_notified] || false
  end

  def no_self_notified=(value)
    @no_self_notified = value.present? && value != '0'
  end
end
