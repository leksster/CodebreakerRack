require 'erb'
require 'Codebreaker'

class Racker
  def self.call(env)
    new(env).response.finish
  end

  def initialize(env)
    @request = Rack::Request.new(env)
  end

  def response
    case @request.path
    when "/" then index
    when "/guess" then guess
    when "/start" then start
    when "/hint" then hint_count
    else Rack::Response.new("404", 404)
    end
  end

  def render(template)
    path = File.expand_path("../views/#{template}", __FILE__)
    ERB.new(File.read(path)).result(binding)
  end

  def index
    @request.session[:codebreaker] = Codebreaker::Model.new
    game.start
    Rack::Response.new(render("index.html.erb")) do |response|
      response.set_cookie("hints", game.instance_variable_get(:@hints))
      response.set_cookie("attempts", game.instance_variable_get(:@tries))
    end
  end

  def guess
    Rack::Response.new do |response|
      p @request.session[:codebreaker]
    end
  end

  def game
    @request.session[:codebreaker]
  end

  def start 
    Rack::Response.new do |response|
      @request.session.clear
      response.delete_cookie("user_guess")
      @request.session[:game] = Codebreaker::Model.new
      @game = @request.session[:game]
      @game.start
      response.set_cookie("code", @game)
      response.redirect("/")
    end
  end




  def hint_count

  end

  def check
    begin
      @request.cookies[:game].submit(@request.cookies["user_guess"])
    rescue ArgumentError => e
      e
    rescue NoMethodError => e
      e
    end
  end

  def user_guesses
    list = []
    list << @request.cookies["user_guess"]
    list
    @game.instance_variable_get(:@code)
  end

end