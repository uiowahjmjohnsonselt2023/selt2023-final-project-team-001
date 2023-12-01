module StorefrontHelper
  def storefronts_index_header
    if params[:search].present?
      %(Storefronts matching "#{params[:search]}")
    else
      "All Storefronts"
    end
  end

  def no_products_message
    if params[:search].present?
      "No storefronts matched your search."
    else
      "There are no storefronts to display."
    end
  end
end
