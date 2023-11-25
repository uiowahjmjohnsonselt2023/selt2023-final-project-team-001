module ProductsHelper
  def products_index_header
    if params[:search].present?
      %(Search results for "#{params[:search]}")
    elsif params[:category].present?
      title = "Showing products in "
      Category.where(id: params[:category]).each do |c|
        title += c.name
      end
      title
    else
      "All Products for sale"
    end
  end
end
