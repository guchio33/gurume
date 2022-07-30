module Api
    module V1
        class OrdersController < ApplicationController
            def create
                posted_line_foods = LineFood.where(id: params[:line_food_ids])#複数の仮注文
                order = Order.new( #orderインスタンスを生成 → Orderモデルでは、トランザクションが行われている .

                    total_price: total_price(posted_line_foods),
                )
                if order.save_with_update_line_foods!(posted_line_foods)
                    render json: {}, status: :no_content #空データ
                else
                    render json: {}, status: :internal_server_error #失敗した場合
                end 
            end


            private
            def total_price(posted_line_foods)
                posted_line_foods.sum {|line_food| line_food.total_amount} + posted_line_foods.first.restaurant.fee
            end

        end
    end
end