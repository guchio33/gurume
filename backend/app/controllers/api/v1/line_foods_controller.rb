module Api
    module V1
        class LineFoodsController < ApplicationController
            #フィルタアクション
            before_action :set_food, only: %i[create replace]
            
            #仮注文の一覧
            def index 
                line_foods = LineFood.active

                if line_foods.exists? #line_foodsが DBに存在するかどうか？
                    render json: {
                        line_food_ids: line_foods.map{|line_food| line_food.id},
                        line_foods[0].restaurant,
                        count: line_foods.sum { |line_food| line_food[:count]}
                        amount: line_foods.sum { |line_food| line_food.total_amount }                        
                    }
                else
                     render json: {}, status: :no_content
                end
            end

            #仮注文の作成
            def create
                #例外処理
                if LineFood.active.other_restaurant(@ordered_food.restaurant.id).exists?
                    return render json: {
                        existing_restaurant: LineFood.other_restaurant(@ordered_food.restaurant.id).first.restaurant.name,
                        new_restaurant: Food.find(params[:food_id]).restaurant.name,
                    }, status: :not_acceptable
                end

                #正常処理　line_foodインスタンスを生成
                set_line_food(@ordered_food)

                if @line_food.save
                    render json: {
                        line_food: @line_food
                    }, status: :created
                else
                    render json: {}, status: :internal_server_error
                end
            end

            #例外処理
            def replace
                LineFood.active.other_restaurant(@ordered_food.restaurant.id).each do |line_food|
                    line_food.update_attribute(:active, false)
                end

                set_line_food(@ordered_food)

                if @line_food.save
                    render json: {
                        line_food: @line_food
                    }, status: created
                else
                    render json: {},status: :internal_server_error
                end

            end



            private
            def set_food
                @ordered_food = Food.find(params[:food_id])
            end

            def set_line_food(ordered_food)
                if ordered_food.line_food.present?  #インスタンスの既存の情報を更新
                    @line_food =ordered_food.line_food
                    @line_food.attributes = {
                        count: orderd_food.line_food.count + params[:count],
                        active: true
                    }
                else  #インスタンスを新規作成
                    @line_food = ordered_food.build_line_food(
                        count: params[:count],
                        restaurant: orders_food.restaurant,
                        active: true 
                    )
                end
            end
        end
    end
end