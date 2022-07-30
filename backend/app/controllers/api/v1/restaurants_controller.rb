module Api
    module V1
        class RestaurantsController < ApplicationController
            def index
                restaurants = Restaurant.all
                
                render json:{
                    resutarants: restaurants
                }, status: :ok
            end
        end     
    end
end

    
