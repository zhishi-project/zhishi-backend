module ModelJSONHashHelper
  def user_and_comment_attributes
    {
      comments: {
        only: [:content],
        include: user_attributes
      },
    }.merge(user_attributes)
  end

  def user_attributes
    {
      user: { only: [:name, :email] }
    }
  end
end
