class Google
  def self.find_for_google_oauth2(auth)

    # Case 1: Find existing user by google uid
    user = User.find_by_google_uid( auth.uid )
    if user

      if !user.foodie_id
        user.foodie_id = auth[:info][:name]
      end

      user.google_name = auth[:info][:name]
      user.google_email = auth[:info][:email]
      user.google_head_shot = auth[:info][:image]
      user.google_token = auth.credentials.token
      user.google_raw_data = auth
      user.google_head_shot = auth[:info][:image]

      user.skip_confirmation!
      user.save!
      return user
    end


    # Case 2: Find existing user by email
    existing_user = User.find_by_email( auth.info.email )
    if existing_user

      if existing_user.is_chef
        return
      end

      if !existing_user.foodie_id
        existing_user.foodie_id = auth[:info][:name]
      end

      existing_user.google_name = auth[:info][:name]
      existing_user.google_email = auth[:info][:email]
      existing_user.google_uid = auth.uid
      existing_user.google_token = auth.credentials.token
      existing_user.google_raw_data = auth
      existing_user.google_head_shot = auth[:info][:image]

      existing_user.skip_confirmation!
      existing_user.save!
      return existing_user
    end

    # Case 3: Create new password
    user = User.new
    user.name = auth.info.name
    user.foodie_id = auth.info.name
    user.email = auth.info.email
    user.password = Devise.friendly_token[0,20]
    user.phone_number = "0"

    # google info
    user.google_uid = auth.uid
    user.google_token = auth.credentials.token
    user.google_raw_data = auth
    user.google_name = auth[:info][:name]
    user.google_email = auth[:info][:email]
    user.google_head_shot = auth[:info][:image]

    user.skip_confirmation!
    user.save!
    return user
  end
end