class Facebook

  def self.from_facebook_omniauth(auth, browser_time_zone)
    # Case 1: Find existing user by facebook uid
    user = User.find_by_fb_uid(auth.uid)
    if user
      user.fb_token = auth.credentials.token
      user.fb_raw_data = auth
      # user.skip_confirmation!
      user.save!
      return user
    end

    # Case 2: Find existing user by email
    existing_user = User.find_by_email( auth.info.email )
    return existing_user = 'user_conflict' if existing_user
    # existing_user.fb_uid = auth.uid
    # existing_user.fb_token = auth.credentials.token
    # existing_user.fb_raw_data = auth
    # existing_user.save!
    # return existing_user

    # Case 3: Create new password
    user = User.new
    user.fb_uid = auth.uid
    user.fb_token = auth.credentials.token
    user.email = auth.info.email
    user.alternate_email = auth.info.email
    user.password = Devise.friendly_token[0, 20]
    user.fb_raw_data = auth
    user.time_zone = browser_time_zone
    user.fb_pic = auth.info.image
    user.name = auth.info.name
    # user.skip_confirmation!
    user.save!
    return user
  end

  def connect_to_facebook(auth)
    #   檢查這個帳戶是不是有被關聯過
    # user = User.find_by_fb_uid(auth.uid)

    if User.find_by_fb_uid(auth.uid).id != id
      return false
    else
      self.fb_uid = auth.uid
      self.fb_token = auth.credentials.token
      self.fb_raw_data = auth
      save!
      if fb_uid.nil?
        return true
      elsif fb_uid == auth.uid
        return 'update'
      end
    end
  end
end