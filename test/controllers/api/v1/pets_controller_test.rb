# frozen_string_literal: true

require 'test_helper'

module Api
  module V1
    class PetsControllerTest < ActionDispatch::IntegrationTest
      setup do
        @api_v1_pet = api_v1_pets(:one)
      end

      test 'should get index' do
        get api_v1_pets_url, as: :json
        assert_response :success
      end

      test 'should create api_v1_pet' do
        assert_difference('Api::V1::Pet.count') do
          post api_v1_pets_url, params: { api_v1_pet: {} }, as: :json
        end

        assert_response :created
      end

      test 'should show api_v1_pet' do
        get api_v1_pet_url(@api_v1_pet), as: :json
        assert_response :success
      end

      test 'should update api_v1_pet' do
        patch api_v1_pet_url(@api_v1_pet), params: { api_v1_pet: {} }, as: :json
        assert_response :success
      end

      test 'should destroy api_v1_pet' do
        assert_difference('Api::V1::Pet.count', -1) do
          delete api_v1_pet_url(@api_v1_pet), as: :json
        end

        assert_response :no_content
      end
    end
  end
end
