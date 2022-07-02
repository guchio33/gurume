class Restaurant < ApplicationRecord
    has_many :foods
    has_many :linefood, through: :foods
    
    validates :name, :fee, :time_required, presence: true #カラムのデータが必ず存在する
    validates :name, length: {maxmin: 30} #最大30文字以下
    validates :fee, numericality: { greater_than: 0 } #0以上

end