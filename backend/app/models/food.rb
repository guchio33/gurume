class Food < ApplicationRecord
    belongs_to :restaurant
    belongs_to :order, optional: true #関連付け任意
    has_one :line_food

end 