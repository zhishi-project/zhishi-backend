class SeedHelper
  def objectify(model)
    return model.titleize.constantize unless model.include? "_"
    model.split("_").map(&:capitalize).join.constantize
  end

  def get_offset(model)
    @model = objectify(model)
    rand((@model.first.id)..(@model.last.id))
  end

  %w(user question answer comment tag vote).each do |model|
    define_method(:"#{model}") do
      objectify(model).find_by_id(get_offset(model))
    end
  end

  def content
    Faker::Lorem.sentence
  end

  def title
    Faker::Lorem.word
  end

  def number
    Faker::Number.between(1, 200)
  end
end