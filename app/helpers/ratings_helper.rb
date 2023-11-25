module RatingsHelper
  # @param [Numeric] rating The rating to display.
  # @param [Integer] max The maximum number of stars to display.
  # @return [Array<Integer>] An array containing the number of full stars,
  #   half stars, and empty stars to display.
  def num_stars(rating, max = 5)
    full, half = (rating * 2).round.divmod 2
    [full, half, max - full - half]
  end

  # @param [Numeric] rating The rating to display.
  # @param [Integer] max The maximum number of stars to display.
  # @return [Array<String>] An array of icon names for the stars to display.
  def star_names(rating, max = 5)
    full, half, empty = num_stars(rating, max)
    ["star-fill"] * full + ["star-half-fill"] * half + ["star"] * empty
  end

  # Renders the application/rating_stars partial.
  def rating_stars(rating, **options)
    render "application/rating_stars", rating: rating, **options
  end
end
