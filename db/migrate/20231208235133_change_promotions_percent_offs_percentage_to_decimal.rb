class ChangePromotionsPercentOffsPercentageToDecimal < ActiveRecord::Migration[7.1]
  def up
    # Fractional percentage, i.e. 100% = 1.00.
    # Allows for 1 digit before the decimal and 6 digits after.
    change_column :promotions_percent_offs, :percentage, :decimal, precision: 7, scale: 6
  end

  def down
    change_column :promotions_percent_offs, :percentage, :integer
  end
end
