class LineFood < ApplicationRecord
  belongs_to :food
  belongs_to :restaurant
  belongs_to :order, optional: true  #関連付け任意

  validates :count, numericality: { greater_than: 0 }

  scope :active, -> { where(active: true) } #acutiveがtrueのものと返す
  scope :other_restaurant, -> (picked_restaurant_id) { where.not(restaurant_id: picked_restaurant_id) } #他の店舗のLineFoodがあるかないか探す

  def total_amount #コントローラーではなく、モデルに記述することで、様々な箇所から呼び出すことができる。
    food.price * count
  end
end