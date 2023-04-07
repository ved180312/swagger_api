# frozen_string_literal: true

module Api
  module V1
    # PetsController
    class PetsController < ApplicationController
      before_action :set_pet, only: %i[show update destroy detail]

      def popular
        # @pets = Pet.order(name: :desc).limit(10)
        @pets = Pet.where(name: :null).count
        render json: @pets #{message: "ved"}
      end

      def detail
        @pet.name = @pet.name.upcase 
        render json: @pet
      end

      def index
        # @pets = Pet.all
        # render json: @pets
        @pets = Pet.all.map {|pet| pet_to_hash(pet)}
        render json: @pets
      end

      def show
        render json: @pet
      end

      def create
        @pet = Pet.new(pet_params)
        if @pet.save
          render json: @pet
        else
          render json: @pet.errors, status: :unprocessable_entity
        end
      end

      def update
        if @pet.update(pet_params)
          render json: @pet
        else
          render json: @pet.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @pet.destroy
      end

      private

      def set_pet
        @pet = Pet.find(params[:id])
      end

      def pet_params
        params.fetch(:pet).permit(:name, :status, :photo_url)
      end

      def pet_to_hash(pet)
        {
          name: pet.name,
          status: pet.status,
          photo_url: "https://example.com#{pet.photo_url}"
        }
      end
    end
  end
end
