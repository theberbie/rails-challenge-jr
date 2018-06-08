class MessagesController < ApplicationController

  def new
    @message = Message.new
  end

  def create
    @message = Message.create(message_params)
    if @message.invalid?
      flash[:error] ="<strong> Please fix the following error(s):</strong> #{@message.errors.full_messages}."
      redirect_to new_message_path
    else
      redirect_to show_message_path(@message.token)
    end
  end

  def show
    @message = Message.find_by(token: params[:token])
  end

  def view_message
    @message = Message.where("url_tokens @> ARRAY[?]::varchar[]", "#{params[:auth]}").last
    if @message.nil?
      @message = nil
      @warn_deletion = "MESSAGE WAS DELETED OR DOES NOT EXIST"
    elsif
      @message.password_digest != ""
      redirect_to authenticate_viewer_path(params[:auth])
    else
      @warn_deletion ="This message will be deleted when you refresh."
      @message.update_attribute(:url_tokens, @message.url_tokens - [params[:auth]])
    end
 end

  def add_url
    @message = Message.find_by(token: params[:token])
    @url_tokens = @message.url_tokens
    @url_token = SecureRandom.uuid
    @message.update_attribute(:url_tokens, @message.url_tokens << @url_token)
    redirect_to show_message_path(@message.token)
  end

  def authenticate_viewer
    @message = Message.where("url_tokens @> ARRAY[?]::varchar[]", "#{params[:auth]}").last
    if @message.nil?
      @message = nil
      @warn_deletion ="MESSAGE WAS DELETED OR DOES NOT EXIST."
    end
     @auth = params[:auth]
  end

  def viewer_authenticated
    @message = Message.where("url_tokens @> ARRAY[?]::varchar[]", "#{params[:format]}").last
    @auth = params[:format]
    if !@message.nil? && @message.password_digest === params[:message][:password]
      @authenticated = true
      @warn_deletion ="This message will be deleted when you refresh."
      redirect_to view_secure_message_path(@auth)
    else
      flash[:error] ="Please verify the password and try again."
       redirect_to authenticate_viewer_path(@auth)
    end
  end

  def view_secure_message
    @message = Message.where("url_tokens @> ARRAY[?]::varchar[]", "#{params[:auth]}").last
    if @message.nil?
      @message = nil
      @warn_deletion="MESSAGE WAS DELETED OR DOES NOT EXIST."
      puts "MESSAGE IS NIL"
    else
      puts "MESSAGE FROM VIEWER IS #{@message.inspect}"
      @message.update_attribute(:url_tokens, @message.url_tokens - [params[:auth]])
    end
  end

  private

  def message_params
    params.require(:message).permit(:body, :email, :token, :password_digest, :tos_accepted)
  end
end
