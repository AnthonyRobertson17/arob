# frozen_string_literal: true

class ExerciseTypesController < ApplicationController
  before_action :set_exercise_type, only: [:show, :edit, :update, :destroy]
  before_action :set_exercise_type_tags, only: [:new, :edit]

  # GET /exercise_types
  def index
    @exercise_types = users_exercise_types.all
  end

  # GET /exercise_types/1
  def show; end

  # GET /exercise_types/new
  def new
    @exercise_type = ExerciseType.new
  end

  # GET /exercise_types/1/edit
  def edit; end

  # POST /exercise_types
  def create
    @exercise_type = ExerciseType.new(exercise_type_params.merge(user: current_user))

    if @exercise_type.save
      redirect_to @exercise_type, notice: I18n.t("exercise_types.flash.success.create")
    else
      set_exercise_type_tags
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /exercise_types/1
  def update
    if @exercise_type.update(exercise_type_params)
      redirect_to @exercise_type, notice: I18n.t("exercise_types.flash.success.update")
    else
      set_exercise_type_tags
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /exercise_types/1
  def destroy
    @exercise_type.destroy
    redirect_to exercise_types_url, notice: I18n.t("exercise_types.flash.success.destroy")
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_exercise_type
    @exercise_type = users_exercise_types.find(params[:id])
  end

  def set_exercise_type_tags
    @exercise_type_tags = ExerciseTypeTag.for_user(current_user).all.order(name: :desc)
  end

  # Only allow a list of trusted parameters through.
  def exercise_type_params
    params.require(:exercise_type).permit([:name, { tag_ids: [] }])
  end

  def users_exercise_types
    ExerciseType.for_user(current_user)
  end
end