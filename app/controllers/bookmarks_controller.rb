class BookmarksController < ApplicationController
  before_action :set_bookmark, only: :destroy

  # GET /bookmarks　トグル切り替え
  def index
    type = params[:type] || "Vocabulary"
    @active_tab = type

    case type
    when "Vocabulary"
      @bookmarks = current_user.bookmarks.where(bookmarkable_type: "Vocabulary")
                                         .includes(:bookmarkable)
                                         .page(params[:page]).per(10)
    when "Sentence"
      @bookmarks = current_user.bookmarks.where(bookmarkable_type: "Sentence")
                                         .includes(:bookmarkable)
                                         .page(params[:page]).per(10)
    end
  end

  # POST /bookmarks
  def create
    bookmarkable = find_bookmarkable!
    bookmark = current_user.bookmarks.find_or_initialize_by(bookmarkable: bookmarkable)
    @record = bookmarkable

    if bookmark.persisted? || bookmark.save
      respond_to do |format|
        format.turbo_stream { render :create }
        format.html { redirect_back fallback_location: bookmarks_path, notice: t("flash.bookmarks.create.success", default: "お気に入りに追加しました") }
        format.json { head :ok }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace(dom_id(@record, :bookmark_star), partial: "bookmarks/star", locals: { record: @record }) }
        format.html { redirect_back fallback_location: bookmarks_path, alert: t("flash.bookmarks.create.failure", default: "お気に入りに追加できませんでした") }
        format.json { render json: { error: "unprocessable" }, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bookmarks/:id
  def destroy
    @record = @bookmark.bookmarkable
    @bookmark.destroy

    respond_to do |format|
      format.turbo_stream { render :destroy }
      format.html { redirect_back fallback_location: bookmarks_path, notice: t("flash.bookmarks.destroy.success", default: "お気に入りを削除しました") }
      format.json { head :ok }
    end
  end

  private

  # 許可するモデルだけを通す（安全な constantize）
  ALLOWED_TYPES = %w[Vocabulary Sentence].freeze

  def find_bookmarkable!
    type = params.require(:bookmarkable_type)
    id   = params.require(:bookmarkable_id)
    raise ActiveRecord::RecordNotFound unless ALLOWED_TYPES.include?(type)
    type.constantize.find(id)
  end

  def set_bookmark
    @bookmark = current_user.bookmarks.find(params[:id])
  end

end
