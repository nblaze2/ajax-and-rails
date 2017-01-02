require "rails_helper"

RSpec.describe Api::V1::CommentsController, type: :controller do
  xdescribe "GET /api/v1/comments" do
    it "retrieves the ten most recent comments" do
      create_list(:comment, 10)
      comments = create_list(:comment, 10)

      get :index
      json = JSON.parse(response.body)
      ids = json.map { |c| c["id"] }

      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:ok)
      expect(ids).to match_array(comments.map(&:id))
    end

    it "retrieves comments associated with a video" do
      video = create(:video)
      comments = create_list(:comment, 5, video: video)
      create_list(:comment, 5)

      get :index, params: { video_id: video.id }
      json = JSON.parse(response.body)
      ids = json.map { |c| c["id"] }

      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:ok)
      expect(ids).to match_array(comments.map(&:id))
    end
  end

  xdescribe "GET /api/v1/comments/:id" do
    it "retrieves a single comment" do
      comment = create(:comment)

      get :show, params: { id: comment.id }
      json = JSON.parse(response.body)

      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:ok)
      expect(json["id"]).to eq(comment.id)
      expect(json["title"]).to eq(comment.title)
      expect(json["content"]).to eq(comment.content)
    end
  end

  # Add the comment creation test here

end
