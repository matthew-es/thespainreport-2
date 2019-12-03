class FramesController < ApplicationController
  before_action :set_frame, only: [:show, :edit, :update, :destroy]
  
  def frame_elements
    @languages = Language.all.order(:name)
    @frames = Frame.original.order(:created_at)
  end
  
  def index
    if current_user.nil? 
			redirect_to root_url
		elsif current_user.status == 1
			frame_elements
		else
			redirect_to root_url
		end
  end

  def show
    if current_user.nil? 
			redirect_to root_url
		elsif current_user.status == 1
			
		else
			redirect_to root_url
		end
  end

  def new
    if current_user.nil? 
			redirect_to root_url
		elsif current_user.status == 1
			@frame = Frame.new
      frame_elements
		else
			redirect_to root_url
		end
  end

  def edit
    if current_user.nil? 
			redirect_to root_url
		elsif current_user.status == 1
			frame_elements
		else
			redirect_to root_url
		end
  end

  def create
    @frame = Frame.new(frame_params)

    respond_to do |format|
      if @frame.save
        format.html { redirect_to @frame, notice: 'Frame was successfully created.' }
        format.json { render :show, status: :created, location: @frame }
      else
        format.html { render :new }
        format.json { render json: @frame.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @frame.update(frame_params)
        format.html { redirect_to edit_frame_path(@frame), notice: 'Frame was successfully updated.' }
        format.json { render :show, status: :ok, location: @frame }
      else
        format.html { render :edit }
        format.json { render json: @frame.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @frame.destroy
    respond_to do |format|
      format.html { redirect_to frames_url, notice: 'Frame was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_frame
      @frame = Frame.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def frame_params
      params.require(:frame).permit(
        :button_cta, :image, :emotional_quest_action, :emotional_quest_role, :short_story, :money_word_singular, 
        :money_word_plural, :money_word_verb, :link_slug, :social_proof,:risk_reversal, :language_id, :original_id,
        :access_patrons_only, :access_more_for_patrons, :access_readers_to_patrons, :access_patrons_below_10, :access_patrons_below_25, :access_patrons_above_25
        )
    end
end