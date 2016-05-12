class NestedResourcePaginationPresenter < PaginationPresenter
  attr_reader :default_params

  def initialize(resource, default_params = {})
    @default_params = default_params
    super(resource)
  end

  def page_url(page_number)
    with_page_number = default_params.merge(page: page_number)
    send("#{resource.route_key}_path", with_page_number)
  end

end
