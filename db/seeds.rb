class Seed < SeedHelper
  def create_users
    24.times{
      email = Faker::Internet.email.gsub(/@.+/, '@andela.com')
      name = Faker::Name.first_name
      id_number = Faker::IDNumber.valid
      User.from_omniauth(FakeOmniAuth.new(id_number, 'google-oauth2'))
    }
  end

  def create_comments(fields)
    5.times{ Comment.create( fields.merge!(comment_on_id: question.id,
                            comment_on_type: objectify("question"))
                           )
            }
    15.times{ Comment.create(fields.merge!(comment_on_id: answer.id,
                             comment_on_type: objectify("answer"))
                            )
            }
  end

  def create_resource_tags
    %w(question user).each do |resource|
      10.times{ ResourceTag.create(tag: tag, taggable_id: (send(:"#{resource}")).id,
                                   taggable_type: objectify(resource)
                                  )
              }
    end
  end

  def create_votes
    %w(question answer comment).each do |resource|
      10.times{ Vote.create(user: user, voteable_id: (send(:"#{resource}")).id,
                            voteable_type: objectify(resource), value: 1
                           )
              }
    end
  end

  def create_resources
    # This array order should be maintained because these resources are interdependent
    %w(question answer comment tag resource_tag vote).each do |resource|
      fields = { content: content, user: user }
      fields.merge!(title: title) if resource == "question"
      fields.merge!(question: question) if resource == "answer"
      if ["question", "answer"].include? resource
        20.times{ objectify(resource).create(fields) }
      elsif resource == "comment"
        create_comments(fields)
      elsif resource == "tag"
        10.times{ objectify(resource).create(name: title) }
      elsif resource == "resource_tag"
        create_resource_tags
      elsif resource == "vote"
        create_votes
      end
    end
  end

  def destroy_resources
    %w(user question answer comment tag resource_tag vote).
      each { |resource| objectify(resource).destroy_all }
  end

  def create_all
    destroy_resources
    create_users
    create_resources
  end
end

Seed.new.create_all
