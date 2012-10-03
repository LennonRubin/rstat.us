module Api
  class FriendshipsController < ApplicationController
    #
    # Disable CSRF protection
    #
    # XXX we're kinda reaching into protect_from_forgery here.
    #
    skip_before_filter :verify_authenticity_token

    #
    # TODO replace with OAuth goodness.
    #
    before_filter :require_user

    #
    # POST /api/statuses/update.json
    #
    def create
      
      u = requested_user!
      
    end
    
    protected
    
    # TODO this method is copied from the api/status_controller  Needs to be moved to a shared file 
    
    def requested_user!
      if params[:user_id].blank? && params[:screen_name].blank?
        #
        # TODO this is an assumption. Verify against Twitter API.
        #
        raise BadRequest, "You must specify either user_id or screen_name"
      elsif !params[:user_id].blank? && !params[:screen_name].blank?
        #
        # TODO verify if/how Twitter deals with this. Edge case, anyway.
        #
        raise BadRequest, "You can't specify both user_id and screen_name"
      end

      #
      # Try to find a user by user_id first, then screen_name
      #
      user = nil
      user = User.first(params[:user_id]) if !params[:user_id].blank?
      if user.nil?
        if !params[:screen_name].blank?
          user = User.first(:username => params[:screen_name])
          if user.nil?
            raise NotFound, "User does not exist: #{params[:screen_name]}"
          end
        else
          raise NotFound, "User ID does not exist: #{params[:user_id]}"
        end
      end

      user
    end
    
    
  end
end