module ProductsHelper
  def products_index_header
    if params[:search].present?
      %(Search results for "#{params[:search]}")
    else
      "All Products for sale"
    end
  end
end
