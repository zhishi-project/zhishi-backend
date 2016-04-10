class PaginationPresenter
  include Rails.application.routes.url_helpers

  attr_reader :resource

  # This presenter can only work with paginated resources
  def initialize(resource)
    raise NonPaginatedResourceError.new("Resource is not a Paginated Resource") unless resource.respond_to? :total_entries
    @resource= resource
  end

  def meta
    {
      total_records: total_entries,
      total_pages: total_pages,
      current_page: current_page,
      is_first_page: first_page?,
      is_last_page: last_page?,
      previous_page: previous_url,
      next_page: next_url,
      out_of_bounds: out_of_bounds?
    }
  end

  private
    def first_page?
      resource.current_page == 1
    end

    def last_page?
      resource.next_page.blank?
    end

    def previous_url
      page_url(previous_page)
    end

    def next_url
      page_url(next_page)
    end

    def page_url(page_number)
      send("#{resource.model_name.route_key}_path", page: page_number)
    end

    def method_missing(method_name, *args, &block)
      if resource.respond_to? method_name
        resource.send(method_name, *args, &block)
      else
        super
      end
    end

    def respond_to_missing?(method_name, *)
      resource.respond_to?(method_name) || super
    end
end
