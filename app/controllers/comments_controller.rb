class CommentsController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :authenticate_user!
  before_action :set_comment, only: [ :edit, :update, :destroy, :show, :upvote, :downvote ]
  before_action :set_submission

  def new
  end

  def create
    @comment = @submission.comments.new(comment_params)
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        SubmissionMailer.with(comment: @comment, submission: @submission).new_response.deliver_later(wait: 10.seconds)
        format.turbo_stream
        format.html { redirect_to submission_path(@submission), notice: "Comment created successfully." }
      else
        format.turbo_stream
        format.html { redirect_to submission_path(@submission), alert: "Comment could not be created." }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.turbo_stream
        format.html { redirect_to submission_path(@submission), notice: "Comment updated successfully." }
      else
        format.turbo_stream
        format.html { redirect_to submission_path(@submission), alert: "Comment could not be updated." }
      end
    end
  end

  def destroy
    @comment.destroy
    redirect_to submission_path(@submission)
  end

  def show
  end

  def upvote
    respond_to do |format|
      unless current_user.voted_for? @comment
        Rails.logger.info "User #{current_user.id} is upvoting Comment #{@comment.id}"
        @comment.upvote_by current_user
        format.turbo_stream { render turbo_stream: turbo_stream.replace("#{dom_id(@comment)}_vote_count", @comment.total_vote_count) }
      else
        Rails.logger.warn "User #{current_user.id} tried to upvote Comment #{@comment.id} twice"
        format.html do
          Rails.logger.debug "HTML redirect triggered"
          redirect_back fallback_location: root_path,
          alert: "You have already voted for this comment."
        end
      end
    end
  end

  def downvote
    respond_to do |format|
      unless current_user.voted_for? @comment
        @comment.downvote_by current_user
        format.turbo_stream { render turbo_stream: turbo_stream.replace("#{dom_id(@comment)}_vote_count", @comment.total_vote_count) }
      else
        Rails.logger.error "Creating user with params: #{current_user.voted_for? @comment}"
        format.html { redirect_to submission_path(@submission), alert: "You have already voted for this comment." }
      end
    end
  end

  private

    def set_submission
      @submission = Submission.find(params[:submission_id])
    end

    def set_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:reply, :submission_id)
    end
end
