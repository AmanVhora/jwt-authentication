class PostSerializer < ActiveModel::Serializer
  attributes :id, :caption, :created_at, :updated_at, :images_urls, :user

  def images_urls
    if object.images.attached?
      object.images.map do |image|
        Rails.application.routes.url_helpers.rails_blob_url(image, only_path: true)
      end
    end
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
