class PaginationPresenter
  include Rails.application.routes.url_helpers

  attr_reader :resource

  def initialize(resource)
    @resource= resource
  end

  def meta
    {
      total: total_resources,
      total_pages: total_pages,
      current_page: current_page,
      is_first_page: is_first_page?,
      is_last_page: is_last_page?,
      previous_page: previous_page,
      next_page: next_page,
      out_of_bounds: out_of_bounds?,
      # next_offset: offset,
    }
  end

  private
    def total_resources
      resource.total_entries
    end

    def current_page
      resource.current_page
    end

    def total_pages
      resource.total_pages
    end

    def is_first_page?
      resource.current_page == 1
    end

    def is_last_page?
      resource.next_page.blank?
    end

    def previous_page
      page_number = resource.previous_page
      page_url(page_number)
    end

    def next_page
      page_number = resource.next_page
      page_url(page_number)
    end

    def out_of_bounds?
      resource.out_of_bounds?
    end

    def offset
      resource.offset
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
