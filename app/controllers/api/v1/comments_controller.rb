# frozen_string_literal: true

module Api
  module V1
    # CommentsController
    class CommentsController < ApplicationController
      before_action :set_comment, only: %i[show update destroy]

      def index
        if params[:pet_id]
          @comment = Pet.find(params[:pet_id]).comments
          render json: @comment
        elsif (@comments = Comment.all)
          render json: @comments
        end
      end

      def show
        @comment = Comment.find(params[:id])
        render json: @comment
      end

      def create
        @pet = Pet.find(params[:pet_id])
        @comment = @pet.comments.new(comment_params)
        if @comment.save
          render json: @comment
        else
          render json: @comment.errors, status: :unprocessable_entity
        end
      end

      def update
        if @comment.update(comment_params)
          render json: @comment
        else
          render json: @comment.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @comment.destroy
      end

      private

      def set_comment
        @comment = Comment.find(params[:id])
      end

      def comment_params
        params.require(:comment).permit(:content)
      end
    end
  end
end
