class User < ActiveRecord::Base
  def self.create_from_object(user)
    return if User.exists? user.id

    User.create id: user.id,
      name: user.name,
      icon_url: user.profile_image_url
  end
end
