class PostSerializer < ActiveModel::Serializer
  attributes :id, :caption, :created_at, :updated_at, :image_url, :user

  def image_url
    Rails.application.routes.url_helpers.rails_blob_path(object.image, only_path: true)
  end

  def user
    {
      id: object.user.id,
      name: object.user.name,
      username: object.user.username,
      email: object.user.email
    }
  end
end
