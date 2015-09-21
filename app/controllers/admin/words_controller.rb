class Admin::WordsController < ApplicationController
  before_action :admin_user, only: [:new, :edit, :update, :create]

  def new
    @categories = Category.all
    @word = Word.new
    @word.choices.new
  end

  def create
    @word = Word.new word_params
    if @word.save
      flash[:success] = t :word_created
      redirect_to words_path
    else
      @categories = Category.all
      render :new
    end
  end

  def edit
    @categories = Category.all
    @word = Word.find params[:id]
  end

  def update
    @word = Word.find params[:id]
    if @word.update_attributes(word_params)
      flash[:success] = t :word_updated
      redirect_to words_path
    else
      render :edit
    end
  end

  def import
    if params[:file].present?
      Word.import params[:file]
      flash[:success] = t :word_created
      redirect_to admin_words_path
    else
      flash[:alert] = "fail"
      @categories = Category.all
      @word = Word.new
      @word.choices.new
      render :new
    end

  end

  private
  def word_params
    params.require(:word).permit(:content, :pronunciation, :category_id, choices_attributes: [:id, :content, :correct, :_destroy])
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
