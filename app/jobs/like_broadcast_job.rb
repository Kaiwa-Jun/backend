class LikeBroadcastJob < ApplicationJob
  queue_as :default

  def perform(like)
    ActionCable.server.broadcast 'likes_channel', like: render_like(like)
  end

  private

  def render_like(like)
    ApplicationController.renderer.render(partial: 'likes/like', locals: { like: like })
  end
end
