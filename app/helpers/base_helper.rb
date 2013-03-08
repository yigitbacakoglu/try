module BaseHelper
  # rating_for(@object)
  def rating_for(rateable_obj, options={})

    rateable_obj.ratings.build if rateable_obj.ratings.blank?
    category = rateable_obj.rating_category

    rating_tool = category.name
    rating_max_value = category.max_value
    avg_rate = number_with_precision rateable_obj.avg_rate, :precision => 2

    content_tag :div, "", :class => "star", "data-rating" => avg_rate,
                "data-id" => rateable_obj.id, "data-classname" => rateable_obj.class.name.to_s.downcase,
                "data-star-count" => rating_max_value, "data-url" => options[:url]
  end

  def comment_form(object, url, method = "POST")
    render :partial => "shared/comment_form", :locals => {:object => object, :url => url, :method => method}
  end

  # Make an admin tab that coveres one or more resources supplied by symbols
  # Option hash may follow. Valid options are
  #   * :label to override link text, otherwise based on the first resource name (translated)
  #   * :route to override automatically determining the default route
  #   * :match_path as an alternative way to control when the tab is active, /products would match /admin/products, /admin/products/5/variants etc.
  def tab(*args)

    options = {:label => args.first.to_s}
    if args.last.is_a?(Hash)
      options = options.merge(args.pop)
    end
    options[:route] ||= "admin_#{args.first}"

    destination_url = options[:url]

    #titleized_label = t(options[:label], :default => options[:label]).titleize
    titleized_label = options[:label].titleize

    if options[:icon]
      link = link_to("
                   <span class='icon'>
                      <i class='icon-#{options[:icon]}'></i>
                   </span>
                   <span class='text'> #{titleized_label}</span>".html_safe,
                     destination_url)
    else
      link = link_to(titleized_label, destination_url) unless options[:icon]
    end

    css_classes = []

    #logger.info ("request.fullpath=  " + request.fullpath)
    #logger.info ("match_path......=  " + (options[:match_path] ? options[:match_path] : ""))

    selected = if options[:match_path]
                 ## TODO: `request.fullpath` for engines mounted at '/' returns '//'
                 ## which seems an issue with Rails routing.- revisit issue #910
                 #request.fullpath.gsub('//', '/').starts_with?("#{root_path}admin#{options[:match_path]}")
                 request.fullpath.gsub('//', '/').match(options[:match_path]).to_s == request.fullpath
               else
                 args.include?(controller.controller_name.to_sym)
               end
    css_classes << 'active' if selected

    if options[:css_class]
      css_classes << options[:css_class]
    end
    content_tag('li', link, :class => css_classes.join(' '))
  end


end